return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		ensure_installed = { "lua", "javascript", "python", "vim", "vimdoc", "cpp", "c" },
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
			disable = function(lang, buf)
				if lang == "vim" then
					return true
				end
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["a/"] = "@comment.outer",
					["i/"] = "@comment.inner",
				},
			},
		},
	},
}
