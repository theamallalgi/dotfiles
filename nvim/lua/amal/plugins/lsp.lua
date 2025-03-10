return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "williamboman/mason.nvim", config = true },
		{ "j-hui/fidget.nvim", opts = {} },
		{ "b0o/schemastore.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
	},
	config = function()
		require("mason").setup({
			ui = {
				-- border = "rounded",
				icons = {
					package_installed = "󰄬",
					package_pending = "󰁔",
					package_uninstalled = "󰅖",
				},
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(require("amal.plugins.lsp.servers")),
		})
		require("lspconfig.ui.windows").default_options.border = "single"

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

        -- format on save (with lsp)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = event.buf,
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})

				map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
				map("gr", require("telescope.builtin").lsp_references, "Goto References")
				map("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
				map("go", require("telescope.builtin").lsp_type_definitions, "Type Definition")
				map("<leader>p", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
				map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")
				map("<leader>Ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
				map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
				map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
				map("<leader>mp", vim.lsp.buf.format, "Format Buffer")
				map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					-- on_attach = require("plugins.lsp.on_attach").on_attach,
					settings = require("amal.plugins.lsp.servers")[server_name],
					filetypes = (require("amal.plugins.lsp.servers")[server_name] or {}).filetypes,
				})
			end,
		})

		require("lspconfig").lua_ls.setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})

		vim.diagnostic.config({
			title = false,
			underline = true,
			virtual_text = true,
			signs = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				source = "if_many",
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})

		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
