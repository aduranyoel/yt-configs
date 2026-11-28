local M = {}

function M.clear()
  local match = vim.w.cursor_word_match
  if match then
    pcall(vim.fn.matchdelete, match)
    vim.w.cursor_word_match = nil
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup('CursorWordHighlight', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = group,
    callback = function()
      M.clear()
      if vim.bo.buftype ~= '' or vim.fn.mode() ~= 'n' or vim.b.visual_multi then return end

      local column = vim.api.nvim_win_get_cursor(0)[2]
      local rest = vim.api.nvim_get_current_line():sub(column + 1)
      if vim.fn.matchstr(rest, [[^\k]]) == '' then return end

      local word = vim.fn.escape(vim.fn.expand('<cword>'), [[\]])
      vim.w.cursor_word_match = vim.fn.matchadd('LspReferenceText', [[\C\V\<]] .. word .. [[\>]], -1)
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave', 'WinLeave' }, {
    group = group,
    callback = M.clear,
  })
end

return M
