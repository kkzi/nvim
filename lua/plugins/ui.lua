return {
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({})
        end,
    },
    { "folke/which-key.nvim" },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = { width = 50 },
                -- sync_root_with_cwd = true,
                -- reload_on_bufenter = true,
                -- respect_buf_cwd = false,
                update_focused_file = { enable = true, update_root = false, ignore_list = {} },
                -- filters = { dotfiles = true },
            })
        end,
    },
    {
        "romgrk/barbar.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            animation = false,
            maximum_padding = 2,
            sidebar_filetypes = { NvimTree = { event = "BufWipeout", text = "Explorer" } },
            icons = { buffer_index = true, inactive = { separator = { left = "|" } }, separator = { left = "|" } },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = { icons_enabled = false, theme = "auto", component_separators = "|", section_separators = "" },
                sections = { lualine_x = { "encoding", "fileformat", "filetype" } },
            })
        end,
    },
    { "akinsho/toggleterm.nvim", config = true, opts = { float_opts = { border = "curved" } } },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { defaults = { preview = false } },
    },
    {
        "folke/persistence.nvim",
        config = function()
            require("persistence").setup({
                dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
                options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
                pre_save = nil, -- a function to call before saving the session
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "gs",
                    normal_cur = "gss",
                    normal_line = "gS",
                    normal_cur_line = "gSS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                },
            })
        end,
    },
    {
        "echasnovski/mini.align",
        config = function()
            require("mini.align").setup()
        end,
    },
    {
        "echasnovski/mini.comment",
        config = function()
            require("mini.comment").setup()
        end,
    },
    {
        "echasnovski/mini.indentscope",
        config = function()
            local scope = require("mini.indentscope")
            scope.setup({
                draw = {
                    delay = 50, --animation=scope.gen_animation.none()
                },
                symbol = "|",
            })
        end,
    },
    {
        "echasnovski/mini.jump",
        config = function()
            require("mini.jump").setup()
        end,
    },
    -- { 'echasnovski/mini.cursorword', config=function() require('mini.cursorword').setup() end,},
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
            require("illuminate").configure({
                delay = 200,
                filetypes_denylist = {
                    "NvimTree",
                    "toggleterm",
                    "TelescopePrompt",
                },
            })
        end,
        keys = {
            {
                "]r",
                function()
                    require("illuminate").goto_next_reference(false)
                end,
                desc = "illuminate Next Reference",
            },
            {
                "[r",
                function()
                    require("illuminate").goto_prev_reference(false)
                end,
                desc = "illuminate Prev Reference",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { -- :TSInstallInfo
                    "c",
                    "cpp",
                    "python",
                },
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = false,
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
                -- Diagnostic keymaps
                --vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
                --vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
                --vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float) -- diagnostic float
                --vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist) -- diagnostic quickfix
            })
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        -- build='make', cond=vim.fn.executable 'make' == 1,
    },
}
