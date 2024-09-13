local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", "<ESC>", "<CMD>nohl<CR>", { desc = "clear hilights" })

-- map("i", "jk", "<esc>")
map("n", ";", ":")
map("n", "gh", "_", { desc = "goto line start" })
map("n", "gl", "$", { desc = "goto line end" })
map("n", "ge", "G", { desc = "goto last line" })
map("n", "<A-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<A-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<A-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<A-k>", "<C-w>k", { desc = "switch window up" })

map({ "c", "i" }, "<S-Insert>", "<C-r>+")
map({ "c", "i" }, "<C-v>", "<C-r>+", {})
map({ "n", "i", "v" }, "<C-s>", "<CMD>w<CR>", {})

-- preference
local edit_file = function(file)
	vim.cmd("edit " .. vim.fn.stdpath("config") .. file)
end
map("n", "<Leader>zp", "<CMD>e $MYVIMRC<CR>", { desc = "Edit init.lua" })
map("n", "<C-,>", function()
	edit_file("/lua/plugins/core.lua")
end, { desc = "Edit core.lua" })
map("n", "<Leader>zc", function()
	edit_file("/lua/plugins/core.lua")
end, { desc = "Edit core.lua" })
map("n", "<Leader>zm", function()
	edit_file("/lua/mappings.lua")
end, { desc = "Edit mappings.lua" })
map("n", "<Leader>zo", function()
	edit_file("/lua/options.lua")
end, { desc = "Edit options.lua" })

map("n", "<leader>zz", "<CMD>colo randomhue<CR>", { desc = "Randomhue" })

-- c++
-- map({ "i", "n" }, "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>")
--
