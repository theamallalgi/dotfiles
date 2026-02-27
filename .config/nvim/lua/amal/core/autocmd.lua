-- autocmd.lua - commands and automations to run with nvim

local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- go to last loc when opening a buffer
-- this means that when you open a file, you will be at the last position
api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
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
api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local warn = function()
			vim.notify("Nuh uh uh! Use the hjkl keys buddy!", vim.log.levels.WARN)
		end

		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<Up>", warn, opts)
		vim.keymap.set("n", "<Down>", warn, opts)
		vim.keymap.set("n", "<Left>", warn, opts)
		vim.keymap.set("n", "<Right>", warn, opts)

		-- vim.keymap.set("i", "<Up>", warn, opts)
		-- vim.keymap.set("i", "<Down>", warn, opts)
		-- vim.keymap.set("i", "<Left>", warn, opts)
		-- vim.keymap.set("i", "<Right>", warn, opts)
	end,
})

-- highlight developer note keywords like TODO, FIXME, etc.
local tag_group = vim.api.nvim_create_augroup("CodeTagHighlights", { clear = true })

-- Keyword to highlight group mapping
local keyword_highlights = {
	TODO = "DiagnosticVirtualTextOk",
	OPTIMIZE = "DiagnosticVirtualTextOk",
	NOTE = "DiagnosticVirtualTextInfo",
	INFO = "DiagnosticVirtualTextInfo",
	FIXME = "DiagnosticVirtualTextError",
	BUG = "DiagnosticVirtualTextError",
	HACK = "DiagnosticVirtualTextWarn",
	XXX = "DiagnosticVirtualTextHint",
}

-- Apply match highlights on buffer events
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "InsertLeave", "TextChanged" }, {
	group = tag_group,
	callback = function()
		for word, hl in pairs(keyword_highlights) do
			local pattern = "\\<" .. word .. "\\>:"
			vim.fn.matchadd(hl, pattern)
		end
	end,
})

-- Custom right click context menu
vim.cmd([[
  anoremenu PopUp.-sep2-                     <Nop>
  anoremenu PopUp.Toggle\ Word\ Wrap         <cmd>set wrap!<CR>
  anoremenu PopUp.Toggle\ Diagnostics        <cmd>lua _G.diagnostics_enabled = not _G.diagnostics_enabled; vim.diagnostic.enable(_G.diagnostics_enabled); require('lualine').refresh()<CR>
]])
