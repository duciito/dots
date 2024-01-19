---@param entry cmp.Entry
---@return string|nil
local function get_python_import(entry)
	local cmp_item = entry:get_completion_item()       --- @type lsp.CompletionItem
	if cmp_item.detail == "Auto-import" then
		return (cmp_item.labelDetails or {}).description or '' -- pyright-specific (undocumented)
	end
	return nil                                         -- no information, possibly not auto-import symbol
end

---@type fun(lhs: cmp.Entry, rhs: cmp.Entry): boolean|nil
local function prioritize_builtin(lhs, rhs)
	local l = get_python_import(lhs)
	local r = get_python_import(rhs)
	if l and r then return #l < #r end -- actually, sort by the length of the defining module
end

return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		"hrsh7th/cmp-buffer",
		"FelipeLema/cmp-async-path",
		'saadparwaiz1/cmp_luasnip'
	},
	event = "InsertEnter",
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		cmp.setup({
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
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					-- compare.scopes,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					-- compare.sort_text,
					prioritize_builtin,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		})
	end
}
