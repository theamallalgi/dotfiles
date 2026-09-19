vim.g.mapleader = " " -- maps the leader key
vim.g.maplocalleader = "\\" -- local leader key config
vim.cmd.colorscheme("catppuccin") -- fallback colors

require("core.settings")
require("core.keymaps")
require("core.autocmd")
require("core.pack")
require("core.options")
require("core.uiconfig")
