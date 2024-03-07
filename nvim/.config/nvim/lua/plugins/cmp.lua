return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		"hrsh7th/cmp-buffer",
		"FelipeLema/cmp-async-path",
		'saadparwaiz1/cmp_luasnip',
		"onsails/lspkind.nvim"
	},
	event = "InsertEnter",
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require('lspkind')

		cmp.setup({
			formatting = {
				format = lspkind.cmp_format({
					mode = 'symbol_text',
					maxwidth = 60,
					ellipsis_char = '...',
					show_labelDetails = true,
				})
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert {
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<C-j>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<C-k>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = "async_path" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "luasnip" },
			},
			-- sorting = {
			-- 	comparators = {
			-- 		cmp.config.compare.offset,
			-- 		cmp.config.compare.exact,
			-- 		-- compare.scopes,
			-- 		cmp.config.compare.score,
			-- 		cmp.config.compare.recently_used,
			-- 		cmp.config.compare.locality,
			-- 		cmp.config.compare.kind,
			-- 		-- compare.sort_text,
			-- 		prioritize_builtin,
			-- 		cmp.config.compare.length,
			-- 		cmp.config.compare.order,
			-- 	},
			-- },
		})
	end
}
