return {
	"lukas-reineke/indent-blankline.nvim",
	lazyload = true,
	main = "ibl",
	opts = {},
	config = function()
		require("ibl").setup({
			scope = {
				enabled = false, -- enable scope highlighting
				show_start = false, -- don't show the start of the scope
				show_end = false, -- don't show the end of the scope
			},
			indent = {
				char = "|", -- use '|' for indentation character
				highlight = "AlphaFooter",
			},
		})
	end,
}
