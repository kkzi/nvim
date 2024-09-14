local addkey = vim.keymap.set
-- local delkey = vim.keymap.del

addkey("n", "<ESC>", "<CMD>nohl<CR>", { desc = "clear hilights" })

-- map("i", "jk", "<esc>")
addkey("n", ";", ":")
addkey("n", "gh", "_", { desc = "goto line start" })
addkey("n", "gl", "$", { desc = "goto line end" })
addkey("n", "ge", "G", { desc = "goto last line" })
addkey("n", "<A-h>", "<C-w>h", { desc = "switch window left" })
addkey("n", "<A-l>", "<C-w>l", { desc = "switch window right" })
addkey("n", "<A-j>", "<C-w>j", { desc = "switch window down" })
addkey("n", "<A-k>", "<C-w>k", { desc = "switch window up" })

addkey({ "c", "i" }, "<S-Insert>", "<C-r>+")
addkey({ "c", "i" }, "<C-v>", "<C-r>+", {})
addkey({ "n", "i", "v" }, "<C-s>", "<CMD>w<CR>", {})

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
