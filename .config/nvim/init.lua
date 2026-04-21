-- init.lua

vim.g.mapleader = " " -- maps the leader key
vim.g.maplocalleader = "\\" -- local leader key config

-- disable broken bundled vim treesitter queries on nvim 0.12+
vim.treesitter.query.set("vim", "highlights", "")

require("amal.lazy")
require("amal.core")
