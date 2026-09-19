return {
	{
		src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "powerline",
			})

			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = false,
			})
		end,
	},
}
