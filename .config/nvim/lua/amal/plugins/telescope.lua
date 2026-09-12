return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	keys = {
		"<space><space>",
		"<space>tn",
		"<space>tc",
		"<Leader>o",
		"<Leader>fg",
		"<Leader>fc",
		"<Leader>b",
		"<Leader>fb",
	},
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
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local harpoon = require("harpoon")
		local Path = require("plenary.path")

		-- harpoon setup
		local function add_to_harpoon(prompt_bufnr)
			local picker = action_state.get_current_picker(prompt_bufnr)
			local selections = picker:get_multi_selection()
			if vim.tbl_isempty(selections) then
				selections = { action_state.get_selected_entry() }
			end
			local list = harpoon:list()
			local root = list.config.get_root_dir()
			local existing = {}
			for _, item in ipairs(list.items) do
				if item and item.value then
					existing[item.value] = true
				end
			end
			local added = 0
			local skipped = 0
			for _, entry in ipairs(selections) do
				local path = entry.path
					or entry.filename
					or entry.value
					or (entry.cwd and entry.ordinal and vim.fs.joinpath(entry.cwd, entry.ordinal))
				if path then
					if not Path:new(path):is_absolute() then
						path = vim.fs.joinpath(vim.loop.cwd(), path)
					end
					-- i cannot bare looking at absolute paths.
					local relative = Path:new(path):make_relative(root)
					if vim.fn.filereadable(path) == 1 and not existing[relative] then
						local item = list.config.create_list_item(list.config, relative)
						list:add(item)
						existing[relative] = true
						added = added + 1
					else
						skipped = skipped + 1
					end
				end
			end

			actions.close(prompt_bufnr)

			vim.schedule(function()
				vim.notify(
					("Harpoon: added %d file%s%s"):format(
						added,
						added == 1 and "" or "s",
						skipped > 0 and (" (" .. skipped .. " skipped)") or ""
					),
					vim.log.levels.INFO
				)
			end)
		end

		telescope.setup({
			defaults = {
				color_devicons = false,
				prompt_prefix = " ",
				entry_prefix = "    ",
				selection_caret = "   ", -- (       󰊠 )
				path_display = { "smart" },
				layout_strategy = "vertical",
				layout_config = { preview_cutoff = 0 },
				cache_picker = { num_pickers = 10 },
				preview = { treesitter = false },
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<Down>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Up>"] = "move_selection_previous",
						["<CR>"] = "select_default",
						["<C-y>"] = "select_default",
						["<C-h>"] = add_to_harpoon,
					},
					n = {
						["<C-j>"] = "move_selection_next",
						["<Down>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<Up>"] = "move_selection_previous",
						["<CR>"] = "select_default",
						["<C-y>"] = "select_default",
						["<C-h>"] = add_to_harpoon,
					},
				},
				borderchars = {
					prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
		keymap.set("n", "<space><space>", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<space>tn", "<cmd>Telescope noice<CR>", { desc = "Find noice previous messages" })
		keymap.set("n", "<space>tc", "<cmd>Telescope colorscheme<CR>", { desc = "Browse colorschemes" })
		keymap.set("n", "<Leader>o", function()
			builtin.oldfiles(require("telescope.themes").get_dropdown({ previewer = false }))
		end, { desc = "Recent files in cwd" })
		keymap.set("n", "<Leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<Leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "String under cursor in cwd" })
		keymap.set("n", "<Leader>b", builtin.buffers, { desc = "Buffers in Telescope" })

		keymap.set("n", "<Leader>fb", function()
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
		end, { desc = "Open File Browser with current buffer's path" })
	end,
}
