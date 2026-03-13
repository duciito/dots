return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end)
        map('n', '<leader>gB', gitsigns.toggle_current_line_blame)
        map('n', '<leader>gd', gitsigns.diffthis)
        map('n', '<leader>gD', function() gitsigns.diffthis('~') end)
        map('n', '<leader>gr', gitsigns.reset_hunk)
        map('n', '<leader>gs', gitsigns.stage_hunk)
        map('n', '<leader>gS', gitsigns.undo_stage_hunk)
        map('n', '<leader>gp', gitsigns.preview_hunk_inline)
        map('n', '<leader>gQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>gq', gitsigns.setqflist)
      end,
    })
  end,
}
