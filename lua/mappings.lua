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
map("n", "<leader>zp", "<cmd>:e $MYVIMRC<CR>", { desc = "Preferences" })

-- c++
-- map({ "i", "n" }, "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>")
