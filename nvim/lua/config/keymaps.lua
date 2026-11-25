-- lua/config/keymaps.lua

local map = vim.keymap.set

-- Move selected lines up/down
map('x', 'K', ":move '<-2<CR>gv-gv", { silent = true })
map('x', 'J', ":move '>+1<CR>gv-gv", { silent = true })

-- Buffer navigation
map('n', '<Tab>',   ':bnext<CR>',     { silent = true })
map('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
map('n', '<A-Right>', ':bnext<CR>',     { silent = true })
map('n', '<A-Left>',  ':bprevious<CR>', { silent = true })

-- Share Tab between the completion menu, snippets and normal indentation.
local function completion_tab(key, direction, menu_key)
  map({ 'i', 's' }, key, function()
    if vim.fn.pumvisible() == 1 then
      return menu_key
    end
    if vim.snippet.active({ direction = direction }) then
      return ('<Cmd>lua vim.snippet.jump(%d)<CR>'):format(direction)
    end
    return key
  end, { expr = true, silent = true, desc = 'Navigate completions or snippet fields' })
end

completion_tab('<Tab>', 1, '<C-n>')
completion_tab('<S-Tab>', -1, '<C-p>')

map('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'selected' }).selected >= 0 then
    return '<C-y>'
  end
  return '<CR>'
end, { expr = true, desc = 'Accept selected completion or insert newline' })

-- Copy to clipboard
map('v', '<C-c>', 'y')

-- Save / quit
map('n', '<Leader>w',  ':w<CR>')
map('n', '<Leader>q',  ':q<CR>')
map('n', '<Leader>Q',  ':q!<CR>')
map('n', '<Leader>ur', ':e!<CR>')
map('n', '<Leader>L', '<Cmd>Lazy<CR>', { desc = 'Manage plugins with Lazy' })

-- Split resize
map('n', '<Leader>h', '20<C-w><')
map('n', '<Leader>l', '20<C-w>>')

-- Quick semicolon at end of line
map('n', '<Leader>;', '$a;<Esc>')

vim.cmd('cnoreabbrev tree NvimTreeToggle')

-- Jump list navigation (cursor history)
map('n', '<Leader>-', '<C-o>', { desc = 'Previous cursor position' })
map('n', '<Leader>=', '<C-i>', { desc = 'Next cursor position' })
map('n', '<LeftMouse>', function()
  local mouse = vim.fn.getmousepos()
  if mouse.winid == vim.api.nvim_get_current_win()
    and mouse.line > 0
    and mouse.line ~= vim.api.nvim_win_get_cursor(0)[1]
    and vim.bo.buftype == ''
  then
    -- Save the position before Neovim handles the click.
    return "m'<LeftMouse>"
  end
  return '<LeftMouse>'
end, { expr = true, desc = 'Save cursor position before clicking another line' })

-- Buffer management
map('n', '<Leader>bd',   ':bdelete<CR>')
map('n', '<Leader>bD',   ':bdelete!<CR>')
map('n', '<Leader><F4>', ':bw<CR>')

-- Faster scrolling
map('n', '<C-j>', '10<C-e>')
map('n', '<C-k>', '10<C-y>')

-- Native line comments, plus the Ctrl+/ alias sent by many terminals.
map('n', '<C-_>', 'gcc', { remap = true, desc = 'Toggle comment' })
map('x', '<C-_>', 'gc', { remap = true, desc = 'Toggle selected lines' })

-- Diagnostics in the current buffer
map('n', '[g', function() vim.diagnostic.jump({ count = -1, float = true }) end)
map('n', ']g', function() vim.diagnostic.jump({ count = 1, float = true }) end)
map('n', '<Leader>dd', vim.diagnostic.open_float, { desc = 'Diagnostic under cursor' })

-- Search and replace.
map('n', '<Leader>n', function()
  vim.cmd.nohlsearch()
  vim.lsp.buf.clear_references()
end, { desc = 'Clear search and reference highlighting' })
map('n', '<Leader>rf', [[:%s/\V//gc<Left><Left><Left><Left>]], { desc = 'Replace in current file' })
map('n', '<Leader>rr', [[:%s/\v//gc<Left><Left><Left><Left>]], { desc = 'Replace regex in current file' })

-- Run the current JavaScript file with Node.
map('n', '<Leader>x', function()
  vim.cmd('!node ' .. vim.fn.shellescape(vim.fn.expand('%:p'), true))
end, { desc = 'Run file with Node' })

-- Run a Java test class from its nearest Maven module.
map('n', '<Leader>jt', function()
  local root = vim.fs.root(0, 'pom.xml')
  if not root then
    vim.notify('No se encontró un pom.xml para este archivo.', vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.shellescape(root)
  local test = vim.fn.shellescape('-Dtest=' .. vim.fn.expand('%:t:r'))
  require('toggleterm').exec('(cd ' .. dir .. ' && mvn test ' .. test .. ')')
end, { desc = 'Run Maven test class' })
