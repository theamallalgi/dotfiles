return {
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{
		src = "https://github.com/meuter/lualine-so-fancy.nvim",
		config = function()
			local function buffer_count()
				local buffers = vim.tbl_filter(function(b)
					return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
				end, vim.api.nvim_list_bufs())
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
					theme = "zitchdog",
					globalstatus = true,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "fancy_mode", width = 3 } },
					lualine_b = {},
					lualine_c = { { "filename", path = 1, symbols = { modified = "󰫢 " } } },
					lualine_x = {
						{ "diagnostics", symbols = { error = "", warn = "" } },
						"fancy_branch",
						"location",
						"progress",
						{
							buffer_count,
							cond = function()
								return #vim.api.nvim_list_bufs() > 1
							end,
						},
					},
					lualine_y = {
						function()
							local rec = vim.fn.reg_recording()
							return rec == "" and "" or string.format("[󰑊](%s)", rec)
						end,
					},
					lualine_z = {},
				},
			})
		end,
	},
}
