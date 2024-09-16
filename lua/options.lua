vim.g.mapleader = ' '
vim.g.localmapleader = '\\'

local o = vim.o
o.guifont = "Sarasa Fixed SC Nerd Font:h12"
o.autochdir = true
o.cursorline = true
o.ignorecase = true
o.number = true
o.relativenumber = true
o.wrap = true
o.list = true
o.listchars = 'tab:→ ,trail:·,extends:↷,precedes:↶,space:·' --,eol:↵'
o.cursorlineopt = "both"
o.shortmess = "I"
o.tabstop = 4
o.shiftwidth = 4
