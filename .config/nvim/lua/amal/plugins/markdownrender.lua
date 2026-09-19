return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			icons = {},
			signs = {},
			sign = false,
			width = "block",
			backgrounds = { "NONE", "NONE", "NONE", "NONE", "NONE", "NONE" },
			-- foregrounds = { "#a277ff", "#ffca85", "#f694ff", "#a277ff", "#ffca85", "#f694ff" },
		},
		code = {
			sign = false,
			style = "normal",
			border = "none",
			above = "",
			below = "",
			width = "block",
		},
		dash = { icon = "─" },
		bullet = { icons = { "", "", "", "" } },
		checkbox = {
			unchecked = { icon = "󰄮" },
			checked = { icon = "󰄲" },
		},
		quote = { icon = "▌" },
		link = { enabled = true },
		callout = {
			note = { raw = "[!NOTE]", rendered = " Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = " Tip", highlight = "RenderMarkdownSuccess" },
			important = { raw = "[!IMPORTANT]", rendered = "󰐃 Important", highlight = "RenderMarkdownHint" },
			warning = { raw = "[!WARNING]", rendered = "󱈸 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!CAUTION]", rendered = "󰊠 Caution", highlight = "RenderMarkdownError" },
		},
	},
	-- config = function(_, opts)
	-- 	require("render-markdown").setup(opts)
	-- 	vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1a1a2e" })
	-- 	vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#3d375e" })
	-- 	vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#a277ff" })
	-- 	vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#3d375e" })
	-- end,
}
