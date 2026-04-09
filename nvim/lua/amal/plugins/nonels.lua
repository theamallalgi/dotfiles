return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions
			local shellcheck = require("none-ls-shellcheck")

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			-- Load ruff diagnostics only if available
			local ruff_diag = nil
			local ok, ruff = pcall(require, "none-ls-extras.diagnostics.ruff")
			if ok then
				ruff_diag = ruff
			end

			require("mason-null-ls").setup({
				ensure_installed = {
					"black",
					"isort",
					"ruff",
					"prettier",
					"stylua",
					"eslint_d",
					"shfmt",
					"buf",
				},
			})

			-- Collect all sources cleanly
			local sources = {
				-- Formatters
				-- formatting.black.with({ timeout = 5000 }),
				-- formatting.isort.with({ timeout = 5000 }),
				formatting.prettier,
				formatting.stylua,
				formatting.buf,
				formatting.shfmt,

				-- Diagnostics and actions
				diagnostics.golangci_lint,
				code_actions.refactoring,
				shellcheck.diagnostics,
				shellcheck.code_actions,
			}

			if ruff_diag then
				table.insert(sources, ruff_diag)
			end

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(
					".null-ls-root",
					"pyproject.toml",
					"setup.cfg",
					".git"
				),
				sources = sources,
				
			})
		end,
	},
}
