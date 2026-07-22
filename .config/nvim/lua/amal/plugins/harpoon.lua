return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local silent = { silent = true }
    local set = vim.keymap.set

    -- mark / add file
    set("n", "<C-o>", function() harpoon:list():add() end, silent)

    -- toggle quick menu
    set("n", "<C-p>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, silent)

    -- navigate to harpooned files
    set("n", "<C-e>", function() harpoon:list():select(1) end, silent)
    set("n", "<C-r>", function() harpoon:list():select(2) end, silent)
    set("n", "<C-t>", function() harpoon:list():select(3) end, silent)
    set("n", "<C-y>", function() harpoon:list():select(4) end, silent)

    -- next / prev in list
    set("n", "<C-S-P>", function() harpoon:list():prev() end, silent)
    set("n", "<C-S-N>", function() harpoon:list():next() end, silent)
  end,
}
