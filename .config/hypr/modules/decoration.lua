-- ~/.config/hypr/modules/decoration.lua -- decoration and stuff
-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration

hl.config({
    decoration = {
        -- rounding       = 2, -- adds rounded corners
        -- rounding_power = 2, -- makes the curves mathematically accurate
        rounding       = 0, -- adds rounded corners
        rounding_power = 2, -- makes the curves mathematically accurate

        -- change transparency of focused and unfocused windows
        active_opacity   = 1.0, -- sane people don't change this
        inactive_opacity = 1.0, -- don't touch this, you are not an emo baby!

        -- adds shadows to active windows, barely noticeable tbh
        shadow = {
            enabled        = true,
            range          = 25,
            render_power   = 4,
            color          = "rgba(00000080)",
            color_inactive = "rgba(00000060)",
            offset         = { 0, 7 },
            scale          = 1.0,
        },

        -- see https://wiki.hypr.land/Configuring/Basics/Variables/#blur for info
        blur = {
            enabled   = false,
            size      = 4,
            passes    = 2,    -- adds more depth
            vibrancy  = 0.1696,
        },
    },
})
