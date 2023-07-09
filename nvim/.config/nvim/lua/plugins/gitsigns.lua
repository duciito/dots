return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Actions
				-- map('n', '<leader>hs', gs.stage_hunk)
				-- map('n', '<leader>hr', gs.reset_hunk)
				-- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				-- map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				-- map('n', '<leader>hS', gs.stage_buffer)
				-- map('n', '<leader>hu', gs.undo_stage_hunk)
				-- map('n', '<leader>hR', gs.reset_buffer)
				-- map('n', '<leader>hp', gs.preview_hunk)
				map('n', '<leader>gb', function() gs.blame_line{full=true} end)
				map('n', '<leader>gB', gs.toggle_current_line_blame)
				map('n', '<leader>gd', gs.diffthis)
				map('n', '<leader>gD', function() gs.diffthis('~') end)
				-- map('n', '<leader>td', gs.toggle_deleted)
			end,
		})
	end,
}
