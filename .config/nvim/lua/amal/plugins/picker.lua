return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			ui_select = false,
			prompt = "   ",
			icons = {
				ui = {
					unselected = " 󰝦  ",
					selected = " 󰐙  ",
				},
			},
			formatters = {
				file = {
					filename_first = false,
					truncate = "center",
					filename_only = false,
				},
				selected = {
					show_always = true,
					unselected = true,
				},
			},
			matcher = {
				fuzzy = true,
				smartcase = true,
				ignorecase = true,
			},
			layout = { preset = "telescope" },
			sources = {
				files = { layout = { preset = "vertical" } },
				grep = { layout = { preset = "vertical" } },
				recent = { layout = { preset = "select" } },
				buffers = { layout = { preset = "vscode" } },
			},
			layouts = {
				vertical = {
					reverse = true,
					layout = {
						width = 0.75,
						min_width = 70,
						height = 0.9,
						min_height = 40,
						box = "vertical",
						border = "none",
						title_pos = "center",
						{ win = "preview", title = "{preview}", border = "single" },
						{ win = "list", title = "Results", height = 0.4, border = "single" },
						{ win = "input", title = "{title} {live} {flags}", height = 1, border = "single" },
					},
				},
			},
			win = {
				input = {
					keys = {
						["<C-y>"] = { "confirm", mode = { "i", "n" } },
						["<C-h>"] = {
							function()
								local picker = Snacks.picker.get()[1]
								if not picker then
									return
								end

								local items = picker:selected({ fallback = true })
								if not items or #items == 0 then
									local cur = picker:current()
									items = cur and { cur } or {}
								end

								local harpoon = require("harpoon")
								local list = harpoon:list()
								local root = list.config.get_root_dir()
								local Path = require("plenary.path")
								local existing = {}
								for _, item in ipairs(list.items) do
									if item and item.value then
										existing[item.value] = true
									end
								end

								local added, skipped = 0, 0
								for _, item in ipairs(items) do
									local path = item.file or item.text
									if path then
										if not Path:new(path):is_absolute() then
											path = vim.fs.joinpath(vim.loop.cwd(), path)
										end
										local relative = Path:new(path):make_relative(root)
										if vim.fn.filereadable(path) == 1 and not existing[relative] then
											list:add(list.config.create_list_item(list.config, relative))
											existing[relative] = true
											added = added + 1
										else
											skipped = skipped + 1
										end
									end
								end

								picker:close()
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
							end,
							mode = { "i", "n" },
						},
					},
				},
				list = { keys = { ["<C-y>"] = "confirm" } },
			},
		},
	},
	keys = {
		{
			"<leader>tm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Show Marks",
		},
		{
			"<leader>tr",
			function()
				Snacks.picker.registers()
			end,
			desc = "Show Registers",
		},
		{
			"<leader>th",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Show Highlights",
		},
		{
			"<leader>tk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Show Keymaps",
		},
		{
			"<leader>ls",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Lsp Symbols",
		},
		{
			"<leader>lS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Lsp Workspace Symbols",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Open Explorer",
		},
		{
			"<space><space>",
			function()
				Snacks.picker.files()
			end,
			desc = "Fuzzy find files in cwd",
		},
		{
			"<Leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep for a string",
		},
		{
			"<Leader>fc",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep string under cursor in cwd",
		},
		{
			"<Leader>bb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Show open buffers",
		},
		{
			"<Leader>o",
			function()
				Snacks.picker.recent({ layout = { preset = "select" } })
			end,
			desc = "Show recent files",
		},
		{
			"<space>tc",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Browse Colorschemes",
		},
		{
			"<Leader>fb",
			function()
				Snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Explorer at current buffer path",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
	},
}
