local function change_selected_case()
  local buffer = vim.api.nvim_get_current_buf()
  if not vim.bo[buffer].modifiable then
    vim.notify('Este buffer no se puede editar.', vim.log.levels.INFO)
    return
  end
  local changedtick = vim.api.nvim_buf_get_changedtick(buffer)
  local anchor, cursor = vim.fn.getpos('v'), vim.fn.getpos('.')
  local selection = { type = vim.fn.mode() }
  local regions = vim.fn.getregionpos(anchor, cursor, selection)
  local selected = vim.fn.getregion(anchor, cursor, selection)
  if #regions == 0 then return end

  local first = regions[1][1][2] - 1
  local last = regions[#regions][1][2]
  local lines = vim.api.nvim_buf_get_lines(buffer, first, last, false)
  local columns = {}
  for index, region in ipairs(regions) do
    local start = math.max(0, region[1][3] - 1)
    local text = selected[index]
    if lines[index]:sub(start + 1, start + #text) ~= text then
      vim.notify('Seleccioná caracteres completos para cambiar su formato.', vim.log.levels.INFO)
      return
    end
    columns[index] = start
  end

  local methods = require('textcase').api
  local cases = {
    { 'camelCase', methods.to_camel_case },
    { 'snake_case', methods.to_snake_case },
    { 'Title Case', methods.to_title_case },
    { 'PascalCase', methods.to_pascal_case },
    { 'kebab-case', methods.to_dash_case },
    { 'CONSTANT_CASE', methods.to_constant_case },
    { 'UPPERCASE', methods.to_upper_case },
    { 'lowercase', methods.to_lower_case },
  }
  local actions = require('telescope.actions')
  require('telescope.pickers').new({}, {
    prompt_title = 'Convertir texto',
    finder = require('telescope.finders').new_table({
      results = cases,
      entry_maker = function(case)
        return { value = case[2], display = case[1], ordinal = case[1] }
      end,
    }),
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(prompt)
      actions.select_default:replace(function()
        local entry = require('telescope.actions.state').get_selected_entry()
        actions.close(prompt)
        if not entry then return end
        if not vim.api.nvim_buf_is_loaded(buffer) or vim.api.nvim_buf_get_changedtick(buffer) ~= changedtick then
          vim.notify('El buffer cambió. Volvé a seleccionar el texto.', vim.log.levels.INFO)
          return
        end
        if not vim.bo[buffer].modifiable then
          vim.notify('Este buffer no se puede editar.', vim.log.levels.INFO)
          return
        end

        for index, text in ipairs(vim.tbl_map(entry.value.apply, selected)) do
          if text ~= selected[index] then
            local row = first + index - 1
            local column = columns[index]
            vim.api.nvim_buf_set_text(buffer, row, column, row, column + #selected[index], { text })
          end
        end
      end)
      return true
    end,
  }):find()
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = '0.9.*',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'javascript', 'typescript', 'tsx', 'html', 'css', 'json', 'java', 'sql',
          'lua', 'vim', 'vimdoc', 'bash', 'markdown',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '│' },
      scope = { show_start = false, show_end = false },
      exclude = { filetypes = { 'NvimTree', 'TelescopePrompt', 'grug-far', 'lazy', 'mason' } },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      map_cr = false,
      enabled = function(bufnr)
        return vim.bo[bufnr].filetype ~= 'grug-far'
      end,
    },
  },
  {
    'easymotion/vim-easymotion',
    init = function()
      vim.g.EasyMotion_do_mapping = 0
    end,
    keys = {
      { '<Leader>s', '<Plug>(easymotion-s2)', desc = 'Jump to two characters' },
    },
  },
  {
    'johmsalas/text-case.nvim',
    main = 'textcase',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = {
      { '<Leader>C', change_selected_case, mode = 'x', desc = 'Convert selected text' },
    },
    opts = { default_keymappings_enabled = false },
  },
  {
    'mg979/vim-visual-multi',
    init = function()
      vim.g.VM_maps = vim.tbl_extend('force', vim.g.VM_maps or {}, {
        ['Case Conversion Menu'] = '<Leader>C',
      })
    end,
    keys = {
      { '<C-n>', mode = { 'n', 'x' }, desc = 'Select next occurrence' },
      { '<C-Up>', desc = 'Add cursor above' },
      { '<C-Down>', desc = 'Add cursor below' },
      { '<Leader>mk', '<Plug>(VM-Add-Cursor-Up)', desc = 'Add cursor above' },
      { '<Leader>mj', '<Plug>(VM-Add-Cursor-Down)', desc = 'Add cursor below' },
      { [[\\A]], mode = { 'n', 'x' }, desc = 'Select all occurrences' },
    },
  },
}
