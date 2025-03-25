return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  config = function()
    require('kanagawa').setup({
      colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
      undercurl = false,
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- TelescopeTitle = { fg = theme.ui.special, bold = true },
          -- TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          -- TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          -- TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          -- TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          -- TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          FzfLuaTitle = { fg = theme.ui.special, bg = theme.ui.bg_p1, bold = true },
          FzfLuaNormal = { bg = theme.ui.bg_p1 },
          FzfLuaBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          FzfLuaPreviewNormal = { bg = theme.ui.bg_dim },
          FzfLuaPreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          FzfLuaPreviewTitle = { fg = theme.ui.special, bg = theme.ui.bg_dim, bold = true },

          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none", fg = theme.syn.type },
          FloatTitle = { bg = "none" },

          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          BlinkCmpMenu = { bg = "none", fg = theme.ui.fg_dim },
          BlinkCmpMenuBorder = { bg = "none", fg = theme.syn.type },
          PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
        }
      end,
    })
    vim.cmd("colorscheme kanagawa")
  end
}
