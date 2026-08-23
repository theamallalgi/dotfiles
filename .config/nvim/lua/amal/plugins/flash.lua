return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		highlight = {
			backdrop = false,
			matches = true,
			priority = 5000,
			groups = {
				-- match = "MyFlashMatch",
				-- current = "MyFlashCurrent",
				-- backdrop = "MyFlashBackdrop",
				backdrop = "",
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
			"Zk",
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
		{
			"<Leader><c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
