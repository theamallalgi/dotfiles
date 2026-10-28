local schemastore = require("schemastore")

return {

	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					-- library = vim.api.nvim_get_runtime_file("", true),
				},
				diagnostics = {
					globals = { "vim", "hl", "Snacks" },
				},
				hint = { enable = true },
				codeLens = { enable = true },
				telemetry = { enable = false },
			},
		},
	},

	basedpyright = {
		settings = {
			basedpyright = {
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
	-- tsgo = {}, -- deprecated

	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
					buildScripts = { enable = true },
				},
				procMacro = { enable = true },
				check = { command = "clippy" },
				inlayHints = {
					bindingModeHints = { enable = false },
					chainingHints = { enable = true },
					closureReturnTypeHints = { enable = "with_block" },
					lifetimeElisionHints = { enable = "skip_trivial" },
					parameterHints = { enable = true },
					reborrowHints = { enable = "mutable" },
					typeHints = { enable = true },
				},
			},
		},
	},

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

	-- sqls = {}, -- Postgres/SQL

	-- clangd = {
	-- 	cmd = { "clangd", "--background-index", "--clang-tidy" },
	-- },

	tinymist = {
		settings = {
			formatterMode = "typestyle",
			exportPdf = "never",
		},
	},

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
