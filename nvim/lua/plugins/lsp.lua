return {
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonUpdate', 'MasonLog' },
    opts = { ui = { border = 'rounded' } },
  },
  {
    'neovim/nvim-lspconfig',
    ft = {
      'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
      'html', 'css', 'scss', 'less', 'json', 'jsonc', 'sql', 'mysql',
    },
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      vim.lsp.config('ts_ls', {
        init_options = {
          preferences = {
            includeInlayParameterNameHints = 'literals',
            includeInlayVariableTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      })
      vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint', 'sqls' })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
      { '<Leader>f', function() require('conform').format({ lsp_format = 'fallback' }) end,
        mode = { 'n', 'x' }, desc = 'Format buffer or selection' },
    },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        java = { 'google-java-format' },
      },
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      server = { type = 'nodejs' },
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = true,
      },
    },
  },
}
