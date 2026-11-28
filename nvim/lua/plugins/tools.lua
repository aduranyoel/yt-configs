-- lua/plugins/tools.lua

local function grep_project_text()
  local mode = vim.fn.mode()
  local text = vim.fn.expand('<cword>')
  if mode == 'v' or mode == 'V' or mode == '\22' then
    local selection = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), {
      type = mode,
      exclusive = vim.o.selection == 'exclusive',
    })
    if #selection ~= 1 then
      vim.notify('Seleccioná texto dentro de una sola línea.', vim.log.levels.INFO)
      return
    end
    text = selection[1]
  end
  if text == '' then return end

  require('telescope.builtin').grep_string({
    search = text,
    cwd = vim.fs.root(0, '.git') or vim.fn.getcwd(),
  })
end

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    event = 'LspAttach',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    keys = {
      { '<Leader>p',  ':Telescope find_files<CR>',  desc = 'Find files' },
      { '<Leader>rg', ':Telescope live_grep<CR>',   desc = 'Live grep' },
      { '<Leader>bf', ':Telescope buffers<CR>',     desc = 'Open buffers' },
      { '<Leader>fs', ':Telescope find_files<CR>',  desc = 'Find files (alt)' },
      { '<Leader>da', ':Telescope diagnostics<CR>', desc = 'Diagnostics' },
      { '<Leader>P', grep_project_text, mode = { 'n', 'x' }, desc = 'Search word or selection in project' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config   = { horizontal = { preview_width = 0.55 } },
          file_ignore_patterns = { 'node_modules/', '%.git/' },
          mappings = { i = { ['<Esc>'] = actions.close } },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({
              previewer = false,
              layout_config = { width = 0.8, height = 0.4 },
            }),
          },
        },
      })
      telescope.load_extension('ui-select')
    end,
  },

  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      { '<Leader>rp', function()
        local root = vim.fs.root(0, '.git') or vim.fn.getcwd()
        require('grug-far').open({
          transient = true,
          prefills = {
            paths = vim.fn.fnameescape(root),
            flags = '--fixed-strings --smart-case',
          },
        })
      end, desc = 'Replace in project' },
    },
    opts = { keymaps = { replace = { n = 'R' } } },
  },

  -- Integrated terminal (like VS Code Ctrl+`)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec' },
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

      vim.keymap.set('n', '<Leader>ai', function() claude:toggle() end, { desc = 'Claude Code' })
    end,
  },
}
