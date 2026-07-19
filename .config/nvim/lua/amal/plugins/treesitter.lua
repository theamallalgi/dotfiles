return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
    -- "nvim-treesitter/nvim-treesitter-context",
	},

	opts = {
		ensure_installed = {
			"lua",
			"javascript",
			"python",
			"vim",
			"vimdoc",
			"cpp",
			"c",
		},

		auto_install = true,

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,

			disable = function(lang, buf)
				if lang == "vim" then
					return true
				end

				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf)) -- pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

				return ok and stats and stats.size > max_filesize
			end,
		},

		indent = {
			enable = true,
		},
	},

	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

    -- require("treesitter-context").setup({
      -- enable = true,
      -- max_lines = 1,          -- Maximum context lines shown
      -- multiline_threshold = 5,
      -- trim_scope = "outer",
      -- mode = "cursor",        -- or "topline"
      -- separator = nil,        -- or "-"
    -- })

		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
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
}
