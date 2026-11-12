-- lua/config/lsp-shared.lua
-- Shared LSP on_attach and capabilities used by lsp.lua and java.lua

local M = {}

M.on_attach = function(_, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Navigation
  map('gd', vim.lsp.buf.definition,      'Go to definition')
  map('gy', vim.lsp.buf.type_definition, 'Go to type definition')
  map('gi', vim.lsp.buf.implementation,  'Go to implementation')
  map('gr', vim.lsp.buf.references,      'Find references')
  map('K',  vim.lsp.buf.hover,           'Hover documentation')

  -- Refactoring
  map('<Leader>rn', vim.lsp.buf.rename,      'Rename symbol')
  map('<Leader>a',  vim.lsp.buf.code_action, 'Code action')
  map('<Leader>f',  function()
    vim.lsp.buf.format({ async = true })
  end, 'Format buffer')

  -- ESLint fix-all
  map('<Leader>ef', function()
    vim.lsp.buf.code_action({
      context = { only = { 'source.fixAll.eslint' } },
      apply   = true,
    })
  end, 'ESLint fix all')

  -- Diagnostics
  map('[g', vim.diagnostic.goto_prev, 'Previous diagnostic')
  map(']g', vim.diagnostic.goto_next, 'Next diagnostic')
  map('<Leader>da', ':Telescope diagnostics<CR>', 'All diagnostics')
end

-- Called as a function to avoid load-order issues with cmp_nvim_lsp
function M.capabilities()
  return require('cmp_nvim_lsp').default_capabilities()
end

return M
