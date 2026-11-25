local function file_icon(name)
  local icon = require('nvim-web-devicons').get_icon(vim.fn.expand('%:t'), nil, { default = true })
  return (icon and icon .. ' ' or '') .. name
end

local function git_branch()
  local branch = vim.b.gitsigns_head
  return branch and branch:gsub('%%', '%%%%') or ''
end

local function git_blame()
  local blame = vim.b.gitsigns_blame_line_dict and vim.b.gitsigns_blame_line
  return blame and blame:gsub('%%', '%%%%') or ''
end

local function lsp_label()
  if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
    return ''
  end
  local filetype = vim.bo.filetype
  return '[LSP] ' .. filetype:upper()
end

local function cursor_location()
  local row, total = vim.fn.line('.'), vim.fn.line('$')
  return ('%d/%d:%d %d%%%%'):format(row, total, vim.fn.charcol('.'), math.floor(row / total * 100))
end

local progress_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
local function scroll_position()
  local total = math.max(vim.fn.line('$') - 1, 1)
  local index = math.floor((vim.fn.line('.') - 1) / total * (#progress_blocks - 1)) + 1
  return progress_blocks[index]
end

local function has_file()
  return vim.bo.buftype == '' and vim.api.nvim_buf_get_name(0) ~= ''
end

local function can_close_split()
  if not has_file() then return false end
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buffer = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative == '' and vim.bo[buffer].buftype == '' then
      count = count + 1
    end
  end
  return count > 1
end

local function close_split(_, button)
  if button ~= 'l' then return end
  local win = vim.fn.getmousepos().winid
  if not vim.api.nvim_win_is_valid(win) then return end
  if not vim.api.nvim_win_call(win, can_close_split) then return end
  local ok, error_message = pcall(vim.api.nvim_win_close, win, false)
  if not ok then
    vim.notify(tostring(error_message), vim.log.levels.WARN)
  end
end

local function winbar()
  return {
    lualine_a = {
      { 'filename', fmt = file_icon, cond = has_file, separator = { left = '' } },
      { function() return '×' end, cond = can_close_split, on_click = close_split,
        padding = { left = 0, right = 1 }, separator = { right = '' } },
    },
  }
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        'SmiteshP/nvim-navic',
        opts = {
          lsp = { auto_attach = true, preference = { 'jdtls', 'ts_ls' } },
          highlight = true,
          separator = ' › ',
          depth_limit = 3,
        },
      },
    },
    opts = function()
      local navic = require('nvim-navic')
      local auxiliary = {
        'NvimTree', 'TelescopePrompt', 'TelescopeResults', 'TelescopePreview',
        'lazy', 'mason', 'qf', 'help', 'fugitive', 'grug-far', 'toggleterm',
      }
      return {
        options = {
          theme = 'onedark',
          globalstatus = true,
          component_separators = '',
          section_separators = '',
          ignore_focus = auxiliary,
          disabled_filetypes = { winbar = auxiliary },
        },
        sections = {
          lualine_a = {
            { 'mode', fmt = function(mode) return mode:sub(1, 1) end, icon = '',
              separator = { left = '', right = '' } },
          },
          lualine_b = {
            { 'filename', path = 1, shorting_target = 26, fmt = file_icon },
            { git_branch, icon = '', color = 'Constant' },
          },
          lualine_c = {
            { function() return navic.get_location() end,
              cond = function() return vim.o.columns >= 105 and navic.is_available() end },
          },
          lualine_x = {
            { git_blame, color = 'Comment' },
            { lsp_label, icon = '', color = 'DiagnosticOk' },
          },
          lualine_y = { cursor_location },
          lualine_z = { { scroll_position, padding = { left = 0, right = 1 } } },
        },
        winbar = winbar(),
        inactive_winbar = winbar(),
      }
    end,
  },
}
