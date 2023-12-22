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

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, { expr = true })

				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true })

				-- Actions
				map('n', '<leader>gb', function() gs.blame_line { full = true } end)
				map('n', '<leader>gB', gs.toggle_current_line_blame)
				map('n', '<leader>gd', gs.diffthis)
				map('n', '<leader>gD', function() gs.diffthis('~') end)
				map('n', '<leader>gr', gs.reset_hunk)
				map('n', '<leader>gs', gs.stage_hunk)
				map('n', '<leader>gS', gs.undo_stage_hunk)
				map('n', '<leader>gp', gs.preview_hunk)
			end,
		})
	end,
}
