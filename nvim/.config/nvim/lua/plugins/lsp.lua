return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local signs = { Error = "❌", Warn = "⚠️", Hint = "💡", Info = "" }
    local handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = 'rounded' }),
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      float = {
        border = 'rounded',
        source = true,
      },
      severity_sort = true,
    })

    -- Diagnostic keymaps
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      -- if client.server_capabilities.inlayHintProvider then
      --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      -- end

      nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('<leader>ci', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, 'Inlay Hints')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('gy', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>cl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')
      -- nmap('<leader>cf', function() vim.lsp.buf.format { async = true } end, 'Format buffer')
    end

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- Enable the following language servers
    local servers = { 'html', 'cssls', 'svelte', 'basedpyright', 'ruff', 'ts_ls', 'lua_ls', 'dockerls', 'yamlls',
      'gopls' }

    -- Ensure the servers above are installed
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      handlers = {
        function(server)
          require('lspconfig')[server].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
          })
        end,
        ["ruff"] = function()
          require("lspconfig").ruff.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              client.server_capabilities.hoverProvider = false
              on_attach(client, bufnr)
            end,
            handlers = handlers,
          })
        end,
        ["basedpyright"] = function()
          require("lspconfig").basedpyright.setup({
            on_attach = on_attach,
            handlers = handlers,
            capabilities = capabilities,
            settings = {
              basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                  typeCheckingMode = "standard",
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "openFilesOnly",
                  autoImportCompletions = true,
                  autoSearchPaths = true,
                },
              },
            },
          })
        end
      }
    })
  end,
}
