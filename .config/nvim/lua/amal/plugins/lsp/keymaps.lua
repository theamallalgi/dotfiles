local map = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = {
			buffer = event.buf,
			silent = true,
		}

		map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
		map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
		map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
		map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		map("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type Definition" }))
		map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		map("i", "<C-h>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
		map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
		map("n", "<leader>fs", function()
			vim.lsp.buf.format({ async = true })
		end, vim.tbl_extend("force", opts, { desc = "Format Buffer" }))
		-- map(
		-- 	"n",
		-- 	"<leader>ls",
		-- 	"<cmd>Telescope lsp_document_symbols<cr>",
		-- 	vim.tbl_extend("force", opts, { desc = "Document Symbols" })
		-- )
		map("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Actions" }))
		---@diagnostic disable-next-line: deprecated
		-- map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
		---@diagnostic disable-next-line: deprecated
		-- map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1 }) -- removed `float = true`
			vim.cmd("normal! zz")
		end, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))

		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1 }) -- removed `float = true`
			vim.cmd("normal! zz")
		end, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
	end,
})
