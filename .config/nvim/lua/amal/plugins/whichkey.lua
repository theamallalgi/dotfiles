return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = 250,
		-- sort = { "alphanum", "local", "order", "mod", "group" },
		icons = {
			rules = false,
			breadcrumb = "󰅂 ", -- symbol used in the command line area that shows your active key combo
			separator = "󰁔  ", -- symbol used between a key and it's label
			group = "󰴮 ", -- symbol prepended to a group
		},
		plugins = {
			spelling = {
				enabled = false,
			},
		},
		win = {
			height = { max = math.huge },
			padding = { 1, 2 },
		},
		spec = require("amal.plugins.config.whichkey-specs"),
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
