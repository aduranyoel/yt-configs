-- lua/plugins/lsp.lua

local shared = require('config.lsp-shared')

return {
  -- Mason: installs LSP server binaries
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({ ui = { border = 'rounded' } })
    end,
  },

  -- Bridge: mason + nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',    -- TypeScript / JavaScript
          'html',
          'cssls',
          'jsonls',
          'eslint',
          'jdtls',   -- Java (binary only; server started by nvim-jdtls)
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: configure each server (Neovim 0.11+ API)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      vim.lsp.config('*', {
        on_attach    = shared.on_attach,
        capabilities = shared.capabilities(),
      })

      vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint' })

      vim.diagnostic.config({
        virtual_text   = true,
        signs          = true,
        underline      = true,
        update_in_insert = false,
        severity_sort  = true,
        float = { border = 'rounded', source = 'always' },
      })
    end,
  },

  -- Completion engine
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp     = require('cmp')
      local luasnip = require('luasnip')

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<CR>']    = cmp.mapping.confirm({ select = true }),
          ['<M-Space>'] = cmp.mapping.complete(),
          ['<C-b>']   = cmp.mapping.scroll_docs(-4),
          ['<C-f>']   = cmp.mapping.scroll_docs(4),
          ['<C-e>']   = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- Formatter (replaces coc-prettier)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          javascript      = { 'prettier' },
          typescript      = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          html            = { 'prettier' },
          css             = { 'prettier' },
          json            = { 'prettier' },
          java            = { 'google-java-format' },
        },
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
