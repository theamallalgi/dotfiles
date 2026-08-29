-- Neovide Config
if vim.g.neovide then
	vim.g.neovide_hide_mouse_when_typing = false -- hides the mouse cursor when typing
	vim.g.neovide_cursor_animate_command_line = false -- disables cursor animation on cmd mode
	-- colorscheme tokyonight-night -- colorscheme for neovide
	vim.opt.guicursor = {
		"n-v-c-sm:block-Cursor", -- Use 'Cursor' highlight for normal, visual, and command modes
		"i-ci-ve:ver25-lCursor", -- Use 'lCursor' highlight for insert and visual-exclusive modes
		"r-cr:hor20-CursorIM", -- Use 'CursorIM' for replace mode
	}
end
