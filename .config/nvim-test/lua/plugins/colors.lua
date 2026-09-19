return {
	{
		src = "https://github.com/theamallalgi/zitchdog",
		config = function()
			require("zitchdog").load({ variant = "grape", transparent_bg = true })
		end,
	},
	{
		src = "https://github.com/craftzdog/solarized-osaka.nvim",
		config = function()
			require("solarized-osaka").setup({
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
				},
				on_highlights = function(hl, c)
					hl.CursorLine = { bg = "NONE" }
				end,
			})
			-- vim.cmd.colorscheme("solarized-osaka")
		end,
	},
}
