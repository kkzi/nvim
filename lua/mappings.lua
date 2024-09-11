local map = vim.keymap.set
local nomap = vim.keymap.del

-- override
-- nomap("n", "<leader>h")
-- nomap("n", "<leader>v")
-- nomap("n", "<leader>n")
-- nomap("n", "<leader>b")
-- nomap({ "n", "t" }, "<A-i>")

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

map({ "c", "i" }, "<S-Insert>", "<C-r>+", {})
map({ "c", "i" }, "<C-v>", "<C-r>+", {})

-- preference
map("n", "<leader>zp", "<cmd>:e $MYVIMRC<CR>", { desc = "Preferences" })
map("n", "<leader>zk", "<cmd>Telescope keymaps<CR>", { desc = "Shortcuts" })
map("n", "<leader>zc", "<cmd>cd %:p:h<CR>", { desc = "Cd current buffer file dir" })

-- c++
-- map({ "i", "n" }, "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>")
-- map({ "n, "i", "v" }, "<C-s>", "<cmd> w <cr>")
