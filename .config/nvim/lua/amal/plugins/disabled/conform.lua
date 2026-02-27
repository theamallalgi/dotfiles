return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				sh = { "shfmt" },
				-- python = function(bufnr)
				-- if require("conform").get_formatter_info("ruff_format", bufnr).available then
				-- return { "ruff_fix", "ruff_format", "ruff_organize_imports" }
				-- else
				-- return { "isort", "black" }
				-- end
				-- end,
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = false, -- Prevent conflicts with LSP formatting
			-- 	async = false,
			-- 	timeout_ms = 5000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = true, -- Allow asynchronous processing
				timeout_ms = 5000, -- Increase timeout
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
