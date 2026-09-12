return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- lazily load luv (vim.uv) types only when actually used
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
			-- default and correct: also fixes lspconfig creating duplicate
			-- lua_ls workspaces per-buffer instead of sharing one
			integrations = { lspconfig = true },
		},
	},
}
