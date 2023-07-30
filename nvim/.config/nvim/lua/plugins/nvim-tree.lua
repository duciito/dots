return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
			},
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			disable_netrw = true,
			hijack_cursor = true,
			sort_by = "case_sensitive",
			view = {
				width = 26,
				preserve_window_proportions = true,
			},
			renderer = {
				root_folder_label = ":~:s?$",
			},
		})

		vim.keymap.set("n", "<leader>pt", "<cmd>NvimTreeToggle<CR>", { desc = "Open project file tree", noremap=true })
	end,
}
