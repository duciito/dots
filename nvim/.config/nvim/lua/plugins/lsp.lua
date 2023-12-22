return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason-lspconfig.nvim'
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function ()
		-- Diagnostic keymaps
		vim.diagnostic.config({virtual_text = false})
		vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
		vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
		vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
		vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

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

		-- nvim-cmp supports additional completion capabilities
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		-- Enable the following language servers
		local servers = { 'pyright', 'tsserver', 'lua_ls', 'dockerls', 'yamlls' }

		-- Ensure the servers above are installed
		require('mason-lspconfig').setup({
			ensure_installed = servers,
		})

		for _, lsp in ipairs(servers) do
			require('lspconfig')[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

	end,
}
