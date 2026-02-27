return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- set header
		dashboard.section.header.val = {
			"  ⠀ ████   ████       ⠀ ████   ████       ⠀ ████   ████    ",
			"  ███   ███   ███     ███   ███   ███ ⠀   ███   ███   ███  ",
			" ██  ███   ███  ██   ██  ███   ███  ██   ██  ███   ███  ██ ",
			" ⠀ ███⠀ ⠀ ⠀⠀ ███⠀⠀   ⠀ ███⠀ ⠀ ⠀⠀ ███⠀⠀⠀  ⠀ ███⠀ ⠀ ⠀⠀ ███⠀ ⠀",
			" ██  ███   ███  ██   ██  ███   ███  ██   ██  ███   ███  ██ ",
			"  ███   ███   ███     ███   ███   ███ ⠀   ███   ███   ███  ",
			"  ⠀ ████   ████       ⠀ ████   ████   ⠀   ⠀ ████   ████    ",
			"",
			"",
		}

		dashboard.section.header.opts = {
			hl = "AlphaHeader",
			position = "center",
		}

		-- set menu with custom highlights
		dashboard.section.buttons.val = {
			dashboard.button("n", "󰓎  →  create new file", "<cmd>ene<CR>"),
			dashboard.button("f", "󰓎  →  find a file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("r", "󰓎  →  recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("e", "󰓎  →  toggle explorer", ":Neotree filesystem toggle<CR>"),
			dashboard.button("l", "󰓎  →  lazy plugins", "<cmd>Lazy<CR>"),
			dashboard.button("c", "󰓎  →  config files", "<cmd>Telescope find_files cwd=$nv<CR>"),
			dashboard.button("q", "󰓎  →  quit neovim", "<cmd>qa<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaHeader"
			button.opts.hl_shortcut = "AlphaHeader"
		end

		-- version info (centered properly)
		local nvim_version = vim.version()
		local raw_version =
			string.format("[ using neovim v%s.%s.%s ]", nvim_version.major, nvim_version.minor, nvim_version.patch)

		dashboard.section.version = {
			type = "text",
			opts = {
				position = "center",
				hl = "AlphaFooter",
			},
		}

		dashboard.section.version.val = {
			"",
			"",
			"",
			raw_version,
		}

		-- random quote generator
		local function get_random_quote()
			local file_path = "C:/Users/amall/AppData/Local/nvim/lua/amal/plugins/config/quotes.json"
			local file = io.open(file_path, "r")
			if not file then
				return "\" on days like these kids like you should be playing nintendo games. \""
			end
			local content = file:read("*all")
			file:close()
			local quotes = vim.fn.json_decode(content).quotes
			math.randomseed(os.time())
			local random_index = math.random(1, #quotes)
			return quotes[random_index]
		end

		dashboard.section.footer.val = { get_random_quote() }

		dashboard.section.footer.opts = {
			hl = "AlphaHeader",
			position = "center",
		}

		-- layout configuration
		dashboard.config.layout = {
			{ type = "padding", val = math.floor(vim.fn.winheight(0) * 0.2) },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			dashboard.section.version,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		alpha.setup(dashboard.opts)

		-- disable folding
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
