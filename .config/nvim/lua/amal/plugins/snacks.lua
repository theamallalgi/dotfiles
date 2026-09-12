return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true }, -- snacks.bigfile (faster when opening big files)
		picker = { ui_select = false }, -- keep vim.ui.select native, don't hijack it
		notifier = { -- snacks.notifier (works best with notify)
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
		quickfile = { enabled = true }, -- snacks.quickfile (makes opening empty files faster)
		lazygit = { enabled = true }, -- snacks.lazygit (lazygit)
		rename = { enabled = false }, -- snacks.rename (lsp rename)
		terminal = { enabled = false }, -- snacks.terminal (terminal toggle)
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
		{
			"<leader>nm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Show Marks",
		},
		{
			"<leader>nh",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Show Highlights",
		},
		{
			"<leader>nk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Show Keymaps",
		},
		{
			"<leader>nq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quick Fix List",
		},
		{
			"<leader>ls",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Lsp Symbols",
		},
		{
			"<leader>lS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Lsp Workspace Symbols",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Open Explorer",
		},
		-- {
		-- 	"<leader>ut",
		-- 	function()
		-- 		Snacks.terminal()
		-- 	end,
		-- 	desc = "Snacks terminal",
		-- },
	},
}
