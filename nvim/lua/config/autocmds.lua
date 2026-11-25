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
    if vim.bo.buftype ~= '' then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Close the references window after a successful quickfix jump.
autocmd('FileType', {
  group = augroup('ReferenceQuickfix', { clear = true }),
  pattern = 'qf',
  callback = function(event)
    vim.keymap.set('n', '<CR>', function()
      local win = vim.api.nvim_get_current_win()
      local list = vim.fn.getqflist({ winid = 0, context = 0 })
      local is_references = list.winid == win
        and type(list.context) == 'table'
        and list.context.method == 'textDocument/references'

      vim.cmd.normal({ args = { vim.keycode('<CR>') }, bang = true })
      if is_references and vim.api.nvim_get_current_win() ~= win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, false)
      end
    end, { buffer = event.buf, desc = 'Jump to result and close references' })
  end,
})

require('config.lsp-shared').setup()
