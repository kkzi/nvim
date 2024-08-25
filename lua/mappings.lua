require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- override
nomap("n", "<leader>h")
nomap("n", "<leader>v")
nomap("n", "<leader>n")
nomap("n", "<leader>b")
nomap({ "n", "t" }, "<A-i>")

map({ "n", "i", "t" }, "<A-`>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "FloatTerm",
    float_opts = { relative = "editor", row = 0.05, col = 0.05, width = 0.9, height = 0.8 },
  }
end, { desc = "terminal toggle floating term" })
map("t", "<ESC>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "FloatTerm",
  }
end, { desc = "hide float terminal" })

-- map("i", "jk", "<esc>")
map("n", ";", ":")
map("n", "<A-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<A-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<A-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<A-k>", "<C-w>k", { desc = "switch window up" })
map({ "n", "i", "t" }, "<A-w>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

map("n", "<leader>?", "<cmd>NvCheatsheet<CR>", { desc = "show cheatsheet" })

-- custom

map({ "c", "i" }, "<S-Insert>", "<C-r>+", {})

-- preference
map("n", "<leader>zp", "<cmd>:e $MYVIMRC<CR>", { desc = "Preferences" })
map("n", "<leader>zk", "<cmd>Telescope keymaps<CR>", { desc = "Shortcuts" })

-- c++
-- map({ "i", "n" }, "<M-o>", "<CMD>ClangdSwitchSourceHeader<CR>")
-- map({ "n, "i", "v" }, "<C-s>", "<cmd> w <cr>")
