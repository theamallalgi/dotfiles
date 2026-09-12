return {
	"stevearc/oil.nvim",
	keys = { { "-", "<CMD>Oil --float --preview<CR>", desc = "Open parent directory" } },
	---@module 'oil'
	---@type oil.SetupOpts
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = false,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
			},
			keymaps = {
				["gd"] = {
					desc = "Toggle file detail view",
					callback = function()
						---@diagnostic disable-next-line: lowercase-global
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
			},
			float = {
				padding = 6,
				max_width = 0.75,
				max_height = 0.8,
				border = "rounded",
				get_win_title = function(winid)
					local bufnr = vim.api.nvim_win_get_buf(winid)
					local dir = require("oil").get_current_dir(bufnr)
					return dir and (" " .. vim.fn.fnamemodify(dir, ":~") .. " ") or "Oil"
				end,
			},
		})
	end,
}
