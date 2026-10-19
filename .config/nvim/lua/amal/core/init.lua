-- init.lua (core)

require("amal.core.settings")
require("amal.core.keymaps")
require("amal.core.autocmd")

-- auto-load every side-effect module in core/config/, alphabetical
local configDir = vim.fn.stdpath("config") .. "/lua/amal/core/config"
local names = {}

for name, kind in vim.fs.dir(configDir) do
	if kind == "file" and vim.endswith(name, ".lua") then
		names[#names + 1] = name:sub(1, -5)
	end
end

table.sort(names)

for _, name in ipairs(names) do
	local ok, err = pcall(require, "amal.core.config." .. name)
	if not ok then
		vim.notify("Failed to load amal.core.config." .. name .. ": " .. err, vim.log.levels.ERROR)
	end
end
