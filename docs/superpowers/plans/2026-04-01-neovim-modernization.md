# Neovim Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the Neovim config from a VimScript + embedded Lua hybrid to a fully modern pure-Lua setup with lazy.nvim, native LSP, Telescope, and nvim-treesitter.

**Architecture:** `init.lua` bootstraps lazy.nvim and loads `lua/config/{options,keymaps,autocmds}.lua` before plugins. `lua/plugins/` contains one file per concern (ui, editor, lsp, git, tools); lazy.nvim auto-discovers them. Native LSP stack: mason → mason-lspconfig → nvim-lspconfig → nvim-cmp replaces CoC entirely.

**Tech Stack:** Neovim >= 0.10, lazy.nvim, mason.nvim, nvim-lspconfig, nvim-cmp, LuaSnip, conform.nvim, telescope.nvim, nvim-treesitter, gitsigns.nvim, Comment.nvim, nvim-autopairs, nvim-ts-autotag

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `init.lua` | Create | Entry point: lazy bootstrap + load config + load plugins |
| `lua/config/options.lua` | Create | All vim options (replaces init.vim options + coc-config.vim options) |
| `lua/config/keymaps.lua` | Create | All non-LSP keymaps (replaces maps.vim, removes duplicates from coc-config.vim) |
| `lua/config/autocmds.lua` | Create | Autocommands (highlight on yank, Java filetype map) |
| `lua/plugins/ui.lua` | Create | onedark, lualine, bufferline, nvim-tree, ibl, colorizer, devicons |
| `lua/plugins/editor.lua` | Create | treesitter, autopairs, ts-autotag, Comment.nvim, surround, multicursor, easymotion, smoothie |
| `lua/plugins/lsp.lua` | Create | mason, mason-lspconfig, nvim-lspconfig, nvim-cmp, LuaSnip, conform.nvim |
| `lua/plugins/git.lua` | Create | gitsigns, fugitive, rhubarb, gv.vim, lazygit, diffview |
| `lua/plugins/tools.lua` | Create | telescope, toggleterm (+ Claude terminal), tmux-navigator, text-case, editorconfig |
| `KEYMAPS.md` | Rewrite | Full keymap reference organized by category |
| `init.vim` | Delete | Replaced by init.lua |
| `plugins.vim` | Delete | Replaced by lazy.nvim specs in lua/plugins/ |
| `plugins-config.vim` | Delete | Replaced by lua/plugins/ |
| `lua-plugins.vim` | Delete | Replaced by lua/plugins/ |
| `coc-config.vim` | Delete | Replaced by lua/plugins/lsp.lua |
| `coc-settings.json` | Delete | Replaced by lspconfig server configs |
| `maps.vim` | Delete | Replaced by lua/config/keymaps.lua |

---

## Task 1: Initialize git and backup current config

**Files:** none created/modified

- [ ] **Step 1: Initialize git repo to enable safe rollback**

```bash
cd /Users/yduran/nvim
git init
git add .
git commit -m "chore: backup original vimscript config before modernization"
```

- [ ] **Step 2: Verify backup**

```bash
git log --oneline
```
Expected: one commit with the backup message.

---

## Task 2: Create directory structure

**Files:**
- Create: `lua/config/` (directory)
- Create: `lua/plugins/` (directory)

- [ ] **Step 1: Create directories**

```bash
mkdir -p /Users/yduran/nvim/lua/config
mkdir -p /Users/yduran/nvim/lua/plugins
```

- [ ] **Step 2: Verify**

```bash
ls /Users/yduran/nvim/lua/
```
Expected output: `config  plugins`

- [ ] **Step 3: Commit**

```bash
cd /Users/yduran/nvim
git add lua/
git commit -m "chore: create lua/ directory structure"
```

---

## Task 3: Create lua/config/options.lua

**Files:**
- Create: `lua/config/options.lua`

- [ ] **Step 1: Write options.lua**

