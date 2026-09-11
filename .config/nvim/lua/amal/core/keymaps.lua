-- keymaps.lua

local set = vim.keymap.set

-- general
set("n", "<Leader>s", "<cmd>write!<CR>", { silent = true, desc = "Save current buffer" })
set("n", "Q", "<C-W>q", { desc = "Quit current buffer" })
set("n", "<Leader>q", "<cmd>copen<cr>", { desc = "Toggle quickfix list" })
set("n", "<leader>p", [["*p]], { desc = "Paste from system clipboard" })
set("n", "<leader>/", "<cmd>normal gcc<CR><DOWN>", { silent = true, desc = "Toggle comment line" })
set("v", "<leader>/", "<cmd>normal gcc<CR><DOWN>", { silent = true, desc = "Toggle comment selection" })
set("n", "<Leader>a", "ggVG", { desc = "Select whole document", noremap = true, silent = true })
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search highlight" })
-- set("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })
set("n", "J", "m`J``", { desc = "Join line, keep cursor" })
set("n", "<Leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word in file" })
-- NOTE: make sure to `map ctrl+i send_text all \x1b[105;5u` (kitty)
set("n", "<C-i>", "<C-i>", { desc = "Jump to newer position" })
-- set("n", "[j", "<C-o>", { desc = "Jump to older position" })
-- set("n", "]j", "<C-i>", { desc = "Jump to newer position" })

-- paste over currently selected text without yanking it
set("v", "p", '"_dp', { desc = "Paste without yanking" })
set("v", "P", '"_dP', { desc = "Paste before without yanking" })

-- Move to start/end of line
set({ "n", "x", "o" }, "H", "^", { silent = true, desc = "Go to line start" })
set({ "n", "x", "o" }, "L", "g_", { silent = true, desc = "Go to line end" })

-- neotree config
-- set("n", "<C-n>", "<cmd>Neotree filesystem toggle<CR>", { silent = true, desc = "Toggle file explorer" })
-- set("n", "<C-b>", "<cmd>Neotree reveal<CR>", { silent = true, desc = "Reveal file in explorer" })
set("n", "<C-n>", "<cmd>Lexplore<CR>", { silent = true, desc = "Toggle file explorer" })
set("n", "<C-b>", "<cmd>Lexplore %:p:h<CR>", { silent = true, desc = "Explore current buffer directory" })

-- split screen configs
set("n", "vv", "<C-W>v", { desc = "Vertical split" })
set("n", "ss", "<C-W>s", { desc = "Horizontal split" })

-- indentation (in visual mode)
set("v", "<Tab>", ">gv", { desc = "Indent selection" })
set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- move lines
set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- tabs and buffers
set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })
set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer tab" })
set("n", "]b", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
set("n", "[b", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- size and stuff
set("n", "<C-Up>", "<cmd>resize -2<cr>", { silent = true, desc = "Decrease height" })
set("n", "<C-Down>", "<cmd>resize +2<cr>", { silent = true, desc = "Increase height" })
set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { silent = true, desc = "Decrease width" })
set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { silent = true, desc = "Increase width" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down, keep centered" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up, keep centered" })
set("n", "n", "nzzzv", { desc = "Next search result, centered" })
set("n", "N", "Nzzzv", { desc = "Previous search result, centered" })

-- telescope keymaps
set("n", "<leader>tm", "<cmd>Telescope marks<CR>", { silent = true, desc = "Find marks" })
set("n", "<leader>th", "<cmd>Telescope command_history<CR>", { silent = true, desc = "Command history" })
set("n", "<leader>tk", "<cmd>Telescope keymaps<CR>", { silent = true, desc = "Find keymaps" })

-- cmdline keymaps
set("c", "<C-j>", "<C-n>", { noremap = true, desc = "Next cmdline history" })
set("c", "<C-k>", "<C-p>", { noremap = true, desc = "Previous cmdline history" })

-- wrap toggle
vim.keymap.set("n", "<Leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

-- misc
set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
set("n", "<leader>mdm", ":delmarks!", { desc = "Delete all marks" })
