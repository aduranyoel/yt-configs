-- init.lua — Neovim entry point

-- Load core config before plugins
require('config.options')
require('config.autocmds')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error('No se pudo instalar lazy.nvim:\n' .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (auto-discovers lua/plugins/*.lua)
require('lazy').setup('plugins', {
  defaults = { lazy = true },
  change_detection = { notify = false },
  ui = { border = 'rounded' },
  rocks = { enabled = false },
})

require('config.keymaps')

