-- lua/plugins/tools.lua

return {
  -- Fuzzy finder (replaces fzf + fzf.vim)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<Leader>p',  ':Telescope find_files<CR>',  desc = 'Find files' },
      { '<Leader>rg', ':Telescope live_grep<CR>',   desc = 'Live grep' },
      { '<Leader>bf', ':Telescope buffers<CR>',     desc = 'Open buffers' },
      { '<Leader>fs', ':Telescope find_files<CR>',  desc = 'Find files (alt)' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config   = { preview_width = 0.55 },
          file_ignore_patterns = { 'node_modules', '.git/' },
        },
      })
    end,
  },

  -- Integrated terminal (like VS Code Ctrl+`)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>',      desc = 'Toggle terminal (horizontal)' },
      { '<Leader>tf',  ':ToggleTerm direction=float<CR>',  desc = 'Float terminal' },
      { '<Leader>ai',  desc = 'Claude Code terminal' },
    },
    config = function()
      require('toggleterm').setup({
        size            = 20,
        open_mapping    = [[<C-\>]],
        hide_numbers    = true,
        shade_terminals = true,
        shading_factor  = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size    = true,
        direction       = 'horizontal',
        close_on_exit   = true,
        shell           = vim.o.shell,
        float_opts      = { border = 'curved', winblend = 0 },
      })

      -- Dedicated Claude Code floating terminal
      local Terminal = require('toggleterm.terminal').Terminal
      local claude = Terminal:new({
        cmd       = 'claude',
        direction = 'float',
        hidden    = true,
        float_opts = {
          border   = 'curved',
          width    = math.floor(vim.o.columns * 0.9),
          height   = math.floor(vim.o.lines   * 0.9),
          winblend = 0,
        },
        on_open = function(_)
          vim.cmd('startinsert!')
        end,
      })

      function _CLAUDE_TOGGLE()
        claude:toggle()
      end

      vim.keymap.set('n', '<Leader>ai', _CLAUDE_TOGGLE, { desc = 'Claude Code' })
    end,
  },

  -- Tmux pane navigation
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<Leader><C-h>', ':TmuxNavigateLeft<CR>',  silent = true, desc = 'Tmux left' },
      { '<Leader><C-j>', ':TmuxNavigateDown<CR>',  silent = true, desc = 'Tmux down' },
      { '<Leader><C-k>', ':TmuxNavigateUp<CR>',    silent = true, desc = 'Tmux up' },
      { '<Leader><C-l>', ':TmuxNavigateRight<CR>', silent = true, desc = 'Tmux right' },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- String case conversion (camelCase, snake_case, CONSTANT_CASE, dash-case)
  {
    'johmsalas/text-case.nvim',
    config = function()
      require('textcase').setup({})
    end,
  },

  -- EditorConfig support
  { 'editorconfig/editorconfig-vim' },
}