```lua
-- lua/config/options.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw (required by nvim-tree)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number         = true
opt.relativenumber = true
opt.numberwidth    = 1
opt.cursorline     = true
opt.signcolumn     = 'number'

opt.mouse    = 'a'
opt.clipboard = 'unnamed'
opt.encoding = 'utf-8'

opt.tabstop    = 2
opt.shiftwidth = 2
opt.expandtab  = true

opt.hlsearch   = true
opt.incsearch  = true
opt.ignorecase = true
opt.smartcase  = true
opt.showmatch  = true

opt.termguicolors = true
opt.laststatus    = 3      -- global statusline
opt.showmode      = false  -- lualine shows mode instead
opt.showcmd       = true
opt.ruler         = true

opt.hidden       = true
opt.backup       = false
opt.writebackup  = false
opt.updatetime   = 300
opt.cmdheight    = 2
opt.shortmess:append('c')

opt.splitright = true

opt.syntax = 'on'
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/config/options.lua
git commit -m "feat: add lua/config/options.lua"
```

---

## Task 4: Create lua/config/autocmds.lua

**Files:**
- Create: `lua/config/autocmds.lua`

- [ ] **Step 1: Write autocmds.lua**

```lua
-- lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Set formatexpr for TypeScript/JSON (used by LSP formatting)
augroup('LspFormatExpr', { clear = true })
autocmd('FileType', {
  group = 'LspFormatExpr',
  pattern = { 'typescript', 'json' },
  callback = function()
    vim.opt_local.formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end,
})
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/config/autocmds.lua
git commit -m "feat: add lua/config/autocmds.lua"
```

---

## Task 5: Create lua/config/keymaps.lua

**Files:**
- Create: `lua/config/keymaps.lua`

Note: LSP keymaps (gd, gy, gi, gr, K, <Leader>rn, <Leader>a, [g, ]g, <Leader>f, <Leader>ef) are NOT here — they live in lua/plugins/lsp.lua inside `on_attach`. Plugin-specific keymaps (Comment, easymotion, toggleterm, tmux) are defined in each plugin's `keys` table.

- [ ] **Step 1: Write keymaps.lua**

```lua
-- lua/config/keymaps.lua

local map = vim.keymap.set

-- Move selected lines up/down
map('x', 'K', ":move '<-2<CR>gv-gv", { silent = true })
map('x', 'J', ":move '>+1<CR>gv-gv", { silent = true })

-- Buffer navigation
map('n', '<Tab>',   ':bnext<CR>',     { silent = true })
map('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
map('n', '<A-Right>', ':bnext<CR>',     { silent = true })
map('n', '<A-Left>',  ':bprevious<CR>', { silent = true })

-- Copy to clipboard
map('v', '<C-c>', 'y')

-- Save / quit
map('n', '<Leader>w',  ':w<CR>')
map('n', '<Leader>q',  ':q<CR>')
map('n', '<Leader>Q',  ':q!<CR>')
map('n', '<Leader>ur', ':e!<CR>')

-- Reload config
map('n', '<Leader>so', ':source $MYVIMRC<CR>')

-- Split resize
map('n', '<Leader>h', '20<C-w><')
map('n', '<Leader>l', '20<C-w>>')

-- Quick semicolon at end of line
map('n', '<Leader>;', '$a;<Esc>')

-- Shorter command abbreviations
vim.cmd('cnoreabbrev tree NvimTreeToggle')
vim.cmd('cnoreabbrev find NvimTreeFindFile')
vim.cmd('cnoreabbrev blame Gblame')
vim.cmd('cnoreabbrev diff Gdiff')

-- File Explorer
map('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>')
map('n', '<Leader>E', ':NvimTreeToggle<CR>')

-- Jump list navigation (cursor history)
map('n', '<Leader>-', '<C-o>')
map('n', '<Leader>=', '<C-i>')

-- Buffer management
map('n', '<Leader>bd',   ':bdelete<CR>')
map('n', '<Leader>bD',   ':bdelete!<CR>')
map('n', '<Leader><F4>', ':bw<CR>')

-- Faster scrolling
map('n', '<C-j>', '10<C-e>')
map('n', '<C-k>', '10<C-y>')

-- Git (fugitive)
map('n', '<Leader>G',  ':G<CR>')
map('n', '<Leader>gp', ':G push<CR>')
map('n', '<Leader>gl', ':G pull<CR>')
map('n', '<Leader>gc', ':G commit -m ""<Left>')
map('n', '<Leader>gr', ':G rebase -i<CR>')

-- Run current file with Node
map('n', '<Leader>x', ':!node %<CR>')

-- String case conversion
map('n', '<Leader>Cc', function() require('textcase').current_word('to_camel_case') end,    { desc = 'camelCase' })
map('n', '<Leader>Ck', function() require('textcase').current_word('to_dash_case') end,     { desc = 'dash-case' })
map('n', '<Leader>CC', function() require('textcase').current_word('to_constant_case') end, { desc = 'CONSTANT_CASE' })
map('n', '<Leader>Cu', function() require('textcase').current_word('to_snake_case') end,    { desc = 'snake_case' })
map('v', '<Leader>Cc', function() require('textcase').current_word('to_camel_case') end,    { desc = 'camelCase' })
map('v', '<Leader>Ck', function() require('textcase').current_word('to_dash_case') end,     { desc = 'dash-case' })
map('v', '<Leader>CC', function() require('textcase').current_word('to_constant_case') end, { desc = 'CONSTANT_CASE' })
map('v', '<Leader>Cu', function() require('textcase').current_word('to_snake_case') end,    { desc = 'snake_case' })

-- Java: run test with Maven (finds nearest pom.xml)
local function find_pom_dir()
  local dir = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':h')
  while dir ~= '/' do
    if vim.fn.filereadable(dir .. '/pom.xml') == 1 then return dir end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return vim.fn.getcwd()
end

map('n', '<Leader>jt', function()
  local dir  = find_pom_dir()
  local test = vim.fn.expand('%:t:r')
  vim.cmd('TermExec cmd="cd ' .. dir .. ' && mvn test -Dtest=' .. test .. '"')
end, { desc = 'Run Java test' })
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/config/keymaps.lua
git commit -m "feat: add lua/config/keymaps.lua"
```

