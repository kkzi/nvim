return {
	{
		"projekt0n/github-nvim-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				-- ...
			})
			vim.cmd("colorscheme github_dark")
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
			local tree = require("neo-tree.command");
			return {
				{ "<leader>fe", function() tree.execute({ action = "show", toggle = true,  position = "left", dir = ".", }) end, desc = "Toggle explorer", },
				{ "<leader>fH", function() tree.execute({ action = "show", toggle = false, position = "left", dir = "~", }) end, desc = "Explorer Home", },
				{ "<leader>fE", function() vim.cmd("cd %:p:h") end, desc = "Reload neotree", },
			}
		end,
	},
	{
		"willothy/nvim-cokeline",
		dependencies = {
			"nvim-lua/plenary.nvim",        -- Required for v0.4.0+
			"nvim-tree/nvim-web-devicons", -- If you want devicons
			--"stevearc/resession.nvim"       -- Optional, for persistent history
		},
		config = true,
		opts = {
			sidebar = {
				filetype = { "neo-tree" },
				components = { {text=" Explorer"} },
			},
			default_hl = {
				bg = function (buffer) 
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#CCCC00" or hlgroups.get_hl_attr("ColorColumn", "bg")
				end,
				fg = function (buffer) 
					local hlgroups = require("cokeline.hlgroups")
					return buffer.is_focused and "#000000" or hlgroups.get_hl_attr("Normal", "fg")
				end,
			},
		},
		keys = function()
        	local coke = require('cokeline.mappings'); --pick("focus")
			return {
				{ "<TAB>",   	"<Plug>(cokeline-focus-next)", desc = "Next buffer", },
				{ "<S-TAB>", 	"<Plug>(cokeline-focus-prev)", desc = "Prev buffer", },
				{ "<leader>bb", "<Plug>(cokeline-pick-focus)", desc = "Pick buffer", },
			}
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = false,
				-- section_separators = { left = ' ', right = ' ' },
				component_separators = { left = ' ', right = ' ' }
			}, 
			sections = {
				lualine_a = {'mode'},
				lualine_b = {'branch', 'diff', 'diagnostics'},
				lualine_c = {
					{
						'filename',
						file_status = true,      -- Displays file status (readonly status, modified status)
						newfile_status = false,  -- Display new file status (new file means no write after created)
						path = 1,                -- 0: Just the filename 1: Relative path 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory

						shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = '[+]',      -- Text to show when the file is modified.
							readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
							unnamed = '[No Name]', -- Text to show for unnamed buffers.
							newfile = '[New]',     -- Text to show for newly created file before first write
						}
					}
				},
				lualine_x = {'encoding', 'fileformat', 'filetype'},
				lualine_y = {'progress'},
				lualine_z = {'location'}
			},
			extensions = {"neo-tree", "mason"}
		},
	},

	{ "folke/which-key.nvim", lazy = true, opts={} },
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		opts = {},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		-- config = function()
		-- 	require("nvim-surround").setup({
		-- 		-- Configuration here, or leave empty to use defaults
		-- 	})
		-- end,
		opts = {},
	},

	{ "echasnovski/mini.align", version = '*', opts={} },

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},


	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
		    local tb = require("telescope.builtin");
		    -- local tt = require("telescope.themes").get_dropdown({});
		    local tt = {};
			return {
				{ "<leader>ff", function() tb.find_files(tt)  end, desc = "Telescope find files", },
				{ "<leader>fo", function() tb.oldfiles(tt)    end, desc = "Telescope find recent files", },
				{ "<leader>fb", function() tb.buffers(tt)     end, desc = "Telescope buffers", },
				{ "<leader>fc", function() tb.commands(tt)    end, desc = "Telescope commands", },
				{ "<leader>ft", function() tb.colorscheme(tt) end, desc = "Telescope colorscheme", },
			}
		end,
	},
}
