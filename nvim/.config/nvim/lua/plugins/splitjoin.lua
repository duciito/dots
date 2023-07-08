return {
	'Wansmer/treesj',
	keys = { '<space>m', 'gJ', 'gS' },
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		require('treesj').setup()
	end,
}
