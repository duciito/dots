vim.g.python3_host_prog = '/usr/bin/python'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Security
vim.opt.modelines = 0
vim.opt.clipboard = "unnamedplus"

-- New buffer splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.visualbell = true

vim.opt.showmode = false

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Cursor motion
vim.opt.scrolloff = 3

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Set colorscheme
vim.o.termguicolors = true

-- Disable builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
