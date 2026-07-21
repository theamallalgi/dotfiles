return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		{ "j-hui/fidget.nvim", opts = {} },
		{ "b0o/schemastore.nvim" },
		{ "rachartier/tiny-inline-diagnostic.nvim", opts = {} },
	},

	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local servers = require("amal.plugins.lsp.servers")

		require("mason").setup({
			ui = {
				icons = {
					package_installed = "󰄬",
					package_pending = "󰁔",
					package_uninstalled = "󰅖",
				},
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
				"stylua",
				"prettierd",
				"eslint_d",
				"black",
				"isort",
				"ruff",
				"shfmt",
				"shellcheck",
				"buf",
        -- "rustfmt", -- install via rustup
				-- "golangci-lint",
        -- "gofumpt",
        -- "goimports",
        -- "clang-format",
        -- "cppcheck",
        "texlab",
        "latexindent",
			}),
		})

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		for name, config in pairs(servers) do
			config.capabilities = capabilities
			vim.lsp.config(name, config)
			vim.lsp.enable(name)
		end

		require("amal.plugins.lsp.keymaps")
		require("amal.plugins.lsp.diagnostics")
	end,
}
