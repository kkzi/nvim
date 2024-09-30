vim.g.mapleader = ' '
vim.g.localmapleader = '\\'

local o = vim.o
o.guifont = "IosevkaTerm NFM:h12"
o.autochdir = false
o.cursorline = true
o.ignorecase = true
o.number = true
o.relativenumber = true
o.wrap = true
o.list = true
o.listchars = 'tab:→ ,trail:·,extends:↷,precedes:↶,space:·' --,eol:↵'
o.cursorlineopt = "both"
o.shortmess = "I"
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true
