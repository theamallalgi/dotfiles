-- enable ui2 (exp)
require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		targets = "cmd",
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = { height = 0.5, timeout = 4000 },
		pager = { height = 1 },
	},
})

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})

-- custom hi grps
---@diagnostic disable-next-line: unused-local
local palette = require("core.palette")

-- vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#00323f" })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#c0c9c3", bg = "#051177", bold = true })
vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#abb2bf", bg = "#0D0910" })
