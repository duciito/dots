return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local servers = {
      'html',
      'cssls',
      'svelte',
      'basedpyright',
      'ruff',
      'ts_ls',
      'lua_ls',
      'dockerls',
      'yamlls',
      'gopls',
    }
    -- Ensure the servers above are installed
    require('mason-lspconfig').setup({
      ensure_installed = servers,
    })
  end,
}
