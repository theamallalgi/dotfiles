return {
	{
		src = "https://github.com/stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_format" },
					lua = { "stylua" },
				},
				-- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			})
			vim.keymap.set({ "n", "v" }, "<leader>fs", function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end, { desc = "Format buffer" })
		end,
	},
}
