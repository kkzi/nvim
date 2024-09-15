local addkey = vim.keymap.set
-- local delkey = vim.keymap.del

addkey("n", "<ESC>", "<CMD>nohl<CR>", { desc = "clear hilights" })

-- map("i", "jk", "<esc>")
addkey("n", ";", ":")
addkey("n", "gh", "_", { desc = "Go to line start" })
addkey("n", "gl", "$", { desc = "Go to line end" })
addkey("n", "ge", "G", { desc = "Go to last line" })
addkey("n", "<A-h>", "<C-w>h", { desc = "Switch window left" })
addkey("n", "<A-l>", "<C-w>l", { desc = "Switch window right" })
addkey("n", "<A-j>", "<C-w>j", { desc = "Switch window down" })
addkey("n", "<A-k>", "<C-w>k", { desc = "Switch window up" })
addkey("i", "<A-h>", "<Left>", { desc = "Left" })
addkey("i", "<A-l>", "<Right>", { desc = "Right" })
addkey("i", "<A-j>", "<Down>", { desc = "Down" })
addkey("i", "<A-k>", "<Up>", { desc = "Up" })
addkey("n", ",y", '"+yy', { desc = "Copy to clipboard" })
addkey("v", ",y", '"+y', { desc = "Copy to clipboard" })
addkey({ "n", "v" }, ",p", '"+p', { desc = "Paste from clipboard" })
addkey({ "n", "v" }, ",P", '"+P', { desc = "Paste from clipboard" })

addkey({ "c", "i" }, "<S-Insert>", "<C-r>+")
addkey({ "c", "i" }, "<C-v>", "<C-r>+", {})
addkey({ "n", "i", "v" }, "<C-s>", "<CMD>w<CR>", {})

addkey("n", "<Leader>fd", "<CMD>cd %:p:h<CR>", { desc = "Chdir" })
addkey({ "n", "i" }, "<A-w>", "<CMD>:bd<CR>", { desc = "Close buffer" })

-- preference
local edit_file = function(file)
	vim.cmd("edit " .. vim.fn.stdpath("config") .. file)
end
addkey("n", "<Leader>zp", "<CMD>e $MYVIMRC<CR>", { desc = "Edit init.lua" })
addkey("n", "<C-,>", "<CMD>e $MYVIMRC<CR>", { desc = "Edit init.lua" })
addkey("n", "<Leader>zc", function()
	edit_file("/lua/plugins/core.lua")
end, { desc = "Edit core.lua" })
addkey("n", "<Leader>zm", function()
	edit_file("/lua/mappings.lua")
end, { desc = "Edit mappings.lua" })
addkey("n", "<Leader>zo", function()
	edit_file("/lua/options.lua")
end, { desc = "Edit options.lua" })

addkey("n", "<leader>zz", "<CMD>colo randomhue<CR>", { desc = "Randomhue" })

-- c++
-- map({ "i", "n" }, "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>")
--
