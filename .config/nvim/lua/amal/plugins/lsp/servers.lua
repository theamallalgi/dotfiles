local schemastore = require("schemastore")

return {

	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},

				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},

				diagnostics = {
					globals = {
						"vim",
						"Snacks",
					},
				},

				hint = {
					enable = true,
				},

				codeLens = {
					enable = true,
				},

				telemetry = {
					enable = false,
				},
			},
		},
	},

	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "strict",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	},

	ruff = {},

	ts_ls = {},

	rust_analyzer = {},

	bashls = {
		filetypes = { "sh", "bash", "zsh" },
	},

	jsonls = {
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},

	yamlls = {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = schemastore.yaml.schemas(),
			},
		},
	},

	html = {},
	cssls = {},
	emmet_ls = {},
	tailwindcss = {},

	-- gopls = {
	-- 	settings = {
	-- 		gopls = {
	-- 			gofumpt = true,
	-- 			staticcheck = true,
	-- 			analyses = {
	-- 				unusedparams = true,
	-- 			},
	-- 		},
	-- 	},
	-- },
	--
	-- sqls = {}, -- Postgres/SQL

	-- clangd = {
	-- 	cmd = { "clangd", "--background-index", "--clang-tidy" },
	-- },

	texlab = {
		settings = {
			texlab = {
				build = {
					executable = "latexmk",
					args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
					onSave = true,
				},
				forwardSearch = {
					executable = "zathura",
					args = { "--synctex-forward", "%l:1:%f", "%p" },
				},
			},
		},
	},
}
