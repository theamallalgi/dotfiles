return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "lua", "python", "vim", "vimdoc", "markdown", "markdown_inline" },
				auto_install = true,
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and stats and stats.size > max_filesize
					end,
				},
				indent = { enable = true },
			})
		end,
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
			})
			local select = require("nvim-treesitter-textobjects.select")
			local maps = {
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
				aa = "@parameter.outer",
				ia = "@parameter.inner",
				al = "@loop.outer",
				il = "@loop.inner",
				ai = "@conditional.outer",
				ii = "@conditional.inner",
				["a/"] = "@comment.outer",
				["i/"] = "@comment.inner",
			}
			for _, mode in ipairs({ "x", "o" }) do
				for lhs, capture in pairs(maps) do
					vim.keymap.set(mode, lhs, function()
						select.select_textobject(capture, "textobjects")
					end, { silent = true, desc = capture })
				end
			end
		end,
	},
}
