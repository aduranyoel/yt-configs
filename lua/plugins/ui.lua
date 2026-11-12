-- lua/plugins/ui.lua

return {
  -- Theme
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup({ style = 'darker' })
      require('onedark').load()
    end,
  },

  -- Icons (required by nvim-tree, bufferline, lualine)
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled        = true,
          theme                = 'auto',
          component_separators = { left = '', right = '' },
          section_separators   = { left = '', right = '' },
          globalstatus         = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      })
    end,
  },

  -- Tab bar
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          mode              = 'buffers',
          numbers           = 'none',
          close_command     = 'bdelete! %d',
          indicator         = { icon = '▎', style = 'icon' },
          buffer_close_icon = '✕',
          modified_icon     = '●',
          close_icon        = '✕',
          left_trunc_marker  = '',
          right_trunc_marker = '',
          diagnostics                  = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          offsets = {{
            filetype  = 'NvimTree',
            text      = '  Explorer',
            highlight = 'Directory',
            separator = true,
          }},
          color_icons             = true,
          show_buffer_icons       = true,
          show_buffer_close_icons = true,
          show_close_icon         = true,
          show_tab_indicators     = true,
          separator_style         = 'slant',
          always_show_bufferline  = true,
        },
      })
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        view = { width = 32, side = 'left' },
        renderer = {
          group_empty    = true,
          highlight_git  = true,
          icons = {
            glyphs = {
              git = {
                unstaged  = '✗',
                staged    = '✓',
                unmerged  = '',
                renamed   = '➜',
                untracked = '★',
                deleted   = '',
                ignored   = '◌',
              },
            },
          },
        },
        filters = { dotfiles = false },
        git     = { enable = true, ignore = false },
        actions = { open_file = { quit_on_open = true } },
      })
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        indent = { char = '│', tab_char = '│' },
        scope  = { enabled = true, show_start = true, show_end = false },
      })
    end,
  },

  -- Color previews (#hex, rgb())
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
}
