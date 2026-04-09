return {
	{ "L3MON4D3/LuaSnip", keys = {} },
	{
		"Saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"FeiyouG/colorful-menu.nvim",
		},
		config = function()
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			-- Blink.cmp configuration
			require("blink.cmp").setup({
				fuzzy = {
					implementation = "lua", -- Use Lua instead of Rust, Slower but no setup needed.
				},
				snippets = { preset = "luasnip" },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				completion = {
					menu = {
						border = "single",
						scrolloff = 1,
						scrollbar = false,
						draw = {
							columns = {
								{ "kind_icon" },
								{ "label", "label_description", gap = 1 },
								{ "kind" },
								{ "source_name" },
							},
						},
					},
					documentation = {
						window = {
							border = "single",
							scrollbar = false,
						},
						auto_show = true,
						auto_show_delay_ms = 500,
					},
				},
				cmdline = {
					enabled = true,
					completion = {
						ghost_text = {
							enabled = false, -- Specifically disable ghost text for cmdline
						},
					},
				},
				keymap = {
					["<C-j>"] = { "select_next", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },
					["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide", "fallback" },
					["<C-y>"] = { "accept", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
			})
		end,
	},
}
