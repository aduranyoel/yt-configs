-- lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save (skip binary and markdown files)
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    local skip = { markdown = true, md = true }
    if skip[ft] then return end
    if vim.bo.binary then return end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Set formatexpr for TypeScript/JSON (used by LSP formatting)
augroup('LspFormatExpr', { clear = true })
autocmd('FileType', {
  group = 'LspFormatExpr',
  pattern = { 'typescript', 'json' },
  callback = function()
    vim.opt_local.formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end,
})
