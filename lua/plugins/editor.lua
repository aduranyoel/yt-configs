-- lua/plugins/editor.lua

return {
  -- Treesitter: superior syntax highlighting + indentation
  -- Pinned to v0.9.x — last series compatible with Neovim 0.11
  {
    'nvim-treesitter/nvim-treesitter',
    version = '0.9.*',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'javascript', 'typescript', 'tsx', 'lua', 'vim', 'vimdoc',
          'html', 'css', 'json', 'java', 'bash', 'markdown',
        },
        auto_install = true,
        highlight    = { enable = true },
        indent       = { enable = true },
      })
    end,
  },

  -- Auto-close HTML/JSX tags (replaces vim-closetag)
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- Auto-close brackets/quotes (replaces auto-pairs)
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({ check_ts = true })
      -- Integrate with nvim-cmp: auto-close on completion confirm
      local ok, cmp = pcall(require, 'cmp')
      if ok then
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Comment toggle with Ctrl+/ (replaces nerdcommenter)
  {
    'numToStr/Comment.nvim',
    keys = {
      { '<C-_>', '<Plug>(comment_toggle_linewise_current)', mode = 'n', desc = 'Toggle comment' },
      { '<C-_>', '<Plug>(comment_toggle_linewise_visual)',  mode = 'v', desc = 'Toggle comment' },
    },
    config = function()
      require('Comment').setup()
    end,
  },

  -- Surround text objects (quotes, brackets, tags)
  { 'tpope/vim-surround' },

  -- Multiple cursors
  { 'mg979/vim-visual-multi' },

  -- Motion: jump to any 2-char sequence
  {
    'easymotion/vim-easymotion',
    keys = {
      { '<Leader>s', '<Plug>(easymotion-s2)', desc = 'EasyMotion 2-char' },
    },
  },

  -- Smooth scrolling
  { 'psliwka/vim-smoothie' },
}
