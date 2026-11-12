-- init.lua — Neovim entry point

-- Load core config before plugins
require('config.options')
require('config.autocmds')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (auto-discovers lua/plugins/*.lua)
require('lazy').setup('plugins', {
  change_detection = { notify = false },
  ui = { border = 'rounded' },
  rocks = { enabled = false },
})

-- Load keymaps after plugins (some plugin functions need to exist)
require('config.keymaps')

