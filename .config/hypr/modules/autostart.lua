-- ~/.config/hypr/modules/autostart.lua -- run on startup
-- autostart necessary processes (like notifications daemons, status bars, etc.)

hl.on("hyprland.start", function()
    -- system services
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- display and wallpaper
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hyprctl setcursor Naroz 25") -- set custom cursor (naroz)

    -- status bar and notifications
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")

    -- network and bluetooth
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")

    -- clipboard
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- other
    hl.exec_cmd("vicinae server") -- raycast clone
end)
