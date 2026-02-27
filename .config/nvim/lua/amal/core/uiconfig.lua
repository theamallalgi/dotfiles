-- uiconfig.lua

-- local purple1 = "#333352"
-- local purple2 = "#232338"
-- local purple3 = "#12121c"
-- local red1 = "#ba3648"
-- local green1 = "#37ad39"
-- local blue1 = "#0985de"
-- local blue3 = "#313244"
-- local white = "#edecee"
local red = "#ff6767"
local black = "#1a1b26"
-- local green = "#61ffca"
-- local blue = "#a277ff"
-- local magenta = "#a277ff"
-- local cyan = "#61ffca"
-- local yellow = "#ffca85"
-- local orange = "#ff7b7b"
-- local gray = "#29263c"
-- local darkgray = "#15141b"
-- local lightgray = "#433e62"
-- local inactivegray = "#3b4261"
-- local lightergray = "#776eae"
-- local bgred = "#652929"
-- local bggreen = "#123127"
-- local bgblue = "#2f234b"
-- local bgyellow = "#4b3b27"
-- local bgorange = "#4b2424"
-- local bgmagenta = "#433e62"

-- highlight on yank
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- callback = function()
-- vim.api.nvim_set_hl(0, "IncSearch", { bg = red, fg = black })
-- end,
-- })
vim.api.nvim_set_hl(0, "IncSearch", { bg = red, fg = black })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})
