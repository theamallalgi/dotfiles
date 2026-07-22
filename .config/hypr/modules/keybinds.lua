-- ~/.config/hypr/modules/keybinds.lua

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "nautilus"
local exec = hl.dsp.exec_cmd

-- application launchers
hl.bind(mainMod .. " + Return", exec(terminal))
hl.bind(mainMod .. " + E", exec(fileManager))
hl.bind(mainMod .. " + B", exec("/usr/bin/helium-browser"))
hl.bind("ALT + Space", exec("vicinae toggle"))
hl.bind(mainMod .. " + O", exec("obsidian"))
hl.bind(mainMod .. " + space", exec("rofi -show drun || pkill rofi"))

-- window management
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + bracketright", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.pin())
end)
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())

-- layout switching
-- hl.bind(mainMod .. " + bracketleft",  function() hl.exec_cmd("hyprctl dispatch setlayout dwindle") end)
-- hl.bind(mainMod .. " + bracketright", function() hl.exec_cmd("hyprctl dispatch setlayout scrolling") end)

-- focus movement
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- swap windows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
-- hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
-- hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
-- hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
-- hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- workspaces
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- switch workspaces 1-4
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.focus({ workspace = 4 }))

-- move current window to next/previous workspace (redundant)
-- hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))
-- hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))

-- special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move and resize windows (mouse)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- waybar
hl.bind(mainMod .. " + R", exec("~/.config/waybar/scripts/launch.sh"))
hl.bind(mainMod .. " + W", exec("killall -SIGUSR1 waybar"))

-- scripts
hl.bind(mainMod .. " + A", exec("networkmanager_dmenu"))
hl.bind(mainMod .. " + P", exec("~/.config/waybar/scripts/powermenu.sh"))

-- system
-- hl.bind(mainMod .. " + M", exec("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind("XF86Calculator", exec("qalculate-gtk")) -- remap calculator key to open Qalculate! (Calculator Application)

-- audio
hl.bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

-- brightness
hl.bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- screenshots
hl.bind("Print", exec("grimblast copysave screen ~/Pictures/Screenshots/$(date +%d-%m-%y-%H%M%S).png"))
hl.bind("CTRL + Print", exec("grimblast copysave area ~/Pictures/Screenshots/$(date +%d-%m-%y-%H%M%S).png"))
hl.bind("ALT + Print", exec("~/scripts/ocrsnip.sh"))

-- hyprscrolling
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("movewindowto r"))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("movewindowto l"))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.layout("movewindowto u"))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.layout("movewindowto d"))

-- other
hl.bind(mainMod .. " + equal", exec("qalculate-gtk"))
hl.bind(mainMod .. " + SHIFT + E", exec("eyedropper"))
hl.bind(mainMod .. " + N", exec("subl"))
