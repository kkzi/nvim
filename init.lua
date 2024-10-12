require("options")
require("mappings")
-- require("autocmds")

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(path_package) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--depth=1",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local minidep = require("mini.deps")
minidep.setup({ path = { package = path_package } })
local adddep, now, later = minidep.add, minidep.now, minidep.later
local addkey = vim.keymap.set
-- local delkey = vim.keymap.del

now(function()
	vim.cmd("colo randomhue")

	require("mini.notify").setup()
	vim.notify = require("mini.notify").make_notify()

	require("mini.basics").setup()
	require("mini.align").setup()
	require("mini.statusline").setup()
	require("mini.pairs").setup({
		modes = { insert = true, command = true, terminal = false },
		mappings = {},
	})

	local indent = require("mini.indentscope")
	indent.setup({
		draw = {
			delay = 50,
			animation = indent.gen_animation.quadratic({ easing = "out", duration = 10, unit = "step" }),
		},
	})

	adddep({ source = "nvim-tree/nvim-web-devicons" })
end)

later(function()
	-- (function()
	-- 	require("mini.pick").setup()
	-- 	addkey("n", "<Leader>fp", "<CMD>Pick files<CR>", { desc = "Pick files" })
	-- end)()

	require("mini.surround").setup({
		mappings = {
			add = "\\s", -- Add surrounding in Normal and Visual modes
			delete = "\\d", -- Delete surrounding
			find = "\\f", -- Find surrounding (to the right)
			find_left = "\\F", -- Find surrounding (to the left)
			highlight = "\\h", -- Highlight surrounding
			replace = "\\c", -- Replace surrounding
			update_n_lines = "\\n", -- Update `n_lines`
			suflix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},
	});
	(function()
		local miniclue = require("mini.clue")
		miniclue.setup({
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
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
			window = { delay = 100, config = { width = 48, border = "single" } },
		})
	end)();
	(function()
		adddep({ source = "akinsho/toggleterm.nvim" })
		require("toggleterm").setup({ direction = "float" })
		addkey({ "n", "i", "v", "t" }, "<A-`>", "<CMD>ToggleTerm<CR>", { desc = "Toggle terminal" })
		addkey({ "t" }, "<ESC>", "<CMD>ToggleTerm<CR>", { desc = "Hide terminal" })
	end)();
	(function()
		adddep({ source = "nvim-tree/nvim-web-devicons" })
		require("nvim-web-devicons").setup({ color_icons = false })
	end)();
	(function()
		adddep({
			source = "willothy/nvim-cokeline",
			depends = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		})
		require("cokeline").setup({
			sidebar = {
				components = { { text = " Explorer" } },
			},
			default_hl = {
				bg = function(buffer)
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#71DEC1" or hlgroups.get_hl_attr("ColorColumn", "bg")
				end,
				fg = function(buffer)
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#000000" or hlgroups.get_hl_attr("Normal", "fg")
				end,
			},
		})
		-- local coke = require("cokeline.mappings")
		addkey("n", "<TAB>", "<Plug>(cokeline-focus-next)", { desc = "Next buffer" })
		addkey("n", "<S-TAB>", "<Plug>(cokeline-focus-prev)", { desc = "Prev buffer" })
		addkey("n", "<Leader>B", "<Plug>(cokeline-pick-focus)", { desc = "Buffer pick focus" })
		addkey("n", "<Leader>C", "<Plug>(cokeline-pick-close)", { desc = "Buffer pick close" })
		for i = 1, 9 do
			addkey(
				"n",
				("<A-%s>"):format(i),
				("<Plug>(cokeline-focus-%s)"):format(i),
				{ desc = ("Buffer goto %s"):format(i) }
			)
		end
	end)();
	(function()
		adddep({ source = "vzze/cmdline.nvim" })
		require("cmdline")({
			window = { matchFuzzy = true, offset = 1, debounceMs = 10 },
			hl = { default = "Pmenu", selection = "PmenuSel", directory = "Directory", substr = "LineNr" },
			column = { maxNumber = 6, minWidth = 20 },
			binds = { next = "<Tab>", back = "<S-Tab>" },
		})
	end)();
	(function()
		adddep({ source = "sindrets/diffview.nvim" })
		addkey("n", "<Leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "Open diffview" })
		addkey("n", "<Leader>gc", "<CMD>DiffviewClose<CR>", { desc = "Close diffview" })
	end)();
	(function()
		adddep({
			source = "nvim-neo-tree/neo-tree.nvim",
			depends = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
		})
		require("neo-tree").setup({
			window = { position = "float" },
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			buffers = { follow_current_file = { enable = true } },
		})
		-- local tree = require("neo-tree.command")
		addkey("n", "<Leader>fH", "<CMD>Neotree action=focus dir=~<CR>", { desc = "Explorer Home" })
		addkey(
			"n",
			"<Leader>fe",
			"<CMD>Neotree action=focus reveal reveal_force_cwd<CR>",
			{ desc = "Explorer focus reveal " }
		)
	end)();
	(function()
		adddep({
			source = "williamboman/mason.nvim",
			depends = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
		})
		local is_windows = vim.fn.has("win32") ~= 0
		local sep = is_windows and "\\" or "/"
		local delim = is_windows and ";" or ":"
		vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
		require("mason").setup({ ui = { border = "single" } })
		local lspconfig = require("lspconfig")
		local handlers = {
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({})
			end,
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
			end,
			["clangd"] = function()
				lspconfig.clangd.setup({ cmd = { "clangd", "--fallback-style=Microsoft" } })
			end,
		}
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "clangd" },
			automatic_installation = true,
			handlers = handlers,
		})
		addkey("n", "<A-o>", "<CMD>ClangdSwitchSourceHeader<CR>", { desc = "Switch between source/header" })
		addkey("n", "<A-p>", "<CMD>ClangdShowSymbolInfo<CR>", { desc = "Show symbol info" })
	end)();
	-- ; (function()
	-- 	adddep({ source = "p00f/clangd_extensions.nvim" })
	-- 	require("clangd_extensions").setup({})
	-- end)()

	(function()
		adddep({
			source = "nvim-treesitter/nvim-treesitter",
			hooks = {
				post_checkout = function()
					require("nvim-treesitter.install").update({ with_sync = true })()
				end,
			},
		})
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc" },
			sync_install = false,
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
	end)();
	(function()
		adddep({
			source = "nvim-telescope/telescope.nvim",
			depends = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		})

		require("telescope").setup({
			defaults = {
				-- layout_strategy = 'vertical',
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				layout_config = {
					prompt_position = "top",
					horizontal = {
						height = 0.8,
						preview_cutoff = 40,
						prompt_position = "top",
						width = 0.5,
					},
				},
				sorting_strategy = "ascending",
				preview = false,
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
		})
		addkey("n", "<Leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Telescope find files" })
		addkey("n", "<Leader>fo", "<CMD>Telescope oldfiles<CR>", { desc = "Telescope find recent files" })
		addkey("n", "<Leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Telescope buffers" })
		addkey("n", "<Leader>fc", "<CMD>Telescope commands<CR>", { desc = "Telescope commands" })
		addkey("n", "<Leader>ft", "<CMD>Telescope colorscheme<CR>", { desc = "Telescope colorscheme" })
		addkey("n", "<Leader>fk", "<CMD>Telescope keymaps<CR>", { desc = "Telescope keymap" })
		addkey("n", "<Leader>gb", "<CMD>Telescope git_branches<CR>", { desc = "Telescope git branches" })
		addkey("n", "gd", "<CMD>Telescope lsp_definitions<CR>", { desc = "Telescope go to definition" })
	end)();
	(function()
		adddep({
			source = "hrsh7th/nvim-cmp",
			depends = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				-- "hrsh7th/cmp-cmdline",
				"hrsh7th/nvim-cmp",
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip",
				"rafamadriz/friendly-snippets",
			},
		})

		local feedkey = function(key, mode)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		end
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
						-- elseif has_words_before() then
						-- 	cmp.complete()
					else
						fallback()
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
	end)();
	(function()
		adddep({ source = "stevearc/conform.nvim" })
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
		addkey("n", "<Leader>fm", function()
			conform.format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end)()
end)
