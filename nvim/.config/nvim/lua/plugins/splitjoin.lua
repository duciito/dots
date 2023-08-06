return {
	'Wansmer/treesj',
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	keys = { { "<space>m", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
	opts = { use_default_keymaps = false, max_join_length = 150 },
}
