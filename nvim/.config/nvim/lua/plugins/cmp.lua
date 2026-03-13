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
        auto_show = true,
      },
      documentation = {
        window = { border = 'rounded' },
        auto_show = true,
        auto_show_delay_ms = 100,
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      providers = {
        cmdline = {
          -- ignores cmdline completions when executing shell commands
          enabled = function()
            return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
          end
        }
      }
    },
  },
  opts_extend = { "sources.default" }
}
