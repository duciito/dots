return {
	'nvim-lualine/lualine.nvim',
	event = "VeryLazy",
	init = function()
		-- disable until lualine loads
		vim.opt.laststatus = 0
	end,
	opts = {}
}
