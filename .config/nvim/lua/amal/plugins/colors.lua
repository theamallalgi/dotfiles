-- colors.lua: set colorscheme and stuff idk

return {
	{
		"theamallalgi/zitchdog",
		lazy = false,
		priority = 1000,
		branch = "main",
		config = function()
			require("zitchdog").load({
				variant = "grape", -- "grape" | "pine": the default colorscheme variant
				transparent_bg = true, -- boolean: toggles a transparent background
				disable_cursorline = true, -- boolean: hides CursorLine highlight by matching it to bg
				-- italic_comments = false, -- boolean: toggles italic comments
				-- fg = nil, -- string?: override the base foreground (defaults to the variant's white)
				-- bg = nil, -- string?: override the base background (defaults to the variant's black)
				-- colors = {}, -- table<string, string>: override any specific palette color
			})
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
}
