return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		-- load snacks global
		Snacks = require("snacks")
	end,
	opts = {
		bigfile = { enabled = true }, -- snacks.bigfile (faster when opening big files)
		notify = { -- snacks.notify (better notify)
			enabled = true,
			opts = {
				stages = "static",
				render = "minimal",
				title = function()
					return ""
				end,
			},
		},
		notifier = { -- snacks.notifier (works best with notify)
			enabled = true,
			timeout = 1000,
			render = "minimal",
		},
		styles = {
			notification = {
				wo = {
					cursorcolumn = false,
					cursorline = false,
					cursorlineopt = "both",
					colorcolumn = "",
					fillchars = "eob: ,lastline:…",
					list = false,
					listchars = "extends:…,tab:  ",
					number = false,
					relativenumber = false,
					signcolumn = "no",
					spell = false,
					winbar = "",
					statuscolumn = "",
					wrap = false,
					sidescrolloff = 0,
				},
			},
		},
		quickfile = { enabled = true }, -- snacks.quickfile (makes opening empty files faster)
		lazygit = { enabled = true }, -- snacks.lazygit (lazygit)
		rename = { enabled = true }, -- snacks.rename (lsp rename)
		terminal = { enabled = true, style = "popup" }, -- snacks.terminal (terminal toggle)
	},
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		{ "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notification History" },
		{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Show Marks" },
		{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Show Highlights" },
		{ "<leader>sK", function() Snacks.picker.keymaps() end, desc = "Show Keymaps" },
		{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quick Fix List" },
	},
}
