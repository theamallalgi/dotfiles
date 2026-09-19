-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NoAutoComment", { clear = true }),
	command = "set formatoptions-=cro",
})

-- go to last loc when opening a buffer
-- this means that when you open a file, you will be at the last position
vim.api.nvim_create_autocmd("BufReadPost", {
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
