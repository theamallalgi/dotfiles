return {
	"folke/noice.nvim",
	lazy = false,
	priority = 900,
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("noice").setup({
			presets = {
				bottom_search = true,
				command_palette = false,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},

			views = {
				notify = {
					title = "",
					level = nil,
					border = { style = "single", shadow = false },
					padding = { 0, 1, 0, 1 },
				},

				popup = {
					border = { style = "single", shadow = false },
					padding = { 0, 0, 0, 0 },
				},
			},

			cmdline = {
				-- set to false after setting up UI2 properly
				-- see: lua/amal/core/settings.lua
				enabled = true,
				view = "cmdline",

				format = {
					---@diagnostic disable-next-line: missing-fields
					cmdline = {
						pattern = "^:",
						icon = ":",
					},

					---@diagnostic disable-next-line: missing-fields
					search_down = {
						kind = "search",
						pattern = "^/",
						icon = "/",
					},

					---@diagnostic disable-next-line: missing-fields
					search_up = {
						kind = "search",
						pattern = "^%?",
						icon = "?",
					},

					---@diagnostic disable-next-line: missing-fields
					lua = {
						pattern = {
							"^:%s*lua%s+",
							"^:%s*lua%s*=%s*",
							"^:%s*=%s*",
						},
						icon = "lua:",
					},

					---@diagnostic disable-next-line: missing-fields
					help = {
						pattern = "^:%s*he?l?p?%s+",
						icon = "help:",
					},

					---@diagnostic disable-next-line: missing-fields
					input = {
						view = "cmdline_input",
						icon = "󰘳 ",
					},
				},
			},

			routes = {
				{
					filter = { event = "msg_show", kind = "list_cmd" },
					view = "split",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "yanked" },
							{ find = "%d+ fewer lines" },
							{ find = "%d+ more lines" },
							{ find = "%d+L, %d+B" },
							{ find = '"[^"]+" written' },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "notify",
					opts = {
						stop = true,
					},
				},
			},

			lsp = {
				progress = {
					enabled = true,
				},

				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},

				message = {
					enabled = true,
				},
			},

			markdown = {
				highlights = {
					["|%S-|"] = { link = "Identifier" },
					["%[.-%]"] = { link = "Identifier" },
				},
			},
		})
	end,
}
