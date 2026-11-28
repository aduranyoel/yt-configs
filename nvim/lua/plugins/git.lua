local lazygit_terminals = {}

local function format_git_hunks()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local base = vim.system({ 'git', 'show', ':./' .. vim.fs.basename(filename) }, {
    cwd = vim.fs.dirname(filename),
    text = true,
  }):wait(2000)
  if base.code ~= 0 then
    vim.notify(base.stderr or 'No se pudo leer el archivo del índice de Git.', vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local current = table.concat(lines, '\n') .. (vim.bo[bufnr].endofline and '\n' or '')
  local hunks = vim.diff(base.stdout, current, { result_type = 'indices' }) or {}
  local count = 0
  -- Work upwards so a formatter adding lines does not shift earlier hunks.
  for index = #hunks, 1, -1 do
    local first, added = hunks[index][3], hunks[index][4]
    if added > 0 then
      local last = first + added - 1
      local line = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1]
      local failed
      require('conform').format({
        bufnr = bufnr,
        lsp_format = 'fallback',
        range = { start = { first, 0 }, ['end'] = { last, #line } },
      }, function(format_err) failed = format_err end)
      if failed then return end
      count = count + 1
    end
  end
  if count == 0 then
    vim.notify('No hay líneas agregadas o modificadas sin stage para formatear.', vim.log.levels.INFO)
  end
end

local function lazygit_config()
  local base = vim.env.LG_CONFIG_FILE
  if not base or base == '' then
    local directory = vim.fn.systemlist({ 'lazygit', '--print-config-dir' })[1]
    if vim.v.shell_error == 0 and directory then
      local path = directory .. '/config.yml'
      if vim.fn.filereadable(path) == 1 then base = path end
    end
  end
  local editor = vim.fn.stdpath('config') .. '/lazygit.yml'
  return base and base ~= '' and (base .. ',' .. editor) or editor
end

local function compare_branch()
  vim.ui.input({
    prompt = 'Comparar archivo con rama: ',
    completion = 'customlist,fugitive#CompleteObject',
  }, function(branch)
    if not branch or vim.trim(branch) == '' then return end
    local ok, message = pcall(vim.cmd.Gdiffsplit, {
      args = { vim.trim(branch) },
      magic = { file = false, bar = false },
    })
    if not ok then
      vim.notify(tostring(message), vim.log.levels.WARN)
    end
  end)
end

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
      env = { LG_CONFIG_FILE = lazygit_config(), NVIM = vim.v.servername },
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
      { '<Leader>gD', compare_branch, desc = 'Diff current file against another branch' },
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
        map('<Leader>gf', format_git_hunks, 'Format unstaged Git hunks in current file')
      end,
    },
  },
}