---

## Task 6: Create init.lua

**Files:**
- Create: `init.lua`

- [ ] **Step 1: Write init.lua**

```lua
-- init.lua — Neovim entry point

-- Load core config before plugins
require('config.options')
require('config.autocmds')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (auto-discovers lua/plugins/*.lua)
require('lazy').setup('plugins', {
  change_detection = { notify = false },
  ui = { border = 'rounded' },
})

-- Load keymaps after plugins (some plugin functions need to exist)
require('config.keymaps')

-- Colorscheme (set after plugins load)
vim.cmd('colorscheme onedark')
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add init.lua
git commit -m "feat: add init.lua with lazy.nvim bootstrap"
```

---

## Task 7: Create lua/plugins/ui.lua

**Files:**
- Create: `lua/plugins/ui.lua`

- [ ] **Step 1: Write ui.lua**

```lua
-- lua/plugins/ui.lua

return {
  -- Theme
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup({ style = 'darker' })
      -- colorscheme applied in init.lua after plugins load
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
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/plugins/ui.lua
git commit -m "feat: add lua/plugins/ui.lua (theme, lualine, bufferline, nvim-tree, ibl)"
```

---

## Task 8: Create lua/plugins/editor.lua

**Files:**
- Create: `lua/plugins/editor.lua`

- [ ] **Step 1: Write editor.lua**

```lua
-- lua/plugins/editor.lua

return {
  -- Treesitter: superior syntax highlighting + text objects
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'javascript', 'typescript', 'tsx', 'lua', 'vim', 'vimdoc',
          'html', 'css', 'json', 'java', 'bash', 'markdown',
        },
        auto_install    = true,
        highlight       = { enable = true },
        indent          = { enable = true },
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
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/plugins/editor.lua
git commit -m "feat: add lua/plugins/editor.lua (treesitter, autopairs, comment, motion)"
```

---

## Task 9: Create lua/plugins/git.lua

**Files:**
- Create: `lua/plugins/git.lua`

- [ ] **Step 1: Write git.lua**

```lua
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
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/plugins/git.lua
git commit -m "feat: add lua/plugins/git.lua (gitsigns, fugitive, lazygit, diffview)"
```

---

## Task 10: Create lua/plugins/tools.lua

**Files:**
- Create: `lua/plugins/tools.lua`

- [ ] **Step 1: Write tools.lua**

