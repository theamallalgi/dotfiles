return {
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		version = "0.1.8",
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"%.git/",
						"node_modules/",
						"%.venv/",
						"package%-lock%.json",
						"pack%-lock%.json",
						"yarn%.lock",
						"pnpm%-lock%.yaml",
						"Cargo%.lock",
						"poetry%.lock",
						"uv%.lock",
						"%.lock$",
					},
					path_display = { "truncate" },
					preview = { treesitter = false },
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>o", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find in cwd" })
		end,
	},
}
