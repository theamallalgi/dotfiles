return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippets engine
		"hrsh7th/cmp-nvim-lsp", -- snippets for LSP
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		-- local lspkind = require("lspkind")

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpCursorLine,Search:None",
					scrollbar = false,
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpCursorLine,Search:None",
					scrollbar = false,
				}),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
			}),
			performance = {
				debounce = 60,
				throttle = 30,
				fetching_timeout = 80,
				confirm_resolve_timeout = 60,
			},
			formatting = {
				-- fields = { "abbr", "kind", "menu" },
				-- format = lspkind.cmp_format({
				-- mode = "symbol_text", -- show symbols and text annotations
				-- maxwidth = 50,
				-- ellipsis_char = "...",
				-- symbol_map = {
				-- Text = "", -- example symbols
				-- Method = "",
				-- Function = "",
				-- Constructor = "",
				-- Field = "",
				-- Variable = "",
				-- Class = "",
				-- Interface = "",
				-- Module = "",
				-- Property = "",
				-- Unit = "",
				-- Value = "",
				-- Enum = "",
				-- Keyword = "",
				-- Snippet = "",
				-- Color = "",
				-- File = "",
				-- Reference = "",
				-- Folder = "",
				-- EnumMember = "",
				-- Constant = "",
				-- Struct = "",
				-- Event = "",
				-- Operator = "",
				-- TypeParameter = "",
				-- Copilot = "",
				-- },
				-- }),
				-- expandable_indicator = true,

				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local completion_item = entry:get_completion_item()
					local highlights_info = require("colorful-menu").highlights(completion_item, vim.bo.filetype)

					-- error, such as missing parser, fallback to use raw label.
					if highlights_info == nil then
						vim_item.abbr = completion_item.label
					else
						vim_item.abbr_hl_group = highlights_info.highlights
						vim_item.abbr = highlights_info.text
					end

					local kind = require("lspkind").cmp_format({
						mode = "symbol_text",
					})(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					vim_item.kind = " " .. (strings[1] or "") .. " "
					vim_item.menu = ""

					return vim_item
				end,
			},

			experimental = {
				ghost_text = {
					hl_group = "AlphaFooter",
					-- hl_group = "CmpGhostText",
				},
				ghost_text = false,
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lua" },
				{ name = "calc" },
				{ name = "emoji" },
				{ name = "treesitter" },
			}),
		})

		vim.cmd([[
      set completeopt=menuone,noinsert,noselect
      highlight! default link CmpItemKind CmpItemMenuDefault
    ]])
	end,
}
