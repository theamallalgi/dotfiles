vim.diagnostic.config({

	underline = true,

	virtual_text = false,

	update_in_insert = false,

	severity_sort = true,

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

	float = {
		source = "if_many",
		border = "rounded",
		header = "",
		prefix = "",
		style = "minimal",
	},
})
