return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '*',
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    cmdline = {
      enabled = false
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    completion = {
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { "label",     "label_description" },
            { "kind_icon", "kind",             gap = 1 }
          },
        },
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
        end,
      },
      documentation = {
        window = { border = 'rounded' },
        auto_show = true,
        auto_show_delay_ms = 100,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },
  },
  opts_extend = { "sources.default" }
}
