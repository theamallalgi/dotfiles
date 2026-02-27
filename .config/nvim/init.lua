-- init.lua

vim.g.mapleader = " " -- maps the leader key
vim.g.maplocalleader = "\\" -- local leader key config

require("amal.lazy")
require("amal.core")

-- global variables
_G.diagnostics_enabled = true
