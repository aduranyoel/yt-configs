return {
  -- Theme
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup({ style = 'dark' })
      require('onedark').load()
    end,
  },
  -- Show Tabs
  {
    'akinsho/bufferline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        mode = 'buffers',
        close_command = 'bdelete %d',
        right_mouse_command = false,
        buffer_close_icon = '×',
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        numbers = 'buffer_id',
        separator_style = 'slant',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'NvimTree',
            text_align = 'center',
            highlight = 'StatusLine',
            separator = true,
          },
        },
      },
    },
  },
  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeFindFileToggle', 'NvimTreeFocus' },
    keys = {
      { '<Leader>e', '<Cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' },
      { '<Leader>E', '<Cmd>NvimTreeFindFile<CR>', desc = 'Reveal current file' },
    },
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('IdeDirectory', { clear = true }),
        nested = true,
        callback = function(event)
          local path = vim.api.nvim_buf_get_name(event.buf)
          if vim.fn.isdirectory(path) == 1 then
            local tree = require('nvim-tree.api').tree
            vim.cmd.lcd({ args = { path }, magic = { file = false, bar = false } })
            tree.open({ path = path })
          end
        end,
      })
    end,
    config = function()
      vim.api.nvim_del_augroup_by_name('IdeDirectory')
      local filtered = {
        ['.git'] = true,
        ['.gradle'] = true,
        ['.next'] = true,
        build = true,
        coverage = true,
        dist = true,
        node_modules = true,
        target = true,
      }

      require('nvim-tree').setup({
        disable_netrw = true,
        hijack_netrw = false,
        view = { width = 32 },
        git = { enable = false },
        filters = {
          custom = function(path) return filtered[vim.fs.basename(path)] == true end,
        },
        actions = { open_file = { quit_on_open = true } },
      })
    end,
  },
}
