return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
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

			-- Load ruff diagnostics only if available
			local ruff_diag = nil
			local ok, ruff = pcall(require, "none-ls-extras.diagnostics.ruff")
			if ok then
				ruff_diag = ruff
			end

			-- Collect all sources cleanly
      sources = {
        formatting.prettierd,
        formatting.stylua,
        formatting.shfmt.with({
          filetypes = { "sh", "bash", "zsh" },
        }),

        diagnostics.golangci_lint.with({
          filetypes = { "go" },
        }),

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
