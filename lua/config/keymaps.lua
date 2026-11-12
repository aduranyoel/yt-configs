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

-- Copy to clipboard
map('v', '<C-c>', 'y')

-- Save / quit
map('n', '<Leader>w',  ':w<CR>')
map('n', '<Leader>q',  ':q<CR>')
map('n', '<Leader>Q',  ':q!<CR>')
map('n', '<Leader>ur', ':e!<CR>')

-- Reload config
map('n', '<Leader>so', ':source $MYVIMRC<CR>')

-- Split resize
map('n', '<Leader>h', '20<C-w><')
map('n', '<Leader>l', '20<C-w>>')

-- Quick semicolon at end of line
map('n', '<Leader>;', '$a;<Esc>')

-- Shorter command abbreviations
vim.cmd('cnoreabbrev tree NvimTreeToggle')
vim.cmd('cnoreabbrev find NvimTreeFindFile')
vim.cmd('cnoreabbrev blame Gblame')
vim.cmd('cnoreabbrev diff Gdiff')

-- File Explorer
map('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>')
map('n', '<Leader>E', ':NvimTreeToggle<CR>')

-- Jump list navigation (cursor history)
map('n', '<Leader>-', '<C-o>')
map('n', '<Leader>=', '<C-i>')

-- Buffer management
map('n', '<Leader>bd',   ':bdelete<CR>')
map('n', '<Leader>bD',   ':bdelete!<CR>')
map('n', '<Leader><F4>', ':bw<CR>')

-- Faster scrolling
map('n', '<C-j>', '10<C-e>')
map('n', '<C-k>', '10<C-y>')

-- Git (fugitive)
map('n', '<Leader>G',  ':G<CR>')
map('n', '<Leader>gp', ':G push<CR>')
map('n', '<Leader>gl', ':G pull<CR>')
map('n', '<Leader>gc', ':G commit -m ""<Left>')
map('n', '<Leader>gr', ':G rebase -i<CR>')

-- Run current file with Node
map('n', '<Leader>x', ':!node %<CR>')

-- String case conversion
map('n', '<Leader>Cc', function() require('textcase').current_word('to_camel_case') end,    { desc = 'camelCase' })
map('n', '<Leader>Ck', function() require('textcase').current_word('to_dash_case') end,     { desc = 'dash-case' })
map('n', '<Leader>CC', function() require('textcase').current_word('to_constant_case') end, { desc = 'CONSTANT_CASE' })
map('n', '<Leader>Cu', function() require('textcase').current_word('to_snake_case') end,    { desc = 'snake_case' })
map('v', '<Leader>Cc', function() require('textcase').current_word('to_camel_case') end,    { desc = 'camelCase' })
map('v', '<Leader>Ck', function() require('textcase').current_word('to_dash_case') end,     { desc = 'dash-case' })
map('v', '<Leader>CC', function() require('textcase').current_word('to_constant_case') end, { desc = 'CONSTANT_CASE' })
map('v', '<Leader>Cu', function() require('textcase').current_word('to_snake_case') end,    { desc = 'snake_case' })

-- Java: run test with Maven (finds nearest pom.xml)
local function find_pom_dir()
  local dir = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':h')
  while dir ~= '/' do
    if vim.fn.filereadable(dir .. '/pom.xml') == 1 then return dir end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return vim.fn.getcwd()
end

map('n', '<Leader>jt', function()
  local dir  = vim.fn.shellescape(find_pom_dir())
  local test = vim.fn.shellescape(vim.fn.expand('%:t:r'))
  vim.cmd('TermExec cmd="cd ' .. dir .. ' && mvn test -Dtest=' .. test .. '"')
end, { desc = 'Run Java test' })
