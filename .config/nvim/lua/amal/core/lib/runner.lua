---@class Runner
---@field cmd string[]|fun(bufnr: integer): string[]
---@field name string
---@field stdin boolean
---@field output_filetype string

local M = {}

---@type table<string, Runner>
M.runners = {}

---@param ft string
---@param config { cmd: string[]|fun(bufnr: integer): string[], name?: string, stdin?: boolean }
function M.register(ft, config)
	M.runners[ft] = vim.tbl_extend("force", {
		name = ft,
		output_filetype = ft .. "-output",
		stdin = true,
	}, config)
end

---@param config Runner
---@param lines string[]
---@param exitCode integer
local function showOutput(config, lines, exitCode)
	local output = vim.tbl_filter(function(l)
		return l ~= ""
	end, lines)
	if #output == 0 then
		output = { "*no output*" }
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = config.output_filetype

	local width = 20
	for _, l in ipairs(output) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = math.min(width + 2, math.floor(vim.o.columns * 0.8)),
		height = math.min(#output, 12),
		style = "minimal",
		border = "rounded",
		title = exitCode == 0 and (" " .. config.name .. " ") or (" " .. config.name .. " error "),
		title_pos = "center",
	})

	local close = function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
end

function M.run()
	local ft = vim.bo.filetype
	local config = M.runners[ft]
	if not config then
		vim.notify("runner: no runner for filetype '" .. ft .. "'", vim.log.levels.ERROR)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local cmd = type(config.cmd) == "function" and config.cmd(bufnr) or config.cmd
	local lines = {}

	local collect = function(_, data)
		if data then
			vim.list_extend(lines, data)
		end
	end

	local jobId = vim.fn.jobstart(cmd, {
		stdin = config.stdin and "pipe" or "null",
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = collect,
		on_stderr = collect,
		on_exit = function(_, exitCode)
			vim.schedule(function()
				showOutput(config, lines, exitCode)
			end)
		end,
	})

	if jobId <= 0 then
		vim.notify("runner: failed to start " .. cmd[1], vim.log.levels.ERROR)
		return
	end

	if config.stdin then
		local source = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
		vim.fn.chansend(jobId, source)
		vim.fn.chanclose(jobId, "stdin")
	end
end

---@param compile string compiler command that reads source from stdin
---@return fun(): string[]
local function compileAndRun(compile)
	return function()
		local out = vim.fn.tempname()
		local script = compile .. ' -o "$1" && "$1"; rc=$?; rm -f "$1"; exit $rc'
		return { "sh", "-c", script, "_", out }
	end
end

M.register("sh", { cmd = { "bash" }, name = "bash" })
M.register("bash", { cmd = { "bash" }, name = "bash" })
M.register("zsh", { cmd = { "zsh" }, name = "zsh" })
M.register("python", { cmd = { "python3", "-" }, name = "python" })
M.register("lua", { cmd = { "nvim", "-l", "-" }, name = "nvim lua" })
M.register("javascript", { cmd = { "node", "-" }, name = "node" })
M.register("typescript", { cmd = { "node", "--experimental-strip-types", "-" }, name = "node ts" })
M.register("rust", { cmd = compileAndRun("rustc --edition 2024 -"), name = "rustc" })
M.register("c", { cmd = compileAndRun("cc -x c -"), name = "cc" })
M.register("cpp", { cmd = compileAndRun("c++ -std=c++23 -x c++ -"), name = "c++" })

return M
