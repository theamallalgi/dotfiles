-- ~/.config/hypr/modules/plugins/hyprscrolling.lua -- plugin: hyprscrolling
-- visit https://github.com/hyprwm/hyprland-plugins/tree/main/hyprscrolling for more info

-- local mainMod = "SUPER"

-- general layout settings (important: should be set to dwindle here, scrolling in general.lua)
-- hl.config({
--     general = {
--         layout = "dwindle",
--     },
--     plugin = {
--         hyprscrolling = {
--             column_width             = 0.7,   -- each column takes 70% of screen width
--             fullscreen_on_one_column = true,  -- maximize window when only one column is visible
--             follow_focus             = true,  -- scroll viewport to follow focused window
--             focus_fit_method         = 1,     -- fit focused column into view on focus change
--         },
--     },
-- })
-- hl.config({
    -- general = { layout = "dwindle" },
-- })

-- load hyprpm on startup
-- hl.on("hyprland.start", function()
    -- hl.exec_cmd("hyprpm reload -n")  -- with notification
    -- hl.exec_cmd("hyprpm reload")         -- disable notification
-- end)

-- hyprscrolling keybinds
-- hl.bind(mainMod .. " + period",          hl.dsp.layout("move +col"))         -- move focus to next column
-- hl.bind(mainMod .. " + comma",           hl.dsp.layout("move -col"))         -- move focus to previous column
-- hl.bind(mainMod .. " + SHIFT + period",  hl.dsp.layout("movewindowto r"))    -- move window to right column
-- hl.bind(mainMod .. " + SHIFT + comma",   hl.dsp.layout("movewindowto l"))    -- move window to left column
-- hl.bind(mainMod .. " + SHIFT + up",      hl.dsp.layout("movewindowto u"))    -- move window up
-- hl.bind(mainMod .. " + SHIFT + down",    hl.dsp.layout("movewindowto d"))    -- move window down
