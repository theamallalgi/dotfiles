return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 1000,
			render = "compact",
			vim_notify = true,
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
		quickfile = { enabled = true },
		lazygit = { enabled = true },
		rename = { enabled = false },
		terminal = { enabled = false },
		statuscolumn = { enabled = true },
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit logs",
		},
		{
			"<leader>nu",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>nn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
	},
}
