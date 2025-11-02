local addkey = vim.keymap.set
-- local delkey = vim.keymap.del

addkey("n", "<ESC>", "<CMD>nohl<CR>", { desc = "clear hilights" })

-- map("i", "jk", "<esc>")
addkey("n", ";", ":")
addkey("n", ">", ">>")
addkey("n", "<", "<<")
addkey("n", "gh", "_", { desc = "Go to line start" })
addkey("n", "gl", "$", { desc = "Go to line end" })
addkey("n", "ge", "G", { desc = "Go to last line" })
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


require("lazy").setup({
    checker = { enabled = false },
    spec = {
        {
            "echasnovski/mini.surround",
            opts = {
                mappings = {
                    add = "ysiw", -- Add surrounding in Normal and Visual modes
                    delete = "ds", -- Delete surrounding
                    replace = "cs", -- Replace surrounding
                },
            },
        }
    }
})
