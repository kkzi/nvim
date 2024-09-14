local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = augroup,
	pattern = { "init.lua", "options.lua", "mappings.lua", "autocmds.lua" },
	command = "source $MYVIMRC",
})
