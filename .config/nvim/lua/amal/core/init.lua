-- init.lua (core)

require("amal.core.settings")
require("amal.core.keymaps")
require("amal.core.autocmd")

-- auto-load every module in core/config/
local config_path = vim.fn.stdpath("config") .. "/lua/amal/core/config"
for name, type in vim.fs.dir(config_path) do
	if type == "file" and name:match("%.lua$") then
		local module = "amal.core.config." .. name:gsub("%.lua$", "")
		local ok, err = pcall(require, module)
		if not ok then
			vim.notify("Failed to load " .. module .. ": " .. err, vim.log.levels.ERROR)
		end
	end
end
