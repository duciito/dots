return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason-lspconfig.nvim'
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
		local servers = { 'pyright', 'tsserver', 'lua_ls', 'dockerls', 'yamlls', 'gopls' }

		-- Ensure the servers above are installed
		require('mason-lspconfig').setup({
			ensure_installed = servers,
		})

		table.remove(servers, 0)
		local lspconfig = require('lspconfig')
		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup({
				handlers = handlers,
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- Python LSP setup --
		local util = require("lspconfig/util")
		local path = util.path
		local function get_python_path(workspace)
			-- Use activated virtualenv.
			if vim.env.VIRTUAL_ENV then
				return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
			end

			-- Find and use virtualenv in workspace directory.
			for _, pattern in ipairs({ "*", ".*" }) do
				local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
				if match ~= "" then
					return path.join(path.dirname(match), "bin", "python")
				end
			end

			-- Fallback to system Python.
			return exepath("python3") or exepath("python") or "python"
		end

		lspconfig.pyright.setup({
			handlers = handlers,
			before_init = function(_, config)
				config.settings.python.pythonPath = get_python_path(config.root_dir)
			end,
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
