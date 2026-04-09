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
		{ "rachartier/tiny-inline-diagnostic.nvim" },
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
		require("mason-tool-installer").setup({
			ensure_installed = vim.tbl_keys(require("amal.plugins.lsp.servers")),
		})
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(require("amal.plugins.lsp.servers")),
			handlers = {
				function(server_name)
					local server_config = {
						capabilities = capabilities,
						-- on_attach = require("plugins.lsp.on_attach").on_attach,
						settings = require("amal.plugins.lsp.servers")[server_name],
						filetypes = (require("amal.plugins.lsp.servers")[server_name] or {}).filetypes,
					}
					
					-- Special handling for lua_ls
					if server_name == "lua_ls" then
						server_config.on_init = function(client)
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
						end
						server_config.settings = {
							Lua = {
								diagnostics = {
									disable = { "missing-fields" },
									globals = { "vim", "Snacks" },
								},
							},
						}
					end
					
					require("lspconfig")[server_name].setup(server_config)
				end,
			},
		})
		require("tiny-inline-diagnostic").setup()
		
		vim.diagnostic.config({
			title = false,
			underline = true,
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "┃",
					[vim.diagnostic.severity.WARN] = "┃",
					[vim.diagnostic.severity.INFO] = "┃",
					[vim.diagnostic.severity.HINT] = "┃",
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = "ZitchMaroon",
					[vim.diagnostic.severity.WARN] = "ZitchClay",
					[vim.diagnostic.severity.INFO] = "ZitchTeal",
					[vim.diagnostic.severity.HINT] = "ZitchIndigo",
				},
			},
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
	end,
}
