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
				bottom_search = false,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},

			views = {
				notify = {
          title = "",
          level = nil,
					border = {
						style = "single",
						shadow = false,
					},
					padding = { 0, 1, 0, 1 },
				},

				popup = {
					border = {
						style = "single",
						shadow = false,
					},
					padding = { 0, 0, 0, 0 },
				},
			},

			cmdline = {
				enabled = true,
				view = "cmdline",

				format = {
					---@diagnostic disable-next-line: missing-fields
					cmdline = { pattern = "^:", icon = ":", },

					---@diagnostic disable-next-line: missing-fields
					search_down = { kind = "search", pattern = "^/", icon = "/", },

					---@diagnostic disable-next-line: missing-fields
					search_up = { kind = "search", pattern = "^%?", icon = "?", },

					---@diagnostic disable-next-line: missing-fields
					-- filter = { pattern = "^:%s*!", icon = "fltr:", },

					---@diagnostic disable-next-line: missing-fields
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*", }, icon = "lua:", },

					---@diagnostic disable-next-line: missing-fields
					help = { pattern = "^:%s*he?l?p?%s+", icon = "help:", },

					---@diagnostic disable-next-line: missing-fields
					input = { view = "cmdline_input", icon = "󰘳 ", },
				},
			},

			-- Keep normal messages native unless explicitly routed below.
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},

			-- Short, user-facing messages get a notification.
			-- Everything else remains under normal Neovim handling.
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							-- Yank
							{ find = "yanked" },

							-- Lines added/removed
							{ find = "%d+ fewer lines" },
							{ find = "%d+ more lines" },

							-- File read/write
							{ find = "%d+L, %d+B" },
							{ find = '"[^"]+" written' },

							-- Change/jump information
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "notify",
				},
			},

			popupmenu = {
				enabled = true,
				backend = "nui",
				kind_icons = {},
			},

			notify = {
				enabled = true,
				view = "notify",
			},

			lsp = {
				-- Background LSP activity should be unobtrusive.
				progress = {
					enabled = true,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30,
					view = "mini",
				},

				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},

				hover = {
					enabled = true,
					silent = false,
				},

				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
				},

				-- LSP messages stay native.
				message = {
					enabled = true,
				},

				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = {
							concealcursor = "n",
							conceallevel = 3,
						},
					},
				},
			},

			markdown = {
				hover = {
					["|(%S-)|"] = vim.cmd.help,
					["%[.-%]%((%S-)%)"] = require("noice.util").open,
				},

				highlights = {
					["|%S-|"] = {
						link = "Identifier",
					},
					["%[.-%]"] = {
						link = "Identifier",
					},
				},
			},
		})
	end,
}
