local colors = {
	black = "#100d17",
	darkblack = "#0b080e",
	white = "#d0b6d0",
	red = "#e4374b",
	darkred = "#652929",
	green = "#46cea9",
	darkgreen = "#123127",
	blue = "#8443e3",
	magenta = "#8443e3",
	cyan = "#17c5cb",
	darkcyan = "#08313f",
	yellow = "#e49068",
	darkyellow = "#4b3b27",
	orange = "#e4465e",
	darkorange = "#4b2424",
	gray = "#191226",
	darkgray = "#0d0910",
	lightgray = "#542a91",
	inactivegray = "#272045",
}

local zitchdog = {
	normal = {
		a = { fg = colors.blue, bg = colors.black },
		b = { fg = colors.lightgray, bg = colors.darkblack },
		c = { fg = colors.lightgray, bg = colors.darkblack },
		x = { fg = colors.lightgray, bg = colors.darkblack },
		y = { fg = colors.red, bg = colors.darkblack },
		z = { fg = colors.green, bg = colors.darkgreen },
	},
	insert = {
		a = { fg = colors.green, bg = colors.darkgreen },
		b = { fg = colors.red, bg = colors.darkred },
		z = { fg = colors.green, bg = colors.darkgreen },
		y = { fg = colors.lightgray, bg = colors.darkblack },
	},
	visual = {
		a = { fg = colors.yellow, bg = colors.darkyellow },
		b = { fg = colors.red, bg = colors.darkred },
		z = { fg = colors.yellow, bg = colors.darkyellow },
		y = { fg = colors.lightgray, bg = colors.darkblack },
	},
	replace = {
		a = { fg = colors.red, bg = colors.darkred },
		b = { fg = colors.red, bg = colors.darkred },
		z = { fg = colors.red, bg = colors.darkred },
		y = { fg = colors.lightgray, bg = colors.darkblack },
	},
	command = {
		a = { fg = colors.orange, bg = colors.darkorange },
		b = { fg = colors.red, bg = colors.darkred },
		z = { fg = colors.orange, bg = colors.darkorange },
		y = { fg = colors.lightgray, bg = colors.darkblack },
	},
	inactive = {
		a = { fg = colors.inactivegray, bg = colors.magenta },
		b = { fg = colors.inactivegray, bg = colors.magenta },
		c = { fg = colors.inactivegray },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	lazyload = true,
	dependencies = {
		"meuter/lualine-so-fancy.nvim",
	},
	config = function()
		local function word_count()
			local ft = vim.bo.filetype
			if ft == "tex" or ft == "text" or ft == "plaintex" then
				return "wc: " .. vim.fn.wordcount().words
			end
			return ""
		end

		local function get_listed_buffers()
			return vim.tbl_filter(function(b)
				return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
			end, vim.api.nvim_list_bufs())
		end

		local function buffer_count()
			local buffers = get_listed_buffers()
			local current = vim.api.nvim_get_current_buf()
			local index = 1
			for i, b in ipairs(buffers) do
				if b == current then
					index = i
					break
				end
			end
      return index .. "/" .. #buffers
		end

		require("lualine").setup({
			options = {
				theme = zitchdog,
				globalstatus = true,
				component_separators = { left = "|", right = "|" },
				icons_enabled = false,
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha" },
				fmt = string.lower,
			},
			sections = {
				lualine_a = { { "fancy_mode", width = 3 } },
				lualine_b = {},
				lualine_c = {
					{ "filename", path = 1, symbols = { modified = "󰫢 " }, separator = "" },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = {
							error = "",
							warn = "",
						},
						diagnostics_color = {
							error = "DiagnosticVirtualTextError",
							warn = "DiagnosticVirtualTextWarn",
							info = "DiagnosticVirtualTextInfo",
							hint = "DiagnosticVirtualTextHint",
						},
						colored = true,
						update_in_insert = false,
						always_visible = false,
						separator = "",
						cond = function()
							return _G.diagnostics_enabled
						end,
					},
					{ "fancy_branch", color = { fg = colors.cyan, bg = colors.darkcyan } },
					"location",
					"progress",
					{
						buffer_count,
						color = { fg = colors.blue, bg = colors.black },
						cond = function()
							return #get_listed_buffers() > 1
						end,
					},
				},
				lualine_y = {
					function()
						local recording_register = vim.fn.reg_recording()
						if recording_register == "q" then
							return "[󰑊]"
						elseif recording_register ~= "" then
							return string.format("[󰑊](%s)", recording_register)
						else
							return ""
						end
					end,
				},
				lualine_z = {
					function()
						return _G.copilot_enabled and " " or ""
					end,
					{ word_count, color = { fg = colors.green, bg = colors.darkgreen } },
				},
			},
			inactive_sections = {},
			tabline = {},
			extensions = { "neo-tree", "lazy" },
		})
	end,
}
