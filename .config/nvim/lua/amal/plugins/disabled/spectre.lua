return {
	"windwp/nvim-spectre",
	enabled = false,
	event = "BufRead",
	keys = {
		{
			"<leader>Rr",
			function()
				require("spectre").open()
			end,
			desc = "Replace",
		},
		{
			"<leader>Rw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Replace Word",
		},
		{
			"<leader>Rf",
			function()
				require("spectre").open_file_search()
			end,
			desc = "Replace Buffer",
		},
	},
}
