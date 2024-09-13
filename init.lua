local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require "options"
require "mappings"
require "autocmds"

local plugins = {
  { "echasnovski/mini.basics", opts = {} },
  { "echasnovski/mini.align", opts = {} },
  { "echasnovski/mini.icons", opts = {} },
  { "echasnovski/mini.statusline", opts = {} },
  { "echasnovski/mini.pairs", opts = {} },
  {
    "echasnovski/mini.hues",
    priority = 100,
    config = function()
      vim.cmd "colo randomhue"
    end,
  },
  {
    "echasnovski/mini.notify",
    priority = 100,
    config = function()
      vim.notify = require("mini.notify").make_notify()
    end,
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      local indent = require "mini.indentscope"
      indent.setup {
        draw = {
          delay = 50,
          animation = indent.gen_animation.quadratic { easing = "out", duration = 10, unit = "step" },
        },
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "\\s", -- Add surrounding in Normal and Visual modes
        delete = "\\d", -- Delete surrounding
        find = "\\f", -- Find surrounding (to the right)
        find_left = "\\F", -- Find surrounding (to the left)
        highlight = "\\h", -- Highlight surrounding
        replace = "\\c", -- Replace surrounding
        update_n_lines = "\\sn", -- Update `n_lines`
        suflix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  {
    "echasnovski/mini.clue",
    priority = 101,
    config = function()
      local miniclue = require "mini.clue"
      miniclue.setup {
        window = { delay = 250 },
        triggers = {
          { mode = "n", keys = "<LocalLeader>" },
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "i", keys = "<C-x>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },
          { mode = "n", keys = "<C-w>" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
  {
    "willothy/nvim-cokeline",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      sidebar = {
        -- filetype = { "neo-tree" },
        components = { { text = " Explorer" } },
      },
      default_hl = {
        bg = function(buffer)
          local hlgroups = require "cokeline.hlgroups"
          return buffer.is_focused and "#CCCC00" or hlgroups.get_hl_attr("ColorColumn", "bg")
        end,
        fg = function(buffer)
          local hlgroups = require "cokeline.hlgroups"
          return buffer.is_focused and "#000000" or hlgroups.get_hl_attr("Normal", "fg")
        end,
      },
    },
    keys = function()
      local coke = require "cokeline.mappings"
      return {
        { "<TAB>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
        { "<S-TAB>", "<Plug>(cokeline-focus-prev)", desc = "Prev buffer" },
        { "<Leader>b", "<Plug>(cokeline-pick-focus)", desc = "Pick buffer" },
        { "<Leader>c", "<Plug>(cokeline-pick-close)", desc = "Close buffer" },
      }
    end,
  },
  { "marklcrns/vim-smartq", opts = {}, keys = { { "<A-w>", "<Plug>(smartq_this)", desc = "Next buffer" } } },
  { "gelguy/wilder.nvim", opts = { modes = { ":", "?", "/" } } },
  {
    "sindrets/diffview.nvim",
    opts = {},
    keys = {
      { "<Leader>gd", "<CMD>DiffviewOpen<CR>", desc = "Open diffview" },
      { "<Leader>gc", "<CMD>DiffviewClose<CR>", desc = "Close diffview" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = function()
      local tree = require "neo-tree.command"
      return {
        {
          "<Leader>fe",
          function()
            tree.execute { action = "show", toggle = true, position = "left", dir = "." }
          end,
          desc = "Toggle explorer",
        },
        {
          "<Leader>fH",
          function()
            tree.execute { action = "show", toggle = false, position = "left", dir = "~" }
          end,
          desc = "Explorer Home",
        },
        {
          "<Leader>fE",
          function()
            vim.cmd "cd %:p:h"
            tree.execute { action = "show", focus = true, position = "left" }
          end,
          desc = "Reload neotree",
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local is_windows = vim.fn.has "win32" ~= 0
      local sep = is_windows and "\\" or "/"
      local delim = is_windows and ";" or ":"
      vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
      require("mason").setup { ui = { border = "single" } }
      local handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
        end,
        ["lua_ls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          }
        end,
      }
      require("mason-lspconfig").setup { handlers = handlers }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      -- ":TSUpdate",
      require("nvim-treesitter.install").update { with_sync = true }()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      defaults = {
        -- layout_strategy = 'vertical',
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
    keys = function()
      local tb = require "telescope.builtin"
      return {
        { "<Leader>ff", tb.find_files, desc = "Telescope find files" },
        { "<Leader>fo", tb.oldfiles, desc = "Telescope find recent files" },
        { "<Leader>fb", tb.buffers, desc = "Telescope buffers" },
        { "<Leader>fc", tb.commands, desc = "Telescope commands" },
        { "<Leader>ft", tb.colorscheme, desc = "Telescope colorscheme" },
        { "<Leader>fk", tb.keymaps, desc = "Telescope keymap" },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      local cmp = require "cmp"
      cmp.setup {
        formatting = {
          format = function(_, item)
            local MAX_LABEL_WIDTH = 64
            local content = item.abbr
            if #content > MAX_LABEL_WIDTH then
              item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. "..."
            else
              item.abbr = content .. (" "):rep(MAX_LABEL_WIDTH - #content)
            end
            return item
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
          -- keyword_length = 2,
        },
        performance = {
          max_view_entries = 10,
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
              -- elseif has_words_before() then
              -- 	cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        clang_format = {
          prepend_args = { "--style=file", "--fallback-style=Microsoft" },
        },
      },
    },
    keys = function()
      local conform = require "conform"
      return {
        {
          "<Leader>fm",
          function()
            conform.format { async = true, lsp_fallback = true }
          end,
          desc = "Format buffer",
        },
      }
    end,
  },
}

require("lazy").setup { plugins }
