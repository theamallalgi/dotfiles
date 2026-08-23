return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",

	keys = {
		{
			"<leader>cp",
			function()
				if _G.toggle_copilot then
					_G.toggle_copilot()
				else
					vim.cmd("Copilot enable")
					_G.copilot_enabled = true
				end
			end,
			desc = "Toggle Copilot",
		},
	},

	config = function()
		_G.copilot_enabled = false

		function _G.toggle_copilot()
			if _G.copilot_enabled then
				vim.cmd("Copilot disable")
				_G.copilot_enabled = false
				print("Copilot disabled")
			else
				vim.cmd("Copilot enable")
				_G.copilot_enabled = true
				print("Copilot enabled")
			end
		end

		require("copilot").setup({
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "<leader>cpr",
					open = "<leader>cpp",
				},
				layout = {
					position = "right",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = true,
				["."] = true,
			},
			copilot_node_command = "node",
			server_opts_overrides = {},
		})
	end,
}
