return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim"
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- formatting
				null_ls.builtins.formatting.ruff,
				null_ls.builtins.formatting.black,

				-- diagnostics
				null_ls.builtins.diagnostics.ruff,

				-- code actions
				null_ls.builtins.code_actions.refactoring,

			},
		})
	end,
}
