return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				-- available options:
				-- "modern", "classic", "minimal", "powerline",
				-- "ghost", "simple", "nonerdfont", "amongus"
				preset = "powerline",
				transparent_bg = false, -- Set the background of the diagnostic to transparent
				transparent_cursorline = false, -- Set the background of the cursorline to transparent (only one the first diagnostic)
				hi = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
					hint = "DiagnosticHint",
					arrow = "NonText",
					background = "CursorLine",
					mixing_color = "None",
				},
				options = {
					show_source = { enabled = false, if_many = false },
					use_icons_from_diagnostic = false,
					set_arrow_to_diag_color = false,
					add_messages = true,
					throttle = 20,
					softwrap = 25,
					overflow = { mode = "wrap", padding = 1 },
					multilines = { enabled = false, always_show = false },
					show_all_diags_on_cursorline = false,
					enable_on_insert = false,
					enable_on_select = false,
					break_line = { enabled = false, after = 30 },
					format = nil,
					virt_texts = { priority = 2048 },
					severity = {
						vim.diagnostic.severity.ERROR,
						vim.diagnostic.severity.WARN,
						vim.diagnostic.severity.INFO,
						vim.diagnostic.severity.HINT,
					},
					overwrite_events = nil,
				},
				disabled_ft = {}, -- list of filetypes to disable the plugin
			})
			vim.diagnostic.config({ virtual_text = false }) -- only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
}
