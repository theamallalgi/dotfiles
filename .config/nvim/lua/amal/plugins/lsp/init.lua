return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "b0o/schemastore.nvim" },
		{ "rachartier/tiny-inline-diagnostic.nvim", opts = {} },
		-- { "j-hui/fidget.nvim", opts = {} },
	},

	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local servers = require("amal.plugins.lsp.servers")

		require("mason").setup({
			ui = {
				icons = {
					package_installed = "󰗠 ",
					package_pending = " ",
					package_uninstalled = " ",
				},
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
				"stylua",
				"prettierd",
				"eslint_d", -- tsgo is faster?
				-- "tsgo",
				"black",
				"isort",
				"ruff",
				"shfmt",
				"shellcheck",
				"buf",
				-- "rust-analyzer", -- let rustup install it
				-- "rustfmt", -- install via rustup
				-- "golangci-lint",
				-- "gofumpt",
				-- "goimports",
				-- "clang-format",
				-- "cppcheck",
				"tinymist",
				"texlab",
				"latexindent",
			}),
		})

		require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

		for name, config in pairs(servers) do
			config.capabilities = capabilities
			vim.lsp.config(name, config)
			vim.lsp.enable(name)
			-- inlay hints
			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	callback = function(args)
			-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
			--
			-- 		if client and client.name == "rust_analyzer" then
			-- 			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
			-- 		end
			-- 	end,
			-- })
		end

		require("amal.plugins.lsp.keymaps")
		require("amal.plugins.lsp.diagnostics")
	end,
}
