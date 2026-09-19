-- grep setup
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
	vim.opt.grepformat = "%f:%l:%c:%m"
end
