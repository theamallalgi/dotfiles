-- autocmd.lua - commands and automations to run with nvim

local api = vim.api

-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NoAutoComment", { clear = true }),
	command = "set formatoptions-=cro",
})

-- go to last loc when opening a buffer
-- this means that when you open a file, you will be at the last position
api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"oil",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- enable spell checking for certain file types
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en_us"
	end,
})

--  warning message when using the arrow keys
local opts = { noremap = true, silent = true }
local warn = function()
	vim.notify("Nuh uh uh! Use the hjkl keys buddy!", vim.log.levels.WARN)
end
vim.keymap.set("n", "<Up>", warn, opts)
vim.keymap.set("n", "<Down>", warn, opts)
vim.keymap.set("n", "<Left>", warn, opts)
vim.keymap.set("n", "<Right>", warn, opts)
-- vim.keymap.set("i", "<Up>", warn, opts)
-- vim.keymap.set("i", "<Down>", warn, opts)
-- vim.keymap.set("i", "<Left>", warn, opts)
-- vim.keymap.set("i", "<Right>", warn, opts)

-- highlight developer note keywords like TODO, FIXME, etc.
local tag_group = vim.api.nvim_create_augroup("CodeTagHighlights", { clear = true })

-- keyword to highlight group mapping
local keyword_highlights = {
	TODO = "DiagnosticVirtualTextOk",
	OPTIMIZE = "DiagnosticVirtualTextOk",
	PERF = "DiagnosticVirtualTextOk",
	NOTE = "DiagnosticVirtualTextInfo",
	INFO = "DiagnosticVirtualTextInfo",
	FIXME = "DiagnosticVirtualTextError",
	FIXIT = "DiagnosticVirtualTextError",
	FIX = "DiagnosticVirtualTextError",
	ISSUE = "DiagnosticVirtualTextError",
	BUG = "DiagnosticVirtualTextError",
	HACK = "DiagnosticVirtualTextWarn",
	WARNING = "DiagnosticVirtualTextWarn",
	WARN = "DiagnosticVirtualTextWarn",
	XXX = "DiagnosticVirtualTextHint",
	STATUS = "DiagnosticVirtualTextOk",
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			if vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
				-- clear only previously set trailing space match
				if vim.b.trailing_match_id then
					pcall(vim.fn.matchdelete, vim.b.trailing_match_id)
				end
				vim.b.trailing_match_id = vim.fn.matchadd("TrailingSpace", [[\s\+$]])
			end
		end,
	}),
}

-- apply match highlights on buffer events
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = tag_group,
	callback = function()
		for word, hl in pairs(keyword_highlights) do
			vim.fn.matchadd(hl, "\\<" .. word .. "\\>:")
		end
	end,
})

_G.toggle_diagnostics = function() -- diagnostics toggle
	_G.diagnostics_enabled = not _G.diagnostics_enabled
	vim.diagnostic.enable(_G.diagnostics_enabled)
	require("lualine").refresh()
end
_G.gitsigns_enabled = false -- gitsigns toggle
_G.toggle_gitsigns = function()
	_G.gitsigns_enabled = not _G.gitsigns_enabled
	local gitsigns = require("gitsigns")
	if _G.gitsigns_enabled then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				gitsigns.attach(buf)
			end
		end
	else
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				gitsigns.detach(buf)
			end
		end
	end
	require("lualine").refresh()
end

-- custom right click context menu
vim.cmd([[
  anoremenu PopUp.-sep2-                     <Nop>
  anoremenu PopUp.Toggle\ Word\ Wrap         <cmd>set wrap!<CR>
  anoremenu PopUp.Toggle\ Diagnostics        <cmd>lua toggle_diagnostics()<CR>
  anoremenu PopUp.Toggle\ Gitsigns           <cmd>lua toggle_gitsigns()<CR>
]])

-- leading space highlight
vim.api.nvim_set_hl(0, "TrailingSpace", { bg = "#201638" }) -- #08313f (pine) #201638 (amethyst)
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			-- clear only previously set trailing space match
			if vim.b.trailing_match_id then
				pcall(vim.fn.matchdelete, vim.b.trailing_match_id)
			end
			vim.b.trailing_match_id = vim.fn.matchadd("TrailingSpace", [[\s\+$]])
		end
	end,
})

-- strip trailing spaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
		-- vim.notify("Trailing whitespace stripped", vim.log.levels.INFO)
	end,
})

-- open help pages vertical spits
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- autoresize split windows (mainly just the help ones, fuck splits)
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- make setup (run code)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.opt_local.makeprg = "bash %"
    vim.opt_local.errorformat = "%f: line %l: %m,%-G%.%#"
  end,
})

-- reduce redraw cost while typing: disable cursorline/relativenumber in insert mode
-- local insert_ui_perf = vim.api.nvim_create_augroup("insert_ui_perf", { clear = true })
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	group = insert_ui_perf,
-- 	callback = function()
-- 		vim.wo.cursorline = false
-- 		vim.wo.relativenumber = false
-- 		vim.wo.number = true -- keep absolute numbers
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	group = insert_ui_perf,
-- 	callback = function()
-- 		vim.wo.cursorline = true
-- 		vim.wo.relativenumber = true
-- 	end,
-- })

-- unlist man page buffers so they don't clutter the buffer list
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("man_unlisted", { clear = true }),
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})
