vim.g.python3_host_prog = '/usr/bin/python'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Security
vim.opt.clipboard = "unnamedplus"

-- New buffer splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.visualbell = true

vim.opt.cursorline = true
vim.opt.showmode = false

-- Decrease update time
vim.opt.timeoutlen = 500
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menu,menuone,noselect'

-- Cursor motion
vim.opt.scrolloff = 4
vim.opt.mouse = "a"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Set colorscheme
vim.opt.termguicolors = true

-- Disable builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.smartindent = true
vim.opt.undofile = true
