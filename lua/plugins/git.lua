-- lua/plugins/git.lua

return {
  -- Git signs in gutter + inline blame (replaces vim-signify)
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = false, -- toggle with <Leader>gb
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end
          map('[c', gs.prev_hunk,         'Previous hunk')
          map(']c', gs.next_hunk,         'Next hunk')
          map('<Leader>gb', gs.toggle_current_line_blame, 'Toggle line blame')
          map('<Leader>ghs', gs.stage_hunk,   'Stage hunk')
          map('<Leader>ghr', gs.reset_hunk,   'Reset hunk')
          map('<Leader>ghp', gs.preview_hunk, 'Preview hunk')
        end,
      })
    end,
  },

  -- Git commands (:G status, :G push, etc.)
  { 'tpope/vim-fugitive' },

  -- GitHub integration (enables :GBrowse for GitHub URLs)
  { 'tpope/vim-rhubarb' },

  -- Git commit browser
  { 'junegunn/gv.vim', dependencies = { 'tpope/vim-fugitive' } },

  -- LazyGit TUI
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<Leader>gg', ':LazyGit<CR>', desc = 'LazyGit' },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend       = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars   = { '╭','─','╮','│','╯','─','╰','│' }
      vim.g.lazygit_use_neovim_remote              = 1
    end,
  },

  -- Visual diff + conflict resolution
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<Leader>gd', ':DiffviewOpen<CR>',              desc = 'Diffview open' },
      { '<Leader>gh', ':DiffviewFileHistory %<CR>',     desc = 'File history' },
      { '<Leader>gm', ':DiffviewOpen HEAD..MERGE_HEAD<CR>', desc = 'Merge diff' },
      { '<Leader>gx', ':DiffviewClose<CR>',             desc = 'Diffview close' },
    },
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true,
        view = {
          default    = { layout = 'diff2_horizontal' },
          merge_tool = { layout = 'diff3_horizontal', disable_diagnostics = true },
        },
        file_panel = {
          listing_style = 'tree',
          win_config    = { width = 35 },
        },
      })
    end,
  },

  -- plenary (shared dependency)
  { 'nvim-lua/plenary.nvim', lazy = true },
}
