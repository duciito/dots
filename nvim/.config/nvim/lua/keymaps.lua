vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear search
vim.keymap.set('n', '<leader><space>', ':noh<CR>', { silent = true })

-- Scroll autocompletion popups with ctrl-j and k
vim.api.nvim_set_keymap('i', '<c-j>', 'pumvisible() ? "\\<c-n>" : "\\<c-j>"' , { noremap = true, expr=true })
vim.api.nvim_set_keymap('i', '<c-k>', 'pumvisible() ? "\\<c-p>" : "\\<c-k>"' , { noremap = true, expr=true })

