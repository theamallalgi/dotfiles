-- settings.lua

-- global variables
_G.diagnostics_enabled = false -- disable diagnostics by default (1)
vim.diagnostic.enable(false) -- disable diagnostics by default (2)

-- indentation config
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- tabline setup
vim.opt.showtabline = 0

-- disable confirmation dialogs
vim.o.confirm = false

-- clipboard
vim.opt.clipboard = "unnamedplus"
-- vim.cmd("set paste") -- deprecated (disables a bunch of features)

-- status bar
vim.opt.conceallevel = 0
vim.opt.cmdheight = 0

-- split screen config (only splits to right and bottom sides)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- netrw config
vim.g.netrw_banner = 0 -- disable the how tos and stuff from netrw window
vim.g.netrw_mouse = 2 -- mouse config for netrw
-- vim.cmd("let g:netrw_liststyle = 3") -- sets the default file explorer style to tree structure

-- spell
-- vim.cmd("set spell")
-- vim.cmd("set spelllang=en")
vim.opt.spelllang = { "en_us" }

-- misc config
vim.o.guifont = "JetBrainsMono Nerd Font:h11" -- sets the default font and height
vim.opt.autoread = true -- updates vim after file update outside
-- vim.opt.statuscolumn = "%s %l %r " -- relative line numbers
vim.opt.number = true -- sets line numbers
vim.opt.relativenumber = true -- sets relative line numbers
vim.opt.wrap = false -- turns off word wrap
vim.opt.fileformat = "unix" -- turns file format to unix style
vim.opt.showmode = false -- disables the ~ symbol (end of buffer indicator)
vim.o.termguicolors = true -- sets proper terminal colors
vim.o.completeopt = "menuone,noselect" -- have a better completion experience
vim.opt.cursorline = true -- sets the cursor line
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true  -- makes search case-sensitive when you use uppercase
vim.opt.numberwidth = 4 -- set number column width to 4 {default 4}
vim.opt.sidescrolloff = 8 -- Makes sure there are always eight lines of context
vim.opt.fillchars = { eob = " " } -- change the character at the end of buffer
vim.opt.signcolumn = "yes" -- fixes sign column jump when diagnostics appear

-- timeout and update config
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 100 -- faster completion (4000ms default)

-- terminal config
vim.g.floaterm_width = 0.7
vim.g.floaterm_height = 0.8
vim.g.floaterm_position = "center"
vim.g.floaterm_title = ""
