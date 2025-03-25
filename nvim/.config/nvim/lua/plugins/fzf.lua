return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  keys = {
    { "<leader>pf", function() require("fzf-lua").files() end,                                 desc = "Search Files" },
    { "<leader>ff", function() require("fzf-lua").files({ cwd = vim.fn.expand('%:p:h') }) end, desc = "Search Files in current directory" },
    { "<leader>fh", function() require("fzf-lua").oldfiles() end,                              desc = "Search old files" },
    { "<leader>b",  function() require("fzf-lua").buffers() end,                               desc = "Search buffers" },
    { "<leader>gc", function() require("fzf-lua").git_bcommits() end,                          desc = "Git commits for buffer" },
    { "<leader>sh", function() require("fzf-lua").helptags() end,                              desc = "Search help" },
    { "<leader>sw", function() require("fzf-lua").grep_cword() end,                            desc = "Search current word" },
    { "<leader>/",  function() require("fzf-lua").live_grep() end,                             desc = "Search in project" },
    { "<leader>sc", function() require("fzf-lua").commands() end,                              desc = "Search commands" },
    { "<leader>st", function() require("fzf-lua").tags() end,                                  desc = "Search tags" },
    { "<leader>sk", function() require("fzf-lua").keymaps() end,                               desc = "Search keymaps" },
    { "gr",         function() require("fzf-lua").lsp_references() end,                        desc = "Search LSP referneces" },
    { "<leader>cs", function() require("fzf-lua").lsp_document_symbols() end,                  desc = "Search LSP document symbols" },
  },
  opts = {
    previewers = {
      builtin = {
        syntax_limit_b = 1024 * 100, -- 100KB
      },
    },
  },
  config = function()
    local fzf = require('fzf-lua')

    fzf.setup({
      'default-title',
      fzf_opts   = { ["--layout"] = "default", ["--marker"] = "+" },
      winopts    = {
        preview = {
          hidden       = false,
          vertical     = "up:45%",
          horizontal   = "right:55%",
          layout       = "flex",
          flip_columns = 120,
          delay        = 10,
          winopts      = { number = false },
        }
      },
      fzf_colors = {
        ["fg+"] = { "fg", "PmenuSel", "regular" },
        ["bg+"] = { "bg", "PmenuSel" },
        ["gutter"] = "-1",
      },
      keymap     = {
        builtin = {
          true,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          true,
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-q"] = "select-all+accept",
        },
      },
      actions    = {
        files = {
          ["enter"]  = fzf.actions.file_edit_or_qf,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
          ["ctrl-t"] = fzf.actions.file_tabedit,
          ["alt-q"]  = fzf.actions.file_sel_to_qf,
        },
      },
      buffers    = {
        keymap = { builtin = { ["<C-d>"] = false } },
        actions = { ["ctrl-x"] = false, ["ctrl-d"] = { fzf.actions.buf_del, fzf.actions.resume } },
      },
    })
  end,
}
