return {
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v1.10.2",
		config = function()
			require("blink.cmp").setup({
				enabled = function()
					local disabled_filetypes = {
						"oil",
						"TelescopePrompt",
						"TelescopeResults",
						"trouble",
						"qf",
					}
					return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
				end,
				keymap = {
					preset = "none",
					["<C-j>"] = { "select_next", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-y>"] = { "select_and_accept", "fallback" },
					["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide" },
				},
				appearance = { nerd_font_variant = "mono" },
				completion = {
					documentation = { auto_show = true },
					menu = { border = "none" },
				},
				signature = {
					window = { border = "none" },
				},
				sources = { default = { "lsp", "path", "buffer" } },
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	},
}
