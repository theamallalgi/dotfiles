return {
	"lukas-reineke/indent-blankline.nvim",
	lazyload = true,
	main = "ibl",
	opts = {},
	config = function()
		require("ibl").setup({
			scope = {
				enabled = false,
				show_start = false,
				show_end = false,
			},
			indent = {
				char = "|",
				-- highlight = "AlphaFooter",
			},
		})
	end,
}
