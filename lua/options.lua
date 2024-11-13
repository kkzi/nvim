vim.g.mapleader = ' '
vim.g.localmapleader = '\\'

local o = vim.o
o.guifont = "Sarasa Fixed Slab SC Nerd Font:h12"
o.autochdir = false
o.cursorline = true
o.ignorecase = true
o.number = true
o.relativenumber = true
o.wrap = true
o.list = false
o.listchars = 'tab:→ ,trail:·,extends:↷,precedes:↶,space:·' --,eol:↵'
o.cursorlineopt = "both"
o.shortmess = "I"
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true
o.so = 4



vim.g.neovide_position_animation_length = 0.00
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0.00
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