```lua
-- lua/plugins/tools.lua

return {
  -- Fuzzy finder (replaces fzf + fzf.vim)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<Leader>p',  ':Telescope find_files<CR>',  desc = 'Find files' },
      { '<Leader>rg', ':Telescope live_grep<CR>',   desc = 'Live grep' },
      { '<Leader>gs', ':Telescope live_grep<CR>',   desc = 'Search workspace' },
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
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/plugins/tools.lua
git commit -m "feat: add lua/plugins/tools.lua (telescope, toggleterm, claude terminal)"
```

---

## Task 11: Create lua/plugins/lsp.lua

**Files:**
- Create: `lua/plugins/lsp.lua`

- [ ] **Step 1: Write lsp.lua**

```lua
-- lua/plugins/lsp.lua

-- Shared on_attach: keymaps active only when LSP is connected to a buffer
local on_attach = function(_, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Navigation
  map('gd', vim.lsp.buf.definition,      'Go to definition')
  map('gy', vim.lsp.buf.type_definition, 'Go to type definition')
  map('gi', vim.lsp.buf.implementation,  'Go to implementation')
  map('gr', vim.lsp.buf.references,      'Find references')
  map('K',  vim.lsp.buf.hover,           'Hover documentation')

  -- Refactoring
  map('<Leader>rn', vim.lsp.buf.rename,       'Rename symbol')
  map('<Leader>a',  vim.lsp.buf.code_action,  'Code action')
  map('<Leader>f',  function()
    vim.lsp.buf.format({ async = true })
  end, 'Format buffer')

  -- ESLint fix-all
  map('<Leader>ef', function()
    vim.lsp.buf.code_action({
      context = { only = { 'source.fixAll.eslint' } },
      apply   = true,
    })
  end, 'ESLint fix all')

  -- Diagnostics
  map('[g', vim.diagnostic.goto_prev, 'Previous diagnostic')
  map(']g', vim.diagnostic.goto_next, 'Next diagnostic')

  -- Diagnostic float on cursor
  map('<Leader>da', ':Telescope diagnostics<CR>', 'All diagnostics')
end

return {
  -- Mason: installs LSP server binaries
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({ ui = { border = 'rounded' } })
    end,
  },

  -- Bridge: mason + nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',    -- TypeScript / JavaScript
          'html',
          'cssls',
          'jsonls',
          'eslint',
          'jdtls',   -- Java
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: configure each server
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig    = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Servers with default config
      local servers = { 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint' }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach    = on_attach,
          capabilities = capabilities,
        })
      end

      -- Java (jdtls) — basic setup via mason-lspconfig auto-handler
      -- For advanced Java support (project-level config), see nvim-jdtls plugin
      lspconfig.jdtls.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      -- Diagnostic display config
      vim.diagnostic.config({
        virtual_text   = true,
        signs          = true,
        underline      = true,
        update_in_insert = false,
        severity_sort  = true,
        float = { border = 'rounded', source = 'always' },
      })
    end,
  },

  -- Completion engine
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp     = require('cmp')
      local luasnip = require('luasnip')

      -- Load VSCode-style snippets from friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Note: autopairs/cmp integration is handled in editor.lua (nvim-autopairs config)

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<CR>']    = cmp.mapping.confirm({ select = true }),
          ['<M-Space>'] = cmp.mapping.complete(),
          ['<C-b>']   = cmp.mapping.scroll_docs(-4),
          ['<C-f>']   = cmp.mapping.scroll_docs(4),
          ['<C-e>']   = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- Formatter (replaces coc-prettier)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          javascript      = { 'prettier' },
          typescript      = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          html            = { 'prettier' },
          css             = { 'prettier' },
          json            = { 'prettier' },
          java            = { 'google-java-format' },
        },
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add lua/plugins/lsp.lua
git commit -m "feat: add lua/plugins/lsp.lua (mason, nvim-lspconfig, nvim-cmp, conform)"
```

---

## Task 12: First boot — verify the new config loads

At this point `init.lua` and all `lua/` files exist alongside the old `init.vim`. Neovim loads `init.lua` when both exist, so the old files are ignored but not yet deleted.

- [ ] **Step 1: Open Neovim**

