-- lua/config/options.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw (required by nvim-tree)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number         = true
opt.relativenumber = true
opt.numberwidth    = 1
opt.cursorline     = true
opt.signcolumn     = 'number'

opt.mouse    = 'a'
opt.clipboard = 'unnamed'
opt.encoding = 'utf-8'

opt.tabstop    = 2
opt.shiftwidth = 2
opt.expandtab  = true

opt.hlsearch   = true
opt.incsearch  = true
opt.ignorecase = true
opt.smartcase  = true
opt.showmatch  = true

opt.termguicolors = true
opt.laststatus    = 3      -- global statusline
opt.showmode      = false  -- lualine shows mode instead
opt.showcmd       = true
opt.ruler         = true

opt.hidden       = true
opt.backup       = false
opt.writebackup  = false
opt.updatetime   = 300
opt.cmdheight    = 2
opt.shortmess:append('c')

opt.splitright = true
