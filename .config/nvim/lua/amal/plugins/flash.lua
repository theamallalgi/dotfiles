return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		highlight = {
			backdrop = false,
			matches = true,
			priority = 5000,
			groups = {
				backdrop = "",
				-- match = "MyFlashMatch",
				-- current = "MyFlashCurrent",
				-- backdrop = "MyFlashBackdrop",
				-- label = "MyFlashLabel",
			},
		},
	},
	keys = {
		{
			"zk",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"zK",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"<Leader>ze",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"<Leader>zr",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
	},
}
