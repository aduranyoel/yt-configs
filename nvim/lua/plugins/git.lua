local lazygit_terminals = {}

local function format_line_blame(_, blame)
  -- A queued lookup can finish after current-line blame is disabled.
  if not require('gitsigns.config').config.current_line_blame then
    return {}
  end

  local text = 'Sin commit'
  if blame.author ~= 'Not Committed Yet' then
    text = ('%s · %s'):format(blame.author, os.date('%Y-%m-%d %H:%M', blame.author_time))
  end

  -- Gitsigns publishes the buffer variables after its formatter returns.
  vim.schedule(vim.cmd.redrawstatus)
  return { { text, 'GitSignsCurrentLineBlame' } }
end

local function open_lazygit()
  local root = vim.fs.root(0, '.git')
  if not root or vim.fn.executable('lazygit') ~= 1 then
    vim.cmd.Git()
    return
  end

  local terminal = lazygit_terminals[root]
  if not terminal then
    local Terminal = require('toggleterm.terminal').Terminal
    terminal = Terminal:new({
      cmd = 'lazygit',
      dir = root,
      direction = 'float',
      display_name = 'LazyGit',
      hidden = true,
      on_open = function()
        vim.cmd.startinsert()
      end,
      on_exit = function()
        lazygit_terminals[root] = nil
      end,
    })
    lazygit_terminals[root] = terminal
  end
  terminal:toggle()
end

return {
  {
    'akinsho/toggleterm.nvim',
    keys = {
      { '<Leader>G', open_lazygit, desc = 'Open LazyGit' },
    },
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gclog' },
    keys = {
      { '<Leader>gd', '<Cmd>Gdiffsplit HEAD<CR>', desc = 'Diff current file against HEAD' },
      { '<Leader>gc', '<Cmd>Git commit<CR>', desc = 'Create Git commit' },
      { '<Leader>gH', '<Cmd>Git log --oneline -- %<CR>', desc = 'Git history for current file' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Gitsigns',
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { virt_text = false, delay = 300 },
      current_line_blame_formatter = format_line_blame,
      current_line_blame_formatter_nc = format_line_blame,
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(keys, action, desc)
          vim.keymap.set('n', keys, action, { buffer = bufnr, desc = desc })
        end
        local function map_hunk(keys, direction, desc)
          map(keys, function()
            if vim.wo.diff then
              vim.cmd.normal({ vim.v.count1 .. keys, bang = true })
            else
              gs.nav_hunk(direction)
            end
          end, desc)
        end
        map_hunk('[c', 'prev', 'Previous hunk')
        map_hunk(']c', 'next', 'Next hunk')
        map('<Leader>gb', gs.toggle_current_line_blame, 'Toggle line blame in statusline')
        map('<Leader>ghs', gs.stage_hunk, 'Stage hunk')
        map('<Leader>ghr', gs.reset_hunk, 'Reset hunk')
        map('<Leader>ghp', gs.preview_hunk, 'Preview hunk')
      end,
    },
  },
}
