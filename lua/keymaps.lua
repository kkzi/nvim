-- https://github.com/ellisonleao/neovimfiles/blob/main/lua/e/configs/keymaps.lua


local opts = { silent = true }
local mappings = {
    { {"n", "i"}, "<Esc>", "<Cmd>nohl<CR><Esc>", opts }, -- clear search highlight
    { {"c", "i" }, "<S-Insert>", "<C-r>+", opts },
    -- { "i", "<Tab>", [[pumvisible() ? (complete_info().selected == -1 ? "<C-e><Tab>" : "<C-y>") : "<TAB>"]], opts },
    { "n", "<C-d>", "<C-d>zz", opts },
    { "n", "<C-u>", "<C-u>zz", opts },
    -- { "n", "<C-k>", "gg=G``zz", opts },
    -- { "i", "<C-k>", "<Esc>gg=G``azz", opts },

    { "n", "j", "gj", opts },
    { "n", "k", "gk", opts },
    { "n", "gl", "$", opts },
    { "n", "gh", "^", opts },
    { "n", "ge", "G", opts },
    -- { {"n", "i"}, "<M-j>", "<Down>", opts },
    -- { {"n", "i"}, "<M-k>", "<Up>", opts },
    { "n", "<M-;>", "$", opts },
    { "i", "<M-;>", "<Esc>$a", opts },

    -- focus window --
    {{ "n", "i", "t" }, "<M-h>", "<Cmd>wincmd h<CR>", { silent = true, desc = "Focus left  window"  }},
    {{ "n", "i", "t" }, "<M-l>", "<Cmd>wincmd l<CR>", { silent = true, desc = "Focus lower window" }},
    {{ "n", "i", "t" }, "<M-j>", "<Cmd>wincmd j<CR>", { silent = true, desc = "Focus upper window" }},
    {{ "n", "i", "t" }, "<M-k>", "<Cmd>wincmd k<CR>", { silent = true, desc = "Focus right window" }},

    -- copy and paste --
    {"n", "<leader>y", '"+yy', {silent=true, desc="Copy to clipboard"}},
    {"n", "<leader>x", '"+dd' , {silent=true, desc="Cut to clipboard"}},
    {"n", "<leader>p", '"+p' , {silent=true, desc="Paste from clipboard"}},
    {"n", "<leader>P", '"+P' , {silent=true, desc="Paste from clipboard before cursor"}},
    {"v", "<leader>y", '"+y' },
    {"v", "<leader>x", '"+x' },
    {"v", "<C-c>", '"+y',     {silent=true, desc="Copy to system clipboard"} },
    {{ "i", "c" }, "<C-v>", "<C-r>+", {silent=true, desc="Copy form system clipboard"} },

    { { "n", "i", "t" }, "<M-`>", "<Cmd>:ToggleTerm direction=float<CR>"},
    { "t", "<ESC>", "<Cmd>:ToggleTerm<CR>", { nowait = true, desc = "Hide terminal" }},
}

for _, map in pairs(mappings) do
    vim.keymap.set(unpack(map))
end



local wk = require("which-key")
wk.register({
    b = {
        name = "+Buffer",
        b = {"<Cmd>BufferPick<CR>", "Buffer picker"},
        d = {"<Cmd>bd<CR>", "Close current buffer" },
        n = {"<Cmd>bn<CR>", "Next buffer" },
        p = {"<Cmd>bp<CR>", "Previous buffer" },
        x = {"<Cmd>qa<CR>", "Quit" },
    },

    f = {
        name = "+File and telescope",
        e = { "<Cmd>NvimTreeFocus<CR>", "Focus Tree" },
        E = { "<Cmd>NvimTreeToggle<CR>", "Toggle Tree" },
        b = { require('telescope.builtin').buffers, "Find buffers" },
        c = { require('telescope.builtin').commands, "Show commands" },
        f = { require('telescope.builtin').find_files, "Find file" },
        g = { require('telescope.builtin').live_grep, "Live grep" },
        h = { require('telescope.builtin').help_tags, "Show help tags" },
        j = { require('telescope.builtin').jumplist, "Show jump list" },
        k = { require('telescope.builtin').keymaps, "Show keymaps" },
        m = { require('telescope.builtin').marks, "Show Marks" },
        r = { require('telescope.builtin').oldfiles, "Find old file" },
        s = { require('telescope.builtin').colorscheme, "Colorscheme" },
        q = { require('telescope.builtin').quickfix, "Quickfix" },
    },

    i = {
        name = "+Inspect",
        c = {"<Cmd>Inspect<CR>", "Inspect" },
        t = {"<Cmd>InspectTree<CR>", "Inspect Tree" },
    },

    q = {
        name = '+Session',
        d = { require("persistence").stop,  '' },
        s = { require("persistence").load,  '' },
        l = { function() require("persistence").load{last = true} end,  ''},
    },

    z = {
        name = "+Settings and other",
        k = {"<Cmd>Telescope keymaps<CR>", "Show keyboards" },
        u = {"<Cmd>e $LOCALAPPDATA/nvim/lua/plugins/ui.lua<CR>", "Edit ui.lua" },
        l = {"<Cmd>e $LOCALAPPDATA/nvim/lua/plugins/lsp.lua<CR>", "Edit lsp.lua" },
        m = {"<Cmd>e $LOCALAPPDATA/nvim/lua/keymaps.lua<CR>", "Edit keymaps.lua" },
        p = {"<Cmd>e $MYVIMRC<CR>", "Edit init.lua" },
    },
}, { prefix = "<leader>", mode="n" })



