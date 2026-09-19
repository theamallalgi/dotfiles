-- lua\core\keymaps.lua

local set = vim.keymap.set

set("n", "<Leader>s", "<cmd>write!<CR>", { silent = true, desc = "Save file" })
set("n", "Q", "<C-W>q!", { desc = "Quit window" })
set("n", "<Leader>q", "<cmd>copen<cr>", { desc = "Toggle quickfix list" })
set({ "n", "v" }, "<leader>/", "<cmd>normal gcc<CR><DOWN>", { silent = true, desc = "Toggle comment line" })
set("n", "<Leader>a", "ggVG", { desc = "Select whole document", noremap = true, silent = true })
set("n", "<Leader>e", "<cmd>Lexp<cr>", { desc = "Open netrw", noremap = true, silent = true })
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search highlight" })
set("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })
set("n", "<leader>p", [["*p]], { desc = "Paste from * Reg" }) -- doesn't work on windows
set("n", "H", [[0]], { desc = "Go to the beginning of the line" })
set("n", "L", [[$]], { desc = "Go to the end of the line" })

-- grep
vim.keymap.set("n", "<leader>gr", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if not pattern or pattern == "" then
			return
		end
		vim.cmd("silent grep! " .. vim.fn.shellescape(pattern))
		vim.cmd("copen")
	end)
end, { desc = "Grep and open quickfix" })

vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Prev quickfix item" })
vim.keymap.set("n", "[t", "<cmd>tabprev<CR>", { desc = "Go to previous tab", noremap = true })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Go to next tab", noremap = true })

-- lazygit
vim.keymap.set("n", "<leader>gg", function()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.fn.jobstart("lazygit", {
		term = true,
		cwd = vim.fn.getcwd(),
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
	vim.cmd("startinsert")
end, { desc = "LazyGit (cwd)" })
