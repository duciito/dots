local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require("lazy").setup({
	spec = {
		require("plugins.autopairs"),
		require("plugins.cmp"),
		require("plugins.devicons"),
		require("plugins.diffview"),
		require("plugins.theme"),
		require("plugins.flash"),
		require("plugins.lsp"),
		require("plugins.gitsigns"),
		require("plugins.mason"),
		require("plugins.nvim-tree"),
		require("plugins.splitjoin"),
		require("plugins.surround"),
    require("plugins.fzf"),
		require("plugins.treesitter"),
		require("plugins.conform"),
		require("plugins.copilot"),
		require("plugins.lazydev"),
	},
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
