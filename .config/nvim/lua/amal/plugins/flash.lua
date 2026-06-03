return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		highlight = {
			backdrop = true,
			matches = true,
			priority = 5000,
			groups = {
				match = "MyFlashMatch",
				current = "MyFlashCurrent",
				backdrop = "MyFlashBackdrop",
				label = "MyFlashLabel",
			},
		},
	},
	keys = {
		{
			"ff",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"vf",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"fe",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"fr",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