wk.register({
    -- bufferline barbar
    ["<leader>w"] = { mode="n", "<Cmd>BufferClose<CR>", "Close buffer",  silent=true, },
    ["H"] =         { mode="n", "<Cmd>BufferPrevious<CR>", "Previous buffer"},
    ["L"] =         { mode="n", "<Cmd>BufferNext<CR>", "Next buffer"},
    ["<M-,>"]=      { "<Cmd>BufferPrevious<CR>", "Previous Buffer"},
    ["<M-.>"]=      { "<Cmd>BufferNext<CR>", "Next Buffer" },
    ["<M-1>"] =     { "<Cmd>BufferGoto 1<CR>",  "Go to buffer 1",  silent=true, },
    ["<M-2>"] =     { "<Cmd>BufferGoto 2<CR>",  "Go to buffer 2",  silent=true, },
    ["<M-3>"] =     { "<Cmd>BufferGoto 3<CR>",  "Go to buffer 3",  silent=true, },
    ["<M-4>"] =     { "<Cmd>BufferGoto 4<CR>",  "Go to buffer 4",  silent=true, },
    ["<M-5>"] =     { "<Cmd>BufferGoto 5<CR>",  "Go to buffer 5",  silent=true, },
    ["<M-6>"] =     { "<Cmd>BufferGoto 6<CR>",  "Go to buffer 6",  silent=true, },
    ["<M-7>"] =     { "<Cmd>BufferGoto 7<CR>",  "Go to buffer 7",  silent=true, },
    ["<M-8>"] =     { "<Cmd>BufferGoto 8<CR>",  "Go to buffer 8",  silent=true, },
    ["<M-9>"] =     { "<Cmd>BufferGoto 9<CR>",  "Go to buffer 9",  silent=true, },
    ["<M-0>"] =     { "<Cmd>BufferGoto 10<CR>", "Go to buffer 10", silent=true, },

    -- clangd
    [ "<M-o>" ] =   { "<Cmd>ClangdSwitchSourceHeader<CR>", "Switch between header and source file"},
    [ "<M-p>" ] =   { "<Cmd>ClangdSymbolInfo<CR>", "Symbol info"},

    -- formatter
    -- ['<C-k>'] =  { vim.lsp.buf.format, 'Format document', buffer=bufnr },
    -- ['<C-k>'] =     { '<Cmd>Format<CR>', 'Format document', buffer=bufnr },
    ['<C-k>'] = {
        function()
            vim.lsp.buf.format({
                filter = function(client)
                    -- apply whatever logic you want (in this example, we'll only use null-ls)
                    return client.name == "null-ls"
                end,
                bufnr = bufnr or vim.api.nvim_get_current_buf(),
                async = true,
            })
        end, 'Format document', buffer=bufnr
    },

}, {mode={"n", "i"}})


wk.register({
    -- lsp
    ['gd'] =          { vim.lsp.buf.definition,                                                  '[G]oto [D]efinition',         buffer=bufnr},
    ['gD'] =          { vim.lsp.buf.declaration,                                                 '[G]oto [D]eclaration',        buffer=bufnr},
    ['gI'] =          { vim.lsp.buf.implementation,                                              '[G]oto [I]mplementation',     buffer=bufnr},

    ['gp'] =          { vim.lsp.buf.hover,                                                       'Hover Documentation',         buffer=bufnr},
    ['<M-p>'] =       { vim.lsp.buf.signature_help,                                              'Signature Documentation',     buffer=bufnr},

    ['<leader>D'] =   { vim.lsp.buf.type_definition,                                             'Type [D]efinition',           buffer=bufnr},
    ["<leader>rn"] =  { vim.lsp.buf.rename,                                                      '[R]e[n]name',                 buffer=bufnr },
    ["<leader>cn"] =  { vim.lsp.buf.code_action,                                                 '[C]ode [A]ction',             buffer=bufnr },
    ['<leader>wa' ] = { vim.lsp.buf.add_workspace_folder,                                        '[W]orkspace [A]dd Folder',    buffer=bufnr},
    ['<leader>wr' ] = { vim.lsp.buf.remove_workspace_folder,                                     '[W]orkspace [R]emove Folder', buffer=bufnr},
    ['<leader>wl' ] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders',  buffer=bufnr },
}, {mode={"n"}})
