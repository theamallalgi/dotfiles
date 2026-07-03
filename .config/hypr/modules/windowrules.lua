-- ~/.config/hypr/modules/windowrules.lua -- window and layer rules
-- see https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- ignore maximize requests from all apps. you'll probably like this.
local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

-- fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- file dialogs
local fileDialogTitles = "^(Sign in|Open File|Open|Save|Save As|Export|Import|Choose File|Rename)$"
hl.window_rule({ match = { title = fileDialogTitles }, float = true, center = true, border_size = 0 })

-- XDG desktop portals
for _, cls in ipairs({
	"^(xdg-desktop-portal-gtk)$",
	"^(xdg-desktop-portal-hyprland)$",
	"^(Xdg-desktop-portal-gtk)$",
	"^(Xdg-desktop-portal-hyprland)$",
}) do
	hl.window_rule({ match = { class = cls }, float = true, center = true, border_size = 0 })
end

-- program and application related rules
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true }) -- float pavucontrol (volume control app)
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true }) -- float blueman-manager (bluetooth manager)
hl.window_rule({ match = { class = "^(nwg-look)$" }, float = true }) -- float nwg-look (GTK settings app)
hl.window_rule({ match = { class = "^(org.gnome.NautilusPreviewer)$" }, float = true }) -- float the preview window (gnome sushi)
hl.window_rule({ match = { class = "^(org.gnome.Papers)$" }, float = true }) -- float the document viewer (gnome papers)
hl.window_rule({ match = { class = "^(mpv)$" }, float = true }) -- float mpv player
hl.window_rule({ match = { class = "^(qalculate-gtk)$" }, float = true }) -- float qalculate (calculator app)
hl.window_rule({ match = { class = "^(org.gnome.FileRoller)$" }, float = true }) -- float file-roller (file unpacker app)
hl.window_rule({ match = { class = "^(org.gnome.Loupe)$" }, float = true }) -- gnome-loupe (image viewer)
hl.window_rule({ match = { class = "^(com.github.finefindus.eyedropper)$" }, float = true }) -- gnome-eyedropper (color picker)
hl.window_rule({ match = { class = "^(localsend)$" }, float = true }) -- float localsend
hl.window_rule({ match = { class = "^(chromium-browser)$" }, float = true }) -- float chromium browser
hl.window_rule({ match = { class = "^(tui-float)$" }, float = true }) -- float impala window
hl.window_rule({ match = { class = "^(sublime_text)$" }, float = true }) -- float sublime text

hl.window_rule({ -- floats sign in / log in and other dialogs on helium browser
	match = { initial_title = "Untitled - Helium" },
	float = true,
	center = true,
  -- min_size = { 480, 320 },
	-- max_size = { 900, 800 },
  max_size = { 960, 720 },
})

hl.window_rule({ -- floats the bitwarden popup
	match = { initial_title = "_crx_nngceckbapebfimnlniiiahkandclblb" },
	float = true,
	center = true,
  max_size = { 960, 820 },
})

-- hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = { 20, "monitor_h-120" },
	float = true,
})

hl.window_rule({ match = { float = true }, rounding = 8 }) -- rounded corners for floating windows
hl.window_rule({ match = { float = true }, border_color = "rgba(3E3E3Eff) rgba(252525ff)" }) -- change border color for floating windows
hl.window_rule({ match = { float = false }, no_shadow = true }) -- no shadows on tiled windows

-- layer rules
-- see https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules

-- blur vicinae window
hl.layer_rule({
	name = "vicinae-blur",
	match = { namespace = "vicinae" },
	blur = true,
	ignore_alpha = 0.5,
})

-- disable animation for vicinae only
hl.layer_rule({
	name = "vicinae-no-animation",
	match = { namespace = "vicinae" },
	no_anim = true,
})
