return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
	},
	opts = {},
	config = function()
		require("barbecue").setup({
			create_autocmd = false, -- prevent barbecue from updating itself automatically
			kinds = false, -- Disable all kind icons
			theme = {
				ellipsis = { fg = "#333352" },
				separator = { fg = "#333352" },
				dirname = { fg = "#4a4a78" },
				basename = { fg = "#4a4a78", bold = true },
				context = { fg = "#4a4a78" },
				context_file = { fg = "#4a4a78" },
			},
			show_dirname = true,
			context_follow_icon_color = true,
		})

		vim.api.nvim_create_autocmd({
			"WinScrolled", -- or WinResized on NVIM-v0.9 and higher
			"BufWinEnter",
			"CursorHold",
			"InsertLeave",
		}, {
			group = vim.api.nvim_create_augroup("barbecue.updater", {}),
			callback = function()
				require("barbecue.ui").update()
			end,
		})
	end,
}
