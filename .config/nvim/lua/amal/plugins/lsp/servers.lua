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
}
