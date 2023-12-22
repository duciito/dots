return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets"
	},
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	config = function()
		local luasnip = require("luasnip")
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})
		-- add vscode exported snippets
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
