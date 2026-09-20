-- uiconfig.lua

---@diagnostic disable-next-line: unused-local
local palette = require("palette")

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})

-- vim.api.nvim_set_hl(0, "Search", { bg = palette.umber, fg =palette.orange  }) -- search highlights
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = palette.orange, fg  = palette.umber, bold = true })
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = palette.maroon, fg = palette.red, bold = true })

vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#191324", bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#201638" })
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#191324", bg = "#191324" })

vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#abb2bf", bg = "#0D0910" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#2c1e36", bg = "NONE" })
-- vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#abb2bf", bg = "#0D0910", bold = true })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#c0c9c3", bg = "#051177", bold = true })
vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#abb2bf", bg = "#0D0910" })
vim.api.nvim_set_hl(0, "LspFloatWinNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "LspFloatWinBorder", { link = "FloatBorder" })

vim.api.nvim_set_hl(0, "LazyNormal", { fg = "#abb2bf", bg = "#0D0910" })
vim.api.nvim_set_hl(0, "LazyBorder", { fg = "#140D19", bg = "#140D19" })
vim.api.nvim_set_hl(0, "LazyButton", { fg = "#abb2bf", bg = "#140D19" })
vim.api.nvim_set_hl(0, "LazyButtonActive", { fg = "#c0c9c3", bg = "#051177", bold = true })
vim.api.nvim_set_hl(0, "LazyH1", { fg = "#c0c9c3", bg = "#051177", bold = true })

vim.api.nvim_set_hl(0, "iCursor", { bg = "#c0c9c3" })
