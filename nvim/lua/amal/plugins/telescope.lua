return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local keymap = vim.keymap

		telescope.setup({
			defaults = {
				shorten_path = true,
        color_devicons = false,
				prompt_prefix = "   ",
				entry_prefix = "    ",
				selection_caret = " ➤  ",
				path_display = { "smart" },
				layout_strategy = "vertical",
				layout_config = { preview_cutoff = 0 },
				cache_picker = {
					num_pickers = 10,
				},
        preview = {
          treesitter = false,
        },
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<Down>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Up>"] = "move_selection_previous",
						["<CR>"] = "select_default",
						["<C-y>"] = "select_default",
					},
					n = {
						["<C-j>"] = "move_selection_next",
						["<Down>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Up>"] = "move_selection_previous",
						["<CR>"] = "select_default",
						["<C-y>"] = "select_default",
					},
				},
        borderchars = {
          prompt  = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		local load_extension = function(name)
			pcall(telescope.load_extension, name)
		end
		load_extension("fzf")
		load_extension("file_browser")

		-- Keybindings
		keymap.set("n", "<space><space>", "<cmd>:Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<space>tn", "<cmd>:Telescope noice<CR>", { desc = "Find noice previous messages" })
		keymap.set("n", "<space>cc", "<cmd>:Telescope colorscheme<CR>", { desc = "Browse colorschemes" })
		keymap.set("n", "<Leader>o", function()
			builtin.oldfiles(require("telescope.themes").get_dropdown({ previewer = false }))
		end, { desc = "Recent files in cwd" })
		keymap.set("n", "<Leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<Leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "String under cursor in cwd" })
		keymap.set("n", "<Leader>b", builtin.buffers, {})

		keymap.set("n", "<Leader>f", function()
			telescope.extensions.file_browser.file_browser({
				path = "%:p:h",
				cwd = vim.fn.expand("%:p:h"),
				respect_gitignore = false,
				hidden = true,
				grouped = true,
				previewer = false,
				initial_mode = "normal",
				layout_config = { height = 40 },
			})
		end, { desc = "Open File Browser with the path of the current buffer" })
	end,
}