```bash
nvim
```

Expected: lazy.nvim opens its installation UI and downloads all plugins. Wait for it to finish (watch the progress bar).

- [ ] **Step 2: Check lazy.nvim**

Inside Neovim:
```
:Lazy
```
Expected: all plugins listed with green checkmarks, no errors.

- [ ] **Step 3: Check Mason**

```
:Mason
```
Expected: Mason UI opens. Wait for `ts_ls`, `html`, `cssls`, `jsonls`, `eslint`, `jdtls` to finish installing.

- [ ] **Step 4: Check health**

```
:checkhealth
```
Expected: no ERROR lines for treesitter, lsp, or telescope. Warnings about optional tools are OK.

- [ ] **Step 5: Open a TypeScript file and verify LSP**

```bash
nvim /tmp/test.ts
```

Type `const x: ` and wait ~2 seconds. Expected: nvim-cmp completion popup appears with type suggestions.

```
:LspInfo
```
Expected: shows `ts_ls` as active client.

- [ ] **Step 6: Commit checkpoint**

```bash
cd /Users/yduran/nvim
git commit --allow-empty -m "chore: first boot verified — lua config working"
```

---

## Task 13: Remove legacy VimScript files

Only do this after Task 12 passes successfully.

- [ ] **Step 1: Delete legacy files**

```bash
cd /Users/yduran/nvim
rm init.vim
rm plugins.vim
rm plugins-config.vim
rm lua-plugins.vim
rm coc-config.vim
rm coc-settings.json
rm maps.vim
```

- [ ] **Step 2: Remove old plugged/ directory (vim-plug plugins)**

```bash
rm -rf /Users/yduran/nvim/plugged
```

- [ ] **Step 3: Open Neovim and confirm still works**

```bash
nvim
```
Expected: opens cleanly, no errors about missing files.

- [ ] **Step 4: Commit**

```bash
cd /Users/yduran/nvim
git add -A
git commit -m "chore: remove legacy VimScript config files and plugged/ directory"
```

---

## Task 14: Rewrite KEYMAPS.md

**Files:**
- Rewrite: `KEYMAPS.md`

- [ ] **Step 1: Write KEYMAPS.md**

Replace the entire file with:

```markdown
# Neovim Keymaps Reference

**Leader key:** `Space`

---

## Navigation

| Keymap | Action |
|---|---|
| `<Leader>-` | Jump back (cursor history) |
| `<Leader>=` | Jump forward (cursor history) |
| `<C-j>` | Scroll down 10 lines |
| `<C-k>` | Scroll up 10 lines |
| `<Leader>s` | EasyMotion 2-char jump |
| `K` (visual) | Move selection up |
| `J` (visual) | Move selection down |

---

## File Explorer (nvim-tree)

| Keymap | Action |
|---|---|
| `<Leader>e` | Toggle explorer + reveal current file |
| `<Leader>E` | Toggle explorer |
| `:tree` | Alias for `:NvimTreeToggle` |
| `:find` | Alias for `:NvimTreeFindFile` |

---

## Fuzzy Search (Telescope)

| Keymap | Action |
|---|---|
| `<Leader>p` | Find files |
| `<Leader>rg` | Live grep (ripgrep) |
| `<Leader>gs` | Search workspace |
| `<Leader>bf` | List open buffers |

---

## LSP (active when language server is attached)

| Keymap | Action |
|---|---|
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Hover documentation |
| `<Leader>rn` | Rename symbol |
| `<Leader>a` | Code action |
| `<Leader>f` | Format buffer |
| `<Leader>ef` | ESLint fix all |
| `[g` | Previous diagnostic |
| `]g` | Next diagnostic |
| `<Leader>da` | All diagnostics (Telescope) |
| `<Leader>pi` | Peek implementation |

---

## Git

| Keymap | Action |
|---|---|
| `<Leader>gg` | LazyGit TUI |
| `<Leader>G` | Fugitive status (`:G`) |
| `<Leader>gp` | Git push |
| `<Leader>gl` | Git pull |
| `<Leader>gc` | Git commit (opens message prompt) |
| `<Leader>gr` | Git rebase -i |
| `<Leader>gd` | DiffviewOpen |
| `<Leader>gh` | DiffviewFileHistory (current file) |
| `<Leader>gm` | DiffviewOpen HEAD..MERGE_HEAD |
| `<Leader>gx` | DiffviewClose |
| `<Leader>gb` | Toggle inline git blame |
| `[c` | Previous git hunk |
| `]c` | Next git hunk |
| `<Leader>ghs` | Stage hunk |
| `<Leader>ghr` | Reset hunk |
| `<Leader>ghp` | Preview hunk |
| `:blame` | Alias for `:Gblame` |
| `:diff` | Alias for `:Gdiff` |

---

## Terminal

| Keymap | Action |
|---|---|
| `<C-\>` | Toggle horizontal terminal |
| `<Leader>tf` | Open floating terminal |
| `<Leader>ai` | Open Claude Code terminal (floating) |

---

## Buffers

| Keymap | Action |
|---|---|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<A-Right>` | Next buffer |
| `<A-Left>` | Previous buffer |
| `<Leader>bd` | Delete buffer |
| `<Leader>bD` | Force delete buffer |
| `<Leader><F4>` | Wipe buffer |

