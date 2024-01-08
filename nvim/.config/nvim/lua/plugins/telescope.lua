return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	event = "VeryLazy",
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local builtin = require('telescope.builtin')

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						['<ESC>'] = actions.close,
						['<C-j>'] = actions.move_selection_next,
						['<C-k>'] = actions.move_selection_previous
					},
				},
				file_ignore_patterns = {
					".git/.*",
				}
			},
			pickers = {
				find_files = {
					hidden = true
				},
				buffers = {
					sort_mru = true,
					ignore_current_buffer = true,
				}
			},
		})

		vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end,
			{ desc = '[S]earch [F]iles in current folder' })
		vim.keymap.set('n', '<leader>fh', builtin.oldfiles, { desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[ ] Find existing buffers' })
		vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, { desc = 'Git commits' })
		vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'Commands' })
		vim.keymap.set('n', '<leader>st', builtin.tags, { desc = 'Tags' })
		vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
		vim.keymap.set('n', 'gr', builtin.lsp_references)
		vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
		vim.keymap.set('n', '<leader>cd', builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })

		telescope.load_extension('fzf')
	end
}
