require("options")
require("keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- Setup lazy.nvim
require("lazy").setup({
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
	spec = {
		{
			"echasnovski/mini.notify",
			opts = function()
				vim.notify = require("mini.notify").make_notify()
			end,
		},
		{ "echasnovski/mini.basics", opts = {} },
		{ "echasnovski/mini.align", opts = {} },
		{
			"echasnovski/mini.statusline",
			opts = function()
				local status = require("mini.statusline")
				return {
					content = {
						active = function()
							local mode, mode_hl = status.section_mode({ trunc_width = 120 })
							local git = status.section_git({ trunc_width = 40 })
							local diff = status.section_diff({ trunc_width = 75 })
							local diagnostics = status.section_diagnostics({ trunc_width = 75 })
							local lsp = status.section_lsp({ trunc_width = 75 })
							local filename = status.section_filename({ trunc_width = 140 })
							local fileinfo = function(args)
								local filetype = vim.bo.filetype
								local encoding = vim.bo.fileencoding or vim.bo.encoding
								local format = vim.bo.fileformat
								return string.format(
									"%s %s %s",
									string.upper(filetype),
									string.upper(encoding),
									string.upper(format)
								)
							end
							local search = status.section_searchcount({ trunc_width = 120 })
							return status.combine_groups({
								{ hl = mode_hl, strings = { string.upper(mode) } },
								{ hl = "statusDevinfo", strings = { git, diff, diagnostics, lsp } },
								"%=",
								{ hl = "statusFilename", strings = { filename } },
								"%=",
								{ hl = mode_hl, strings = { search } },
								{ hl = "statusFileinfo", strings = { "%3l,%-3L", fileinfo() } },
							})
						end,
					},
				}
			end,
		},
		{ "echasnovski/mini.bufremove", otps = {} },
		{
			"echasnovski/mini.pairs",
			opts = {
				modes = { insert = true, command = true, terminal = true },
			},
		},
		{
			"echasnovski/mini.surround",
			opts = {
				mappings = {
					add = "ms", -- Add surrounding in Normal and Visual modes
					delete = "md", -- Delete surrounding
					find = "mf", -- Find surrounding (to the right)
					find_left = "mF", -- Find surrounding (to the left)
					highlight = "mh", -- Highlight surrounding
					replace = "mc", -- Replace surrounding
					update_n_lines = "mn", -- Update `n_lines`
					suflix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
			},
		},
		{
			"echasnovski/mini.clue",
			opts = function()
				local miniclue = require("mini.clue")
				return {
					triggers = {
						{ mode = "n", keys = "<LocalLeader>" },
						{ mode = "n", keys = "<Leader>" },
						{ mode = "x", keys = "<Leader>" },
						{ mode = "i", keys = "<C-x>" },
						{ mode = "n", keys = "y" },
						{ mode = "n", keys = "m" },
						{ mode = "n", keys = "g" },
						{ mode = "x", keys = "g" },
						{ mode = "n", keys = "'" },
						{ mode = "n", keys = "`" },
						{ mode = "x", keys = "'" },
						{ mode = "x", keys = "`" },
						{ mode = "n", keys = '"' },
						{ mode = "x", keys = '"' },
						{ mode = "n", keys = "," },
						{ mode = "x", keys = "," },
						{ mode = "i", keys = "<C-r>" },
						{ mode = "c", keys = "<C-r>" },
						{ mode = "n", keys = "<C-w>" },
						{ mode = "n", keys = "z" },
						{ mode = "x", keys = "z" },
					},
					clues = {
						-- Enhance this by adding descriptions for <Leader> mapping groups
						{ mode = "n", keys = "<Leader>f", desc = "Find / File" },
						{ mode = "n", keys = "<Leader>g", desc = "Git  / Go to" },
						{ mode = "n", keys = "<Leader>b", desc = "Buffer" },
						{ mode = "n", keys = "<Leader>z", desc = "Misc." },
						{ mode = "n", keys = "y", desc = "Yank" },
						miniclue.gen_clues.builtin_completion(),
						miniclue.gen_clues.g(),
						miniclue.gen_clues.marks(),
						miniclue.gen_clues.registers(),
						miniclue.gen_clues.windows(),
						miniclue.gen_clues.z(),
					},
					window = { delay = 500, config = { width = 48, border = "single" } },
				}
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = { enabled = true, indent = { char = "│", tab_char = "│" } },
		},
		{ "nvim-tree/nvim-web-devicons", opts = { color_icons = false } },
		{
			"nvim-neo-tree/neo-tree.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
			opts = {
				window = { position = "left" },
				filesystem = {
					filtered_items = {
						visible = true,
						show_hidden_count = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
				buffers = { follow_current_file = { enable = true } },
			},
			keys = {
				{ "<Leader>H", "<CMD>Neotree action=focus dir=~<CR>", desc = "Explorer Home" },
				{
					"<Leader>e",
					"<CMD>Neotree action=focus reveal reveal_force_cwd<CR>",
					desc = "Explorer focus reveal ",
				},
			},
		},

		{
			"akinsho/toggleterm.nvim",
			opts = { direction = "float", hide_numbers = false, autochdir = true },
			keys = {
				{ "<A-`>", "<CMD>ToggleTerm<CR>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
				{ "<A-`>", "<CMD>ToggleTermSendVisualSelection<CR>", mode = { "v" }, desc = "Toggle terminal" },
				{ "<ESC>", "<CMD>ToggleTerm<CR>", mode = { "t" }, desc = "Hide terminal" },
			},
		},
		-- {
		-- 	"willothy/nvim-cokeline",
		-- 	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		-- 	lazy = false,
		-- 	opts = {
		-- 		sidebar = {
		-- 			components = { { text = " Explorer" } },
		-- 		},
		-- 		default_hl = {
		-- 			bg = function(buffer)
		-- 				local hlgroups = require("cokeline.hlgroups")
		-- 				return buffer.is_focused and "#71DEC1" or hlgroups.get_hl_attr("ColorColumn", "bg")
		-- 			end,
		-- 			fg = function(buffer)
		-- 				local hlgroups = require("cokeline.hlgroups")
		-- 				return buffer.is_focused and "#000000" or hlgroups.get_hl_attr("Normal", "fg")
		-- 			end,
		-- 		},
		-- 	},
		-- 	keys = function()
		-- 		local keys = {
		-- 			{ "<TAB>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
		-- 			{ "<S-TAB>", "<Plug>(cokeline-focus-prev)", desc = "Prev buffer" },
		-- 			{ "<Leader>B", "<Plug>(cokeline-pick-focus)", desc = "Buffer pick focus" },
		-- 			{ "<Leader>C", "<Plug>(cokeline-pick-close)", desc = "Buffer pick close" },
		-- 		}
		-- 		for i = 1, 9 do
		-- 			keys[#keys + 1] = {
		-- 				("<A-%s>"):format(i),
		-- 				("<Plug>(cokeline-focus-%s)"):format(i),
		-- 				desc = ("Buffer goto %s"):format(i),
		-- 			}
		-- 		end
		-- 		return keys
		-- 	end,
		-- },

		{
			"vzze/cmdline.nvim",
			config = function()
				require("cmdline")({
					window = { matchFuzzy = true, offset = 1, debounceMs = 0 },
					hl = { default = "Pmenu", selection = "PmenuSel", directory = "Directory", substr = "LineNr" },
					column = { maxNumber = 6, minWidth = 20 },
					binds = { next = "<Tab>", back = "<S-Tab>" },
				})
			end,
		},

		-- {
		-- 	"sindrets/diffview.nvim",
		-- 	opts = {},
		-- 	keys = {
		-- 		{ "<Leader>gd", "<CMD>DiffviewOpen<CR>", desc = "Open diffview" },
		-- 		{ "<Leader>gc", "<CMD>DiffviewClose<CR>", desc = "Close diffview" },
		-- 	},
		-- },

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "williamboman/mason.nvim", opts = {} },
				{ "williamboman/mason-lspconfig.nvim", opts = {} },
				-- { "j-hui/fidget.nvim", opts = {} },
			},
			lazy = false,
			cmd = "Mason",
			build = ":MasonUpdate",
			opts = {
				{ ui = { border = "single" } },
			},
			config = function(_, opts)
				local is_windows = vim.fn.has("win32") ~= 0
				local sep = is_windows and "\\" or "/"
				local delim = is_windows and ";" or ":"
				vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
				require("mason").setup(opts)
				local lspconfig = require("lspconfig")
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "clangd" },
					automatic_installation = true,
					handlers = {
						function(server_name) -- default handler (optional)
							require("lspconfig")[server_name].setup({})
						end,
						["lua_ls"] = function()
							lspconfig.lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
						end,
						["clangd"] = function()
							lspconfig.clangd.setup({ cmd = { "clangd", "--fallback-style=Microsoft" } })
						end,
					},
				})
			end,
			keys = {
				{ "<A-o>", "<CMD>ClangdSwitchSourceHeader<CR>", desc = "Switch between source/header", ft = { "cpp" } },
				{ "<A-p>", "<CMD>ClangdShowSymbolInfo<CR>", desc = "Show symbol info", ft = { "cpp" } },
			},
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = function()
				require("nvim-treesitter.configs").setup({
					-- ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc" },
					sync_install = true,
					auto_install = true,
					ignore_install = {},
					highlight = {
						enable = true,
						-- disable = function(lang, buf)
						--     local max_filesize = 100 * 1024 -- 100 KB
						--     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						--     if ok and stats and stats.size > max_filesize then
						--         return true
						--     end
						-- end,
						additional_vim_regex_highlighting = false,
					},
				})
			end,
		},

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
			opts = {
				defaults = {
					-- layout_strategy = 'vertical',
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					layout_config = {
						prompt_position = "top",
						horizontal = {
							width = 0.9,
							height = 0.8,
							preview_cutoff = 40,
							prompt_position = "top",
						},
					},
					sorting_strategy = "ascending",
					preview = true,
					mappings = {
						i = {
							["<Tab>"] = "move_selection_next",
							["<S-Tab>"] = "move_selection_previous",
							["<ESC>"] = "close",
						},
						n = {
							["<Tab>"] = "move_selection_next",
							["<S-Tab>"] = "move_selection_previous",
							["<ESC>"] = "close",
						},
					},
				},
			},
			keys = {
				{ "<Leader>f", "<CMD>Telescope find_files<CR>", desc = "Telescope find files" },
				{ "<Leader>h", "<CMD>Telescope oldfiles<CR>", desc = "Telescope find recent files" },
				{ "<Leader>/", "<CMD>Telescope grep_string<CR>", desc = "Telescope grep string" },
				{ "<Leader>b", "<CMD>Telescope buffers<CR>", desc = "Telescope buffers" },
				{ "<Leader>c", "<CMD>Telescope commands<CR>", desc = "Telescope commands" },
				{ "<Leader>T", "<CMD>Telescope colorscheme<CR>", desc = "Telescope colorscheme" },
				{ "<Leader>K", "<CMD>Telescope keymaps<CR>", desc = "Telescope keymap" },
				{ "<Leader>gb", "<CMD>Telescope git_branches<CR>", desc = "Telescope git branches" },
				{ "gd", "<CMD>Telescope lsp_definitions<CR>", desc = "Telescope go to definition" },
			},
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/nvim-cmp",
				"hrsh7th/vim-vsnip",
				"hrsh7th/cmp-vsnip",
				"rafamadriz/friendly-snippets",
				-- "hrsh7th/cmp-cmdline",
			},
			opts = function()
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
						["<A-j>"] = cmp.mapping.select_next_item(),
						["<A-k>"] = cmp.mapping.select_prev_item(),
						["<A-/>"] = cmp.mapping.complete({}),
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),
						["<C-e>"] = cmp.mapping.close(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
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

		{
			"stevearc/conform.nvim",
			opts = function()
				local conform = require("conform")
				conform.setup({
					format_on_save = {
						lsp_format = "fallback",
						timeout_ms = 500,
					},
					formatters_by_ft = {
						lua = { "stylua" },
						json = { "yq_json" },
						xml = { "yq_xml" },
						yml = { "yq" },
						["_"] = { "trim_whitespace" },
					},
					formatters = {
						yq_json = { command = "yq", args = { "-pjson", "-ojson", "-I4", "-P", "-" }, stdin = true },
						yq_xml = { command = "yq", args = { "-pxml", "-oxml", "-I4", "-P", "-" }, stdin = true },
					},
				})
				conform.formatters.injected = {
					-- Set the options field
					options = {
						-- Set individual option values
						ignore_errors = true,
						lang_to_formatters = {
							json = { "jq" },
						},
					},
				}
			end,
			keys = {
				{
					"<Leader>k",
					function()
						require("conform").format({ async = true, lsp_fallback = true })
					end,
					desc = "Format buffer",
				},
			},
		},
		{ "Civitasv/cmake-tools.nvim", opts = {} },
	},
})

vim.cmd.colorscheme("retrobox")
