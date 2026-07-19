-- colors.lua: set colorscheme and stuff idk

return {
	{
		"theamallalgi/zitchdog",
		lazy = false,
		priority = 1000,
    branch = 'main',
		config = function()
			require("zitchdog").load({
				variant = "grape", -- grape(d)/pine/dune?
				-- transparent_bg = true, -- a boolean to toggle transparent background (d:false)
				-- italic_comments = true, -- a boolean to toggle italic comments (d: false)
				-- colors = {}, -- a table of colors to override the default palette
			})
		end,
	},
}
