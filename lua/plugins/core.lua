return {
	{ "echasnovski/mini.basics", opts = {} },
	{ "echasnovski/mini.align", opts = {} },
	{
		"echasnovski/mini.hues",
		config = function()
			vim.cmd("colorscheme randomhue")
		end,
	},
	{
		"marklcrns/vim-smartq",
		keys = { { "<A-w>", "<Plug>(smartq_this)", desc = "Telescope find files" } },
	},
	{
		"echasnovski/mini.clue",
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
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
				window = { delay = 250 },
			})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		opts = {},
		keys = function()
			local tree = require("neo-tree.command")
			return {
				{
					"<Leader>fe",
					function()
						tree.execute({ action = "show", toggle = true, position = "left", dir = "." })
					end,
					desc = "Toggle explorer",
				},
				{
					"<Leader>fH",
					function()
						tree.execute({ action = "show", toggle = false, position = "left", dir = "~" })
					end,
					desc = "Explorer Home",
				},
				{
					"<Leader>fE",
					function()
						vim.cmd("cd %:p:h")
						tree.execute({ action = "show", focus = true, position = "left" })
					end,
					desc = "Reload neotree",
				},
			}
		end,
	},
	{
		"willothy/nvim-cokeline",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for v0.4.0+
			"nvim-tree/nvim-web-devicons", -- If you want devicons
			--"stevearc/resession.nvim"       -- Optional, for persistent history
		},
		config = true,
		opts = {
			sidebar = {
				-- filetype = { "neo-tree" },
				components = { { text = " Explorer" } },
			},
			default_hl = {
				bg = function(buffer)
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#CCCC00" or hlgroups.get_hl_attr("ColorColumn", "bg")
				end,
				fg = function(buffer)
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#000000" or hlgroups.get_hl_attr("Normal", "fg")
				end,
			},
		},
		keys = function()
			local coke = require("cokeline.mappings") --pick("focus")
			return {
				{ "<TAB>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
				{ "<S-TAB>", "<Plug>(cokeline-focus-prev)", desc = "Prev buffer" },
				{ "<Leader>b", "<Plug>(cokeline-pick-focus)", desc = "Pick buffer" },
				{ "<Leader>c", "<Plug>(cokeline-pick-close)", desc = "Close buffer" },
			}
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				-- section_separators = { left = ' ', right = ' ' },
				component_separators = { left = " ", right = " " },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 2, -- 0: Just the filename 1: Relative path 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "neo-tree", "mason" },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			-- open_mapping = "<A-`>",
			direction = "float",
			autochdir = true,
		},
		keys = {
			{ "<A-`>", "<CMD>ToggleTerm<CR>", mode = { "n", "i", "t" }, desc = "Show terminal" },
			{ "<Esc>", "<CMD>ToggleTerm<CR>", mode = { "t" }, desc = "Hide terminal" },
		},
	},

	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
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
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			local cmp = require("cmp")
			cmp.setup({
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
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif vim.fn["vsnip#available"](1) == 1 then
							feedkey("<Plug>(vsnip-expand-or-jump)", "")
						elseif has_words_before() then
							cmp.complete()
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
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	{ "gelguy/wilder.nvim", opts = { modes = { ":", "?", "/" } } },

	{ "echasnovski/mini.pairs", opts = {} },

	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local is_windows = vim.fn.has("win32") ~= 0
			local sep = is_windows and "\\" or "/"
			local delim = is_windows and ";" or ":"
			vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

			require("mason").setup({
				ui = { border = "single" },
			})
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "neocmake", "zls" },
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<Leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				c = { "clang_format" },
				cpp = { "clang_format" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
				clang_format = {
					prepend_args = { "--style=file", "--fallback-style=Microsoft" },
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = {},
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		opts = {
			defaults = {
				-- layout_strategy = 'vertical',
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
			},
		},
		keys = function()
			local tb = require("telescope.builtin")
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
		"sindrets/diffview.nvim",
		opts = {},
		keys = {
			{ "<Leader>gd", "<CMD>DiffviewOpen<CR>", desc = "Open diffview" },
			{ "<Leader>gc", "<CMD>DiffviewClose<CR>", desc = "Close diffview" },
		},
	},
}
