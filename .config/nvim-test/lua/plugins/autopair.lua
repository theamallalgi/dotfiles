return {
	{
		src = "https://github.com/windwp/nvim-autopairs",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({})
		end,
	},
}
