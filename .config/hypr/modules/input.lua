-- ~/.config/hypr/modules/input.lua -- input device config
-- see https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 2, -- 0: no follow, 1: follow mouse (default), 2: no follow except floating, 3: no follow at all
        sensitivity  = 0, -- -1.0 to 1.0, 0 means no modification
        touchpad = {
            natural_scroll = true, -- true for windows style, false for mac style
        },
    },
})

hl.device = {
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
},

-- trackpad gestures
-- see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" }) -- four finger scroll sideways switches workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" }) -- three finger scroll sideways scrolls the tape (scrolling layout)
hl.gesture({ fingers = 2, direction = "pinchin", action = "float", mode = "tile" }) -- pinch inwards to tile a window
hl.gesture({ fingers = 2, direction = "pinchout", action = "float", mode = "float" }) -- pinch outwards to float a window

-- alt + 3 finger swipe left moves active window to previous workspace
hl.gesture({
    fingers = 3,
    direction = "left",
    mods = "ALT",
    action = function()
        hl.dispatch(
            hl.dsp.window.move({ workspace = "+1" })
        )
    end
})

-- alt + 3 finger swipe right moves active window to next workspace
hl.gesture({
    fingers = 3,
    direction = "right",
    mods = "ALT",
    action = function()
        hl.dispatch(
            hl.dsp.window.move({ workspace = "-1" })
        )
    end
})
