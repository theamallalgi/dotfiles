return {
	-- {
	-- "sphamba/smear-cursor.nvim",
	-- opts = {
	-- cursor_color = "#d3cdc3",
	-- normal_bg = "#d3cdc3",
	-- smear_between_buffers = false,
	-- smear_between_neighbor_lines = true,
	-- use_floating_windows = true,
	-- legacy_computing_symbols_support = false,
	-- hide_target_hack = true,
	-- },
	-- },
	{
		"karb94/neoscroll.nvim",
		enabled = false,
		config = function()
			local neoscroll = require("neoscroll")
			neoscroll.setup({
				mappings = { -- Keys to be mapped to their corresponding default scrolling animation
					["<leader>su"] = function()
						neoscroll.ctrl_u({ duration = 250 })
					end,
					["<leader>sd"] = function()
						neoscroll.ctrl_d({ duration = 250 })
					end,
					["<leader>sb"] = function()
						neoscroll.ctrl_b({ duration = 450 })
					end,
					["<leader>sf"] = function()
						neoscroll.ctrl_f({ duration = 450 })
					end,
					["<leader>sy"] = function()
						neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
					end,
					["<leader>se"] = function()
						neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
					end,
					["<leader>st"] = function()
						neoscroll.zt({ half_win_duration = 250 })
					end,
				},
				stop_eof = true,
				easing_function = "sine",
				hide_cursor = true,
				cursor_scrolls_alone = true,
			})
		end,
	},
}
