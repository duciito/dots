return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
  keys = {
    { "<leader>pt", ":NvimTreeToggle<CR>", desc = "Open project file tree" },
  },
	config = function()
		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
			},
			sync_root_with_cwd = true,
			disable_netrw = true,
			sort = {
				sorter = "case_sensitive"
			},
			view = {
				side = "right",
				width = 28,
				preserve_window_proportions = true,
			},
			renderer = {
				root_folder_label = ":~:s?$",
				indent_markers = {
					enable = true,
				},
			},
		})
	end,
}
