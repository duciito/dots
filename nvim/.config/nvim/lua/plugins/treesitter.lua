return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require('nvim-treesitter')
    local parsers = {
      'bash',
      'comment',
      'css',
      'diff',
      'dockerfile',
      'elixir',
      'git_config',
      'gitcommit',
      'gitignore',
      'groovy',
      'go',
      'heex',
      'hcl',
      'html',
      'http',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'json5',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'rst',
      'rust',
      'scss',
      'ssh_config',
      'sql',
      'terraform',
      'typst',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    }
    local ignore_filetypes = {
      'checkhealth',
      'lazy',
      'mason',
    }

    -- Install parsers after lazy.nvim is done (non-blocking)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyDone',
      once = true,
      callback = function()
        ts.install(parsers, { max_jobs = 8 })
      end,
    })

    -- Folding setup
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.cmd('set nofoldenable')

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(event)
        if vim.tbl_contains(ignore_filetypes, event.match) then
          return
        end
        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local ok = pcall(vim.treesitter.start, event.buf, lang)
        if ok then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
