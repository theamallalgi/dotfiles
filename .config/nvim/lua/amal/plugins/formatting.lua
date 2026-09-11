return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				lua = { "stylua" },
				-- python = { "ruff", "isort", "black" },
				python = { "ruff_organize_imports", "ruff_format" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				rust = { "rustfmt" },
				-- go = { "goimports", "gofumpt" },
				-- c = { "clang-format" },
				tex = { "latexindent" },
			},
			-- format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
		})

		-- vim.keymap.set({ "n", "v" }, "<leader>mp", function()
		-- 	conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
		-- end, { desc = "Format file or range (in visual mode)" })
		vim.keymap.set({ "n", "v" }, "<leader>fs", function()
			require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
		end, { desc = "Format Buffer/Selection" })
	end,
}
