return {
	"mbbill/undotree",
	config = function()
		vim.g.undotree_WindowLayout = 3
		vim.g.undotree_SplitWidth = 40
		vim.g.undotree_DiffpanelHeight = 8
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_HelpLine = 0
		vim.g.undotree_SetFocusWhenToggle = 0 -- focus undotree panel on open, 0 stays in current window
		vim.g.undotree_RelativeTimestamp = 1 -- show relative time (e.g. '5 mins') instead of absolute
		vim.g.undotree_HighlightChangedText = 0 -- highlight changed text in the buffer
		vim.g.undotree_HighlightChangedWithSign = 0 -- show change signs in the gutter
		vim.g.undotree_HighlightSyntaxAdd = "UndotreeDiffAdd" -- highlight group for added lines
		vim.g.undotree_HighlightSyntaxChange = "UndotreeDiffChange" -- highlight group for changed lines
		vim.g.undotree_HighlightSyntaxDel = "UndotreeDiffDelete" -- highlight group for deleted lines
		vim.g.undotree_TreeNodeShape = "" -- the * node dot
		vim.g.undotree_TreeVertShape = "" -- vertical branch line
		vim.g.undotree_TreeSplitShape = "" -- branch split
		vim.g.undotree_TreeReturnShape = "" -- branch return
		vim.g.undotree_SignAdded = "++" -- gutter added
		vim.g.undotree_SignChanged = "~~" -- gutter changed
		vim.g.undotree_SignDeleted = "--" -- gutter deleted
		vim.g.undotree_SignDeletedEnd = "-v" -- gutter deleted at block end
		vim.g.undotree_HelpLine = 0 -- show keybind hint line at top of panel
		vim.g.undotree_CursorLine = 0 -- highlight current node line in panel
		vim.g.undotree_StatusLine = 0 -- show statusline in undotree panel
		vim.g.undotree_DisabledFiletypes = {} -- filetypes where undotree is disabled
		vim.g.undotree_DisabledBuftypes = { "terminal", "prompt", "quickfix", "nofile" } -- buffer types where undotree is disabled

		vim.api.nvim_set_hl(0, "UndotreeNode", { fg = "#8443e4" })
		vim.api.nvim_set_hl(0, "UndotreeNodeCurrent", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "UndotreeSeq", { fg = "#64aae2" })
		vim.api.nvim_set_hl(0, "UndotreeCurrent", { fg = "#e39069", bold = true })
		vim.api.nvim_set_hl(0, "UndotreeSavedBig", { fg = "#e4465d", bold = true })
		vim.api.nvim_set_hl(0, "UndotreeSavedSmall", { fg = "#e4465d" })
		vim.api.nvim_set_hl(0, "UndotreeBranch", { fg = "#8443e4" })
		vim.api.nvim_set_hl(0, "UndotreeTimeStamp", { fg = "#5c6370" })

		vim.g.undotree_HighlightSyntaxAdd = "UndotreeDiffAdd"
		vim.g.undotree_HighlightSyntaxChange = "UndotreeDiffChange"
		vim.g.undotree_HighlightSyntaxDel = "UndotreeDiffDelete"

		vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
		vim.keymap.set("n", "<F12>", "<cmd>UndotreeToggle<cr>")
	end,
}
