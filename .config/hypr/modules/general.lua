-- ~/.config/hypr/modules/general.lua -- general configurations
-- see https://wiki.hypr.land/Configuring/Basics/Variables/

-- default programs
local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show drun"

hl.config({
	general = {
		gaps_in = 4, -- gap size between tiled windows
		gaps_out = 8, -- gap size around the desktop (kinda like borders)
		border_size = 2, -- border size of a window

		-- col.active_border = "rgba(2c1e36ff)",   -- zitchdog (grape) gray -- minimal
		-- col.inactive_border = "rgba(181818ff)", -- zitchdog (grape) black -- minimal
		-- col.inactive_border = "rgba(0b080eff)", -- zitchdog (grape) black -- minimal
		-- col.active_border = "rgba(542a91ff)",   -- zitchdog (grape) purple -- accent
		-- col.inactive_border = "rgba(2c1e36ff)", -- zitchdog (grape) gray -- accent
		["col.active_border"] = "rgba(1f1f1fff)", -- minimal gray light -- minimal
		["col.inactive_border"] = "rgba(101010ff)", -- minimal gray dark -- minimal

		resize_on_border = false, -- set to true to enable resizing windows by clicking and dragging on borders and gaps
		allow_tearing = false, -- see https://wiki.hypr.land/Configuring/Tearing/ before enabling

		layout = "dwindle", -- more information given below (default layout)
		-- layout = "master",   -- more information given below (like i3)
		-- layout = "scrolling",   -- see ./plugins/hyprscrolling.lua for more info
	},

	dwindle = {
		preserve_split = true, -- you probably want this to be true (set to true for togglesplit to work)
		force_split = 2, -- new splits position: 0 follows mouse, 1 left/top, 2 right/bottom
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 1, -- set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- if true disables the random hyprland logo / anime girl background
	},
})
