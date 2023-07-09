return {
	"HampusHauffman/block.nvim",
	event = "VeryLazy",
	config = function()
		require("block").setup()
		vim.keymap.set("n", "<leader>tb", "<cmd>Block<CR>")
	end
}
