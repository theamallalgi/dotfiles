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
