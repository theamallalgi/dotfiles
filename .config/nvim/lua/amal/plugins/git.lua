return {
	"lewis6991/gitsigns.nvim",
	-- event = "VeryLazy",
	lazy = true,
	opts = {
		auto_attach = false,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "-" },
			topdelete = { text = "-" },
			changedelete = { text = "-" },
		},

		signcolumn = false, -- display signs in the gutter (overlaps with diagnostics signs)
		numhl = false, -- highlight numbers with git sign colors
		linehl = true, -- enable diff-like inline highlighting
		word_diff = true, -- enable diff-like per word highlighting
	},
}
