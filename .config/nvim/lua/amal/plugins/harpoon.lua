return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		"<C-t>",
		"<C-y>",
		"<C-h>",
		"<C-j>",
		"<C-k>",
		"<C-l>",
		"<C-S-P>",
		"<C-S-N>",
		"<leader>1",
		"<leader>2",
		"<leader>3",
		"<leader>4",
		"<leader>5",
		"<leader>6",
		"<leader>7",
		"<leader>8",
		"<leader>9",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local silent = { silent = true }
		local set = vim.keymap.set

		-- mark / add file
		set("n", "<C-t>", function()
			harpoon:list():add()
		end, silent)

		-- toggle quick menu
		set("n", "<C-y>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, silent)

		set("n", "<C-h>", function()
			harpoon:list():select(1)
		end, silent)
		set("n", "<C-j>", function()
			harpoon:list():select(2)
		end, silent)
		set("n", "<C-k>", function()
			harpoon:list():select(3)
		end, silent)
		set("n", "<C-l>", function()
			harpoon:list():select(4)
		end, silent)

		for i = 1, 9 do
			set("n", "<leader>" .. i, function()
				harpoon:list():select(i)
			end, { silent = true, desc = "Harpoon file " .. i })
		end

		set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, silent)
		set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, silent)
	end,
}
