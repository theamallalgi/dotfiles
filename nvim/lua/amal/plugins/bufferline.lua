return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "tabs",
			always_show_bufferline = false,
			indicator = { style = "none" },
			seperator_style = "slant",
			offsets = {
				{
					filetype = "neo-tree",
					text = "filesystem",
					text_align = "left",
					separator = true,
					highlight = "Function",
				},
			},
			buffer_close_icon = "󰅖",
			modified_icon = "󰫢 ",
			close_icon = "󰅖 ",
			left_trunc_marker = "󰁍 ",
			right_trunc_marker = "󰁔 ",
			color_icons = false,
			show_buffer_icons = false,
		},
		highlights = {
			fill = { bg = "#0b080e" },
			background = {
				fg = "#542a91",
				bg = "#0b080e",
			},
			buffer_selected = {
				fg = "#8443e4",
				bg = "#0d0910",
				bold = false,
				italic = false,
			},
			tab = { bg = "NONE" },
			tab_selected = {
				fg = "#8443e3",
				bg = "#0d0910",
			},
			tab_separator = { bg = "NONE" },
			tab_separator_selected = { bg = "NONE" },
			tab_close = {
				fg = "#191226",
				bg = "#0b080e",
			},
			close_button = {
				fg = "#201638",
				bg = "#0b080e",
			},
			close_button_visible = {
				fg = "#201638",
				bg = "#0b080e",
			},
			close_button_selected = {
				fg = "#8443e3",
				bg = "#0d0910",
			},
			modified = {
				fg = "#5a3c8d",
				bg = "#0b080e",
			},
			modified_visible = {
				fg = "#5a3c8d",
				bg = "#0b080e",
			},
			modified_selected = {
				fg = "#e49068",
				bg = "#0d0910",
			},
			separator = {
				fg = "#0b080e",
				bg = "#0b080e",
			},
		},
	},
}
