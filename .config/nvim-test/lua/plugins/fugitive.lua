return {
	{
		src = "https://github.com/tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gf", ":Git ", { desc = "Git status (Fugitive)" })
		end,
	},
}
