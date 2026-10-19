-- case: fiddle with cases (vim-abolish?)

---@alias CaseStyle "camel"|"pascal"|"snake"|"kebab"|"constant"|"dot"|"title"|"lower"|"upper"|"sentence"

---@param w string
---@return string
local function cap(w)
	return w:sub(1, 1):upper() .. w:sub(2)
end

---@param word string
---@return string
local function capFirst(word)
	return (word:gsub("^(%p*)(%l)", function(p, c)
		return p .. c:upper()
	end))
end

--- splits camelCase, PascalCase, HTTPServer, snake_case, kebab-case, dot.case, spaces
---@param s string
---@return string[]
local function splitWords(s)
	s = s:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")
	local words = {}
	for w in s:gmatch("[^%s_%-%.]+") do
		words[#words + 1] = w:lower()
	end
	return words
end

---@type table<CaseStyle, fun(w: string[], raw: string): string>
local converters = {
	camel = function(w)
		return vim
			.iter(w)
			:enumerate()
			:map(function(i, x)
				return i == 1 and x or cap(x)
			end)
			:join("")
	end,
	pascal = function(w)
		return vim.iter(w):map(cap):join("")
	end,
	snake = function(w)
		return table.concat(w, "_")
	end,
	kebab = function(w)
		return table.concat(w, "-")
	end,
	constant = function(w)
		return table.concat(w, "_"):upper()
	end,
	dot = function(w)
		return table.concat(w, ".")
	end,
	title = function(w, raw)
		if not raw:find("%s") then
			return vim.iter(w):map(cap):join(" ")
		end
		return (raw:lower():gsub("%S+", capFirst))
	end,
	lower = function(w)
		return table.concat(w, " ")
	end,
	upper = function(w)
		return table.concat(w, " "):upper()
	end,
	sentence = function(w, raw)
		if not raw:find("%s") then
			return cap(table.concat(w, " "))
		end
		local s = raw:lower():gsub("^%l", string.upper)
		return (s:gsub("([%.%?!]%s+)(%l)", function(p, c)
			return p .. c:upper()
		end))
	end,
}

---@param conv fun(w: string[], raw: string): string
---@param text string
---@return string
local function convertLine(conv, text)
	local lead, core, trail = text:match("^([%s%p]*)(.-)([%s%p]*)$")
	if core == "" then
		return text
	end
	return lead .. conv(splitWords(core), core) .. trail
end

vim.api.nvim_create_user_command("Case", function(opts)
	local conv = converters[opts.args]
	if not conv then
		return vim.notify("Unknown case: " .. opts.args, vim.log.levels.ERROR)
	end

	-- no range: word under cursor
	if opts.range == 0 then
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_get_current_line()
		local word, s, e = unpack(vim.fn.matchstrpos(line, [[\k*\%]] .. (col + 1) .. [[c\k*]]))
		if word == "" then
			return
		end
		vim.api.nvim_buf_set_text(0, row - 1, s, row - 1, e, { conv(splitWords(word), word) })
		return
	end

	local sr, sc = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local er, ec = unpack(vim.api.nvim_buf_get_mark(0, ">"))
	local charwise = vim.fn.visualmode() == "v" and sr == opts.line1 and er == opts.line2

	if charwise then
		local last = vim.api.nvim_buf_get_lines(0, er - 1, er, true)[1]
		local extra = #last > 0 and vim.str_utf_end(last, ec + 1) or 0 -- multibyte safe
		ec = math.min(ec + extra + 1, #last)
		local lines = vim.api.nvim_buf_get_text(0, sr - 1, sc, er - 1, ec, {})
		for i, l in ipairs(lines) do
			lines[i] = convertLine(conv, l)
		end
		vim.api.nvim_buf_set_text(0, sr - 1, sc, er - 1, ec, lines)
	else
		local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
		for i, l in ipairs(lines) do
			lines[i] = convertLine(conv, l)
		end
		vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, true, lines)
	end
end, {
	nargs = 1,
	range = true,
	desc = "Convert case of selection or word",
	complete = function(lead)
		return vim
			.iter(vim.tbl_keys(converters))
			:filter(function(k)
				return vim.startswith(k, lead)
			end)
			:totable()
	end,
})

---@type table<string, CaseStyle>
local keymaps = {
	crc = "camel",
	crp = "pascal",
	crs = "snake",
	crk = "kebab",
	["cr-"] = "kebab",
	crU = "constant",
	["cr."] = "dot",
	crt = "title",
	crl = "lower",
	cru = "upper",
	crS = "sentence",
}

local set = vim.keymap.set

set({ "n", "x" }, "<leader>cc", ":Case ", { desc = "Change case of selection or word" })

for lhs, style in pairs(keymaps) do
	local desc = "Case: " .. style
	set("n", lhs, "<cmd>Case " .. style .. "<cr>", { desc = desc })
	set("x", "<leader>" .. lhs, ":Case " .. style .. "<cr>", { desc = "Case: " .. style })
end
