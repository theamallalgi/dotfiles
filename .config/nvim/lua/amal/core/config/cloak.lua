-- secret cloaking: hide secret values on screen
local namespace = vim.api.nvim_create_namespace("cloak")
local cloak_char = "*"
local cloak_length = nil -- nil = mask exact length; a number pads/truncates like cloak.nvim

-- Secret-key stems as a Vim \v alternation. The separator is optional so
-- api_key, api-key, and camelCase apiKey (the common JSON convention, and
-- what auth.json actually uses) all match under \c.
local keys = table.concat({
	"api[-_]?key",
	"secret",
	"client[-_]?secret",
	"token",
	"access[-_]?token",
	"refresh[-_]?token",
	"id[-_]?token",
	"session[-_]?token",
	"authorization",
	"password",
	"passwd",
	"passphrase",
	"pass",
	"private[-_]?key",
	"access[-_]?key",
	"secret[-_]?access[-_]?key",
	"connection[-_]?string",
	"webhook[-_]?secret",
}, "|")

-- file glob -> value pattern. \zs starts the concealed span (the value only).
-- Globs are precompiled with vim.glob (native Lua glob matching, no VimL
-- glob2regpat/match round-trip) since apply() runs on every keystroke.
local rules = vim
	.iter({
		{ files = { "*.env*", "*.vars*", "*.tfvars*", ".envrc" }, pattern = [[\v\c\=\zs.*$]] },
		{ files = { "*.opencode.json", "opencode.json" }, pattern = [[\v\c"apiKey"\s*:\s*"\zs[^"]*]] },
		{
			-- fish secrets file: `set [-flags] VAR value` -> hide the value
			files = { "secrets.fish" },
			pattern = [[\v\c^\s*set\s+(-[a-z]+\s+)?[a-z_][a-z0-9_]*\s+\zs.*]],
		},
		{ files = { "*.toml", "*.yaml", "*.yml" }, pattern = [[\v\c(]] .. keys .. [[)\s*[:=]\s*\zs[^#]*]] },
		{
			files = { "*.json", "*.jsonc", "auth.json", "service.json", ".pi/agent/auth.json", ".opencode/service.json" },
			pattern = [[\v\c"[a-z0-9_-]*(]] .. keys .. [[)[a-z0-9_-]*"\s*:\s*"\zs[^"]*]],
		},
	})
	:map(function(rule)
		rule.matchers = vim.iter(rule.files):map(vim.glob.to_lpeg):totable()
		return rule
	end)
	:totable()

local function patterns_for(name)
	local base = vim.fs.basename(name)
	return vim
		.iter(rules)
		:filter(function(rule)
			return vim.iter(rule.matchers):any(function(m)
				return m:match(base) ~= nil
			end)
		end)
		:map(function(rule)
			return rule.pattern
		end)
		:totable()
end

-- Build the overlay string: `cloak_length` chars of `cloak_char` (or the full
-- span length if unset), padded with spaces so it still fully overlays a
-- longer real span (overlay virt_text only covers its own width).
local function overlay_text(span_len)
	local target = cloak_length or span_len
	local core = cloak_char:rep(math.max(0, target))
	return core .. (" "):rep(math.max(0, span_len - #core))
end

local enabled = true

local function apply(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
	if not enabled then
		return
	end
	local pats = patterns_for(vim.api.nvim_buf_get_name(bufnr))
	if #pats == 0 then
		return
	end
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		for _, pat in ipairs(pats) do
			local _, start_col, end_col = unpack(vim.fn.matchstrpos(line, pat))
			if start_col ~= -1 and end_col > start_col then
				vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, start_col, {
					virt_text = { { overlay_text(end_col - start_col), "Comment" } },
					virt_text_pos = "overlay",
				})
			end
		end
	end
end

-- Debounced: avoids a full buffer rescan on every single keystroke in insert
-- mode, only reapplies 50ms after typing pauses.
local _cloak_timer = nil
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost", "BufEnter", "TextChanged", "TextChangedI" }, {
	callback = function(ev)
		if _cloak_timer then
			_cloak_timer:stop()
			_cloak_timer:close()
		end
		_cloak_timer = vim.defer_fn(function()
			_cloak_timer = nil
			apply(ev.buf)
		end, 50)
	end,
})

vim.keymap.set("n", "<leader>ue", function()
	enabled = not enabled
	apply(0)
end, { desc = "Toggle Cloak" })
