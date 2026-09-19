local root = vim.fn.stdpath("config") .. "/lua/plugins"

local top_level = vim.fn.glob(root .. "/*.lua", false, true)
local nested = vim.fn.glob(root .. "/*/init.lua", false, true)

local specs = {}
local configs = {}

local function load_module(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify("Failed to load " .. name .. ": " .. mod, vim.log.levels.ERROR)
    return
  end
  if type(mod) ~= "table" then
    vim.notify(name .. " did not return a table (got " .. type(mod) .. ")", vim.log.levels.ERROR)
    return
  end
  for _, entry in ipairs(mod) do
    table.insert(specs, { src = entry.src, version = entry.version })
    if entry.config then
      table.insert(configs, entry.config)
    end
  end
end

for _, file in ipairs(top_level) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  load_module("plugins." .. name)
end

for _, file in ipairs(nested) do
  local dir = vim.fn.fnamemodify(file, ":h")
  local name = vim.fn.fnamemodify(dir, ":t")
  load_module("plugins." .. name)
end

vim.pack.add(specs)

for _, cfg in ipairs(configs) do
  cfg()
end
