-- ~/.config/hypr/modules/env.lua -- environment variables
-- see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- permissions and more
-- see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- permission changes here require a hyprland restart and are not applied on-the-fly

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim",                              "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",  "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
