-- return {
--   'rebelot/kanagawa.nvim',
--   lazy = false,
--   config = function()
--     require('kanagawa').setup({
--       undercurl = false,
--       overrides = function(colors)
--         local theme = colors.theme
--         return {
--           FzfLuaTitle = { fg = theme.ui.special, bg = theme.ui.bg_p1, bold = true },
--           FzfLuaNormal = { bg = theme.ui.bg_p1 },
--           FzfLuaBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
--           FzfLuaPreviewNormal = { bg = theme.ui.bg_dim },
--           FzfLuaPreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
--           FzfLuaPreviewTitle = { fg = theme.ui.special, bg = theme.ui.bg_dim, bold = true },
--
--           NormalFloat = { bg = "none" },
--           FloatBorder = { bg = "none", fg = theme.syn.type },
--           FloatTitle = { bg = "none" },
--
--           NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
--           LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
--           MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
--
--           BlinkCmpMenu = { bg = "none", fg = theme.ui.fg_dim },
--           BlinkCmpMenuBorder = { bg = "none", fg = theme.syn.type },
--           PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
--         }
--       end,
--     })
--     vim.cmd("colorscheme kanagawa-dragon")
--   end
-- }
return {
  'ribru17/bamboo.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('bamboo').setup {
      highlights = {
        -- FzfLua (warm coral/green accent combo)
        FzfLuaTitle = { fg = '$bg0', bg = '$coral', fmt = 'bold' },
        FzfLuaNormal = { bg = '$bg1' },
        FzfLuaBorder = { fg = '$bg1', bg = '$bg1' },
        FzfLuaPreviewNormal = { bg = '$bg_d' },
        FzfLuaPreviewBorder = { fg = '$bg_d', bg = '$bg_d' },
        FzfLuaPreviewTitle = { fg = '$bg0', bg = '$green', fmt = 'bold' },

        -- Floats (transparent with warm orange border)
        NormalFloat = { bg = 'none' },
        FloatBorder = { bg = 'none', fg = '$orange' },
        FloatTitle = { bg = 'none', fg = '$orange', fmt = 'bold' },

        -- Lazy/Mason (deep contrast bg, full brightness text)
        NormalDark = { fg = '$fg', bg = '$contrast' },
        LazyNormal = { fg = '$fg', bg = '$contrast' },
        MasonNormal = { fg = '$fg', bg = '$contrast' },

        -- Completion menu (clean with orange border)
        BlinkCmpMenu = { bg = 'none', fg = '$fg' },
        BlinkCmpMenuBorder = { bg = 'none', fg = '$orange' },
        PmenuSel = { fg = 'none', bg = '$bg3' },
      },
    }
    require('bamboo').load()
  end,
}
