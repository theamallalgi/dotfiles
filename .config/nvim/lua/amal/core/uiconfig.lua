-- uiconfig.lua

-- local red = "#331b17" -- zitchdog (inverted)
-- local black = "#e4384c" -- zitchdog (inverted)
local red = "#e4384c" -- zitchdog
local black = "#331b17" -- zitchdog
-- local red = "#ff6767" -- default
-- local black = "#1a1b26" -- default

-- highlight text on yank
vim.api.nvim_set_hl(0, "IncSearch", { bg = red, fg = black })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})

-- gitdiff (foreground colors fix)
vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#091511", fg = "NONE", })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#121429", fg = "NONE", })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#240d12", fg = "NONE", })
vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#091511", fg = "NONE", })
vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#121429", fg = "NONE", })
vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#240d12", fg = "NONE", })

-- undotree
vim.api.nvim_set_hl(0, "UndotreeDiffAdd",    { bg = "#00210F", fg = "NONE" })
vim.api.nvim_set_hl(0, "UndotreeDiffChange", { bg = "#0D0F1F", fg = "NONE" })
vim.api.nvim_set_hl(0, "UndotreeDiffDelete", { bg = "#210500", fg = "NONE" })
-- vim.api.nvim_set_hl(0, "UndotreeDiffAdd",    { bg = "#091511", fg = "NONE" })
-- vim.api.nvim_set_hl(0, "UndotreeDiffChange", { bg = "#0d1e18", fg = "NONE" })
-- vim.api.nvim_set_hl(0, "UndotreeDiffDelete", { bg = "#240d12", fg = "NONE" })

vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#191324", bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#201638" })
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#191324" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#191324", bg = "#191324", })

vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#abb2bf", bg = "#0D0910", })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#2c1e36", bg = "NONE", })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#abb2bf", bg = "#0D0910", bold = true, })
vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#abb2bf", bg = "#0D0910", })
vim.api.nvim_set_hl(0, "LspFloatWinNormal", { link = "NormalFloat", })
vim.api.nvim_set_hl(0, "LspFloatWinBorder", { link = "FloatBorder", })

vim.api.nvim_set_hl(0, "LazyNormal", { fg = "#abb2bf", bg = "#0D0910", })
vim.api.nvim_set_hl(0, "LazyBorder", { fg = "#140D19", bg = "#140D19", })
vim.api.nvim_set_hl(0, "LazyButton", { fg = "#abb2bf", bg = "#140D19", })
vim.api.nvim_set_hl(0, "LazyButtonActive", { fg = "#c0c9c3", bg = "#051177", bold = true, })
vim.api.nvim_set_hl(0, "LazyH1", { fg = "#c0c9c3", bg = "#051177", bold = true, })
