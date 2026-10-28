-- lib: runner -- run the current buff

---@class Runner
---@field cmd string[]|fun(bufnr: integer): string[]
---@field name string
---@field stdin boolean
---@field output_filetype string

local M = {}

---@type table<string, Runner>
M.runners = {}

---@type table<string, string>
local defaultLinks = {
	RunnerNormal = "NormalFloat",
	RunnerBorder = "FloatBorder",
	RunnerTitle = "FloatTitle",
	RunnerError = "DiagnosticError",
	RunnerWarn = "DiagnosticWarn",
	RunnerHint = "DiagnosticHint",
}

for name, target in pairs(defaultLinks) do
	vim.api.nvim_set_hl(0, name, { link = target, default = true })
end

---@class RunnerPadding
---@field top integer
---@field right integer
---@field bottom integer
---@field left integer

---@type RunnerPadding
local padding = { top = 1, right = 1, bottom = 0, left = 1 }

local ns = vim.api.nvim_create_namespace("runner")

-- first matching rule wins per line, patterns run on the lowercased line
---@type { hl: string, patterns: string[] }[]
local rules = {
	{
		hl = "RunnerError",
		patterns = { "%f[%w]%w*error%f[%W]%[?%w*%]?", "%f[%w]%w*exception", "traceback", "panicked", "fatal" },
	},
	{ hl = "RunnerWarn", patterns = { "%f[%w]warn%w*", "deprecated" } },
	{ hl = "RunnerHint", patterns = { "%f[%w]note%f[%W]", "%f[%w]help%f[%W]" } },
}

---@param ft string
---@param config { cmd: string[]|fun(bufnr: integer): string[], name?: string, stdin?: boolean }
function M.register(ft, config)
	M.runners[ft] = vim.tbl_extend("force", {
		name = ft,
		output_filetype = ft .. "-output",
		stdin = true,
	}, config)
end

-- only stderr lines are scanned, so stdout text like "error" is never colored
---@param buf integer
---@param lines string[] padded buffer lines
---@param errMask table<integer, boolean> output index -> true when the line came from stderr
---@param offset integer lines added above the output (top padding)
local function highlight(buf, lines, errMask, offset)
	for i, isErr in pairs(errMask) do
		if isErr then
			local row = i + offset
			local lower = lines[row]:lower()
			for _, rule in ipairs(rules) do
				local hit = false
				for _, pattern in ipairs(rule.patterns) do
					local s, e = lower:find(pattern)
					if s then
						vim.api.nvim_buf_set_extmark(buf, ns, row - 1, s - 1, { end_col = e, hl_group = rule.hl })
						hit = true
						break
					end
				end
				if hit then
					break
				end
			end
		end
	end
end

---@param config Runner
---@param lines string[]
---@param isErr table<integer, boolean>
---@param exitCode integer
local function showOutput(config, lines, isErr, exitCode)
	local output, errMask = {}, {}
	for i, l in ipairs(lines) do
		if l ~= "" then
			output[#output + 1] = l
			errMask[#output] = isErr[i]
		end
	end
	if #output == 0 then
		output = { "*no output*" }
	end

	local left = string.rep(" ", padding.left)
	local right = string.rep(" ", padding.right)
	local padded = vim.tbl_map(function(l)
		return left .. l .. right
	end, output)

	for _ = 1, padding.top do
		table.insert(padded, 1, "")
	end
	for _ = 1, padding.bottom do
		table.insert(padded, "")
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, padded)
	highlight(buf, padded, errMask, padding.top)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = config.output_filetype

	local width = 20
	for _, l in ipairs(padded) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		anchor = "SW",
		row = vim.o.lines - vim.o.cmdheight - 1,
		col = 0,
		width = math.min(width, math.floor(vim.o.columns * 0.8)),
		height = math.min(#padded, 12 + padding.top + padding.bottom),
		style = "minimal",
		border = "single",
		title = exitCode == 0 and ("   " .. config.name .. " ") or (" " .. config.name .. " error "),
		title_pos = "left",
	})

	vim.wo[win].winhighlight = "NormalFloat:RunnerNormal,FloatBorder:RunnerBorder,FloatTitle:RunnerTitle"

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
	local lines, isErr = {}, {}

	---@param flag boolean true for stderr
	local function collector(flag)
		return function(_, data)
			for _, l in ipairs(data or {}) do
				lines[#lines + 1] = l
				isErr[#lines] = flag
			end
		end
	end

	local jobId = vim.fn.jobstart(cmd, {
		stdin = config.stdin and "pipe" or "null",
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = collector(false),
		on_stderr = collector(true),
		on_exit = function(_, exitCode)
			vim.schedule(function()
				showOutput(config, lines, isErr, exitCode)
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

M.register("sh", { cmd = { "bash" }, name = "Bash" })
M.register("bash", { cmd = { "bash" }, name = "Bash" })
M.register("zsh", { cmd = { "zsh" }, name = "Zsh" })
M.register("python", { cmd = { "python3", "-" }, name = "Python" })
M.register("lua", { cmd = { "nvim", "-l", "-" }, name = "Neovim Lua" })
M.register("javascript", { cmd = { "node", "-" }, name = "Node.js" })
M.register("typescript", { cmd = { "node", "--experimental-strip-types", "-" }, name = "Node.js TypeScript" })
M.register("rust", { cmd = compileAndRun("rustc --edition 2024 -"), name = "Rust" })
M.register("c", { cmd = compileAndRun("cc -x c -"), name = "C" })
M.register("cpp", { cmd = compileAndRun("c++ -std=c++23 -x c++ -"), name = "C++" })

return M
