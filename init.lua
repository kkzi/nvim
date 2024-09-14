local path_package = vim.fn.stdpath("data")
local mini_path = path_package
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
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
	require("mini.notify").setup()
	vim.notify = require("mini.notify").make_notify()

	require("mini.basics").setup()
	require("mini.align").setup()
	require("mini.icons").setup()
	require("mini.statusline").setup()
	require("mini.pairs").setup()

	local indent = require("mini.indentscope")
	indent.setup({
		draw = {
			delay = 50,
			animation = indent.gen_animation.quadratic({ easing = "out", duration = 10, unit = "step" }),
		},
	})

	require("options")
	require("mappings")
	vim.cmd("colo randomhue")

	local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = augroup,
		pattern = { "init.lua", "options.lua", "mappings.lua" },
		command = "source $MYVIMRC",
	})
end)

later(function()
	require("mini.comment").setup()
	require("mini.pick").setup()

	require("mini.surround").setup({
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
	});
	(function()
		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				{ mode = "n", keys = "<Leader>" },
				{ mode = "n", keys = "<LocalLeader>" },
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
	end)();
	(function()
		adddep({
			source = "willothy/nvim-cokeline",
			depends = { "nvim-lua/plenary.nvim" },
			hooks = {
				post_checkout = function()
					echo("hello")
				end,
			},
		})
		require("cokeline").setup({
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
		})
		local coke = require("cokeline.mappings")
		addkey("n", "<TAB>", "<Plug>(cokeline-focus-next)", { desc = "Next buffer" })
		addkey("n", "<S-TAB>", "<Plug>(cokeline-focus-prev)", { desc = "Prev buffer" })
		addkey("n", "<Leader>b", "<Plug>(cokeline-pick-focus)", { desc = "Pick buffer" })
		addkey("n", "<Leader>c", "<Plug>(cokeline-pick-close)", { desc = "Close buffer" })
	end)();
	(function()
		adddep({ source = "marklcrns/vim-smartq" })
		addkey({ "i", "n" }, "<A-w>", "<Plug>(smartq_this)", { desc = "Next buffer" })
	end)();
	(function()
		adddep({ source = "gelguy/wilder.nvim" })
		require("wilder").setup({ modes = { ":", "?", "/" } })
	end)();
	(function()
		adddep({ source = "sindrets/diffview.nvim" })
		addkey("n", "<Leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "Open diffview" })
		addkey("n", "<Leader>gc", "<CMD>DiffviewClose<CR>", { desc = "Close diffview" })
	end)();
	(function()
		adddep({
			source = "nvim-neo-tree/neo-tree.nvim",
			depends = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
		})
		local tree = require("neo-tree.command")
		addkey("n", "<Leader>fe", function()
			tree.execute({ action = "show", toggle = true, position = "left", dir = "." })
		end, { desc = "Toggle explorer" })
		addkey("n", "<Leader>fH", function()
			tree.execute({ action = "show", toggle = false, position = "left", dir = "~" })
		end, { desc = "Explorer Home" })
		addkey("n", "<Leader>fE", function()
			vim.cmd("cd %:p:h")
			tree.execute({ action = "show", focus = true, position = "left" })
		end, { desc = "Reload neotree" })
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
		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end)()

	adddep({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				require("nvim-treesitter.install").update({ with_sync = true })()
			end,
		},
	});
	(function()
		adddep({
			source = "nvim-telescope/telescope.nvim",
			depends = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		})

		require("telescope").setup({
			defaults = {
				-- layout_strategy = 'vertical',
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
			},
		})
		local tb = require("telescope.builtin")
		addkey("n", "<Leader>ff", tb.find_files, { desc = "Telescope find files" })
		addkey("n", "<Leader>fo", tb.oldfiles, { desc = "Telescope find recent files" })
		addkey("n", "<Leader>fb", tb.buffers, { desc = "Telescope buffers" })
		addkey("n", "<Leader>fc", tb.commands, { desc = "Telescope commands" })
		addkey("n", "<Leader>ft", tb.colorscheme, { desc = "Telescope colorscheme" })
		addkey("n", "<Leader>fk", tb.keymaps, { desc = "Telescope keymap" })
	end)();
	(function()
		adddep({
			source = "hrsh7th/nvim-cmp",
			depends = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
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
	end)();
	(function()
		adddep({ source = "stevearc/conform.nvim" })
		local conform = require("conform")
		conform.setup({
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
		})

		addkey("n", "<Leader>fm", function()
			conform.format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end)()
end)
