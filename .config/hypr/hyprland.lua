-- ~/.config/hypr/hyprland.lua -- hyprland config init file
-- visit https://wiki.hypr.land/Configuring/ for config info

-- 1. environment setup
require("modules.env")

-- 2. hardware configuration
require("modules.monitors")

-- 3. look and feel
-- require("modules.themes.current")
require("modules.general")
require("modules.decoration")
require("modules.animations")

-- 4. input configuration
require("modules.input")

-- 5. window & workspace management
require("modules.windowrules")
require("modules.workspaces")

-- 6. keybindings
require("modules.keybinds")

-- 7. autostart (last so everything is configured)
require("modules.autostart")

-- 8. plugins (if any)
require("modules.plugins.hyprscrolling")