---

## Editor

| Keymap | Action |
|---|---|
| `<C-_>` (Ctrl+/) | Toggle comment (normal + visual) |
| `<C-c>` (visual) | Copy to clipboard |
| `<Leader>;` | Append `;` at end of line |
| `<Leader>h` | Resize split left (–20) |
| `<Leader>l` | Resize split right (+20) |
| `<M-Space>` | Trigger completion manually |

---

## Save / Quit

| Keymap | Action |
|---|---|
| `<Leader>w` | Save |
| `<Leader>q` | Quit |
| `<Leader>Q` | Force quit |
| `<Leader>ur` | Reload file from disk |
| `<Leader>so` | Reload config (`init.lua`) |

---

## String Case Conversion

| Keymap | Action |
|---|---|
| `<Leader>Cc` | Convert to camelCase |
| `<Leader>Ck` | Convert to dash-case |
| `<Leader>CC` | Convert to CONSTANT_CASE |
| `<Leader>Cu` | Convert to snake_case |

Works in normal mode (current word) and visual mode (selection).

---

## Tmux Navigator

| Keymap | Action |
|---|---|
| `<Leader><C-h>` | Navigate to tmux pane left |
| `<Leader><C-j>` | Navigate to tmux pane down |
| `<Leader><C-k>` | Navigate to tmux pane up |
| `<Leader><C-l>` | Navigate to tmux pane right |

---

## Language-Specific

| Keymap | Action |
|---|---|
| `<Leader>x` | Run current file with Node.js |
| `<Leader>jt` | Run Java test with Maven (finds nearest pom.xml) |
```

- [ ] **Step 2: Commit**

```bash
cd /Users/yduran/nvim
git add KEYMAPS.md
git commit -m "docs: rewrite KEYMAPS.md for modern Lua config"
```

---

## Task 15: Final verification

- [ ] **Step 1: Full health check**

```bash
nvim +"checkhealth" +qa 2>&1 | grep -E "ERROR|WARNING" | head -20
```

Review any ERRORs and fix them before proceeding.

- [ ] **Step 2: Verify LSP on TypeScript file**

```bash
echo 'const greet = (name: string): string => `Hello, ${name}!`;' > /tmp/verify.ts
nvim /tmp/verify.ts
```

Inside nvim:
- Type `greet(` — expect signature help popup
- Press `gd` on `string` — expect hover or definition
- Run `:LspInfo` — expect `ts_ls` listed as active
- Run `:Mason` — expect all 6 servers installed

- [ ] **Step 3: Verify Telescope**

```
:Telescope find_files
```
Expected: fuzzy file picker opens with preview.

- [ ] **Step 4: Verify treesitter**

```
:TSBufInfo
```
Expected: shows active parser for current filetype.

- [ ] **Step 5: Verify git signs**

Open any file tracked by git. Expected: `+`, `~`, `_` signs appear in the gutter next to changed lines.

- [ ] **Step 6: Final commit**

```bash
cd /Users/yduran/nvim
git commit --allow-empty -m "chore: modernization complete — pure Lua config verified"
```
