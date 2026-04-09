return {
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
	cssls = {},
	emmet_ls = {},
	html = {},
	tailwindcss = {},
	rust_analyzer = {},
	bashls = { filetypes = { "sh", "zsh" } },
	jsonls = {
		settings = {
			json = {
				schema = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					library = {
						"${3rd}/luv/library",
						unpack(vim.api.nvim_get_runtime_file("", true)),
					},
				},
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim", "Snacks" },
				},
			},
		},
	},
}
