-- colors.lua: set colorscheme and stuff idk

return {
	{
		"theamallalgi/zitchdog",
		lazy = false,
		priority = 1000,
    branch = 'dev',
		config = function()
			require("zitchdog").load({
				variant = "grape", -- grape (default)/pine/night
				-- transparent_bg = true, -- a boolean to toggle transparent background
				-- italic_comments = false, -- a boolean to toggle italic comments
				-- colors = {}, -- a table of colors to override the default palette
			})
		end,
	},
}
