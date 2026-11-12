# nvim-jdtls Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the basic `jdtls` LSP setup with `mfussenegger/nvim-jdtls` so that `gd` on any class from a library JAR opens a read-only buffer with decompiled source, matching IntelliJ's "Navigate to source" behavior.

**Architecture:** Extract shared `on_attach` / `capabilities` to `lua/config/lsp-shared.lua`. Modify `lua/plugins/lsp.lua` to import from the shared module and drop `jdtls` from `vim.lsp.enable`. Add `lua/plugins/java.lua` with the full nvim-jdtls config that detects Maven/Gradle project roots and starts the server per buffer.

**Tech Stack:** Neovim 0.11+, lazy.nvim, `mfussenegger/nvim-jdtls`, Mason (jdtls binary), `cmp_nvim_lsp`

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `lua/config/lsp-shared.lua` | Exports `on_attach` keymaps and `capabilities()` factory |
| Modify | `lua/plugins/lsp.lua` | Import shared module; remove `jdtls` from `vim.lsp.enable` |
| Create | `lua/plugins/java.lua` | nvim-jdtls lazy spec with Maven+Gradle root detection |

---

## Task 1: Extract shared LSP config

**Files:**
- Create: `lua/config/lsp-shared.lua`

> Note: This is a Neovim config project — there are no unit tests. Verification is done by opening Neovim and confirming behavior.

- [ ] **Step 1: Create `lua/config/lsp-shared.lua`**

```lua
-- lua/config/lsp-shared.lua
-- Shared LSP on_attach and capabilities used by lsp.lua and java.lua

local M = {}

M.on_attach = function(_, bufnr)
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
  map('<Leader>rn', vim.lsp.buf.rename,      'Rename symbol')
  map('<Leader>a',  vim.lsp.buf.code_action, 'Code action')
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
  map('<Leader>da', ':Telescope diagnostics<CR>', 'All diagnostics')
end

-- Called as a function to avoid load-order issues with cmp_nvim_lsp
function M.capabilities()
  return require('cmp_nvim_lsp').default_capabilities()
end

return M
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/lsp-shared.lua
git commit -m "refactor: extract shared LSP on_attach and capabilities"
```

---

## Task 2: Update lsp.lua to use shared module

**Files:**
- Modify: `lua/plugins/lsp.lua`

- [ ] **Step 1: Replace the local `on_attach` definition and `capabilities` variable**

In `lua/plugins/lsp.lua`, replace lines 3–37 (the local `on_attach` function) with:

```lua
-- lua/plugins/lsp.lua

local shared = require('config.lsp-shared')
```

- [ ] **Step 2: Update the `vim.lsp.config('*', ...)` call**

Change:
```lua
vim.lsp.config('*', {
  on_attach    = on_attach,
  capabilities = capabilities,
})
```

To:
```lua
vim.lsp.config('*', {
  on_attach    = shared.on_attach,
  capabilities = shared.capabilities(),
})
```

- [ ] **Step 3: Remove `jdtls` from `vim.lsp.enable`**

Change:
```lua
vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint', 'jdtls' })
```

To:
```lua
vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint' })
```

Leave `'jdtls'` in `mason-lspconfig`'s `ensure_installed` — Mason still needs to install the binary.

- [ ] **Step 4: Verify the full updated file looks like this**

```lua
-- lua/plugins/lsp.lua

local shared = require('config.lsp-shared')

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
          'jdtls',   -- Java (binary only; server started by nvim-jdtls)
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: configure each server (Neovim 0.11+ API)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      vim.lsp.config('*', {
        on_attach    = shared.on_attach,
        capabilities = shared.capabilities(),
      })

      vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls', 'eslint' })

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

      require('luasnip.loaders.from_vscode').lazy_load()

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

          ['<CR>']      = cmp.mapping.confirm({ select = true }),
          ['<M-Space>'] = cmp.mapping.complete(),
          ['<C-b>']     = cmp.mapping.scroll_docs(-4),
          ['<C-f>']     = cmp.mapping.scroll_docs(4),
          ['<C-e>']     = cmp.mapping.abort(),
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

- [ ] **Step 5: Open Neovim and verify TypeScript LSP still works**

Open any `.ts` or `.js` file. Run `:LspInfo` — should show `ts_ls` attached. Press `K` on a symbol — hover doc should appear.

- [ ] **Step 6: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "refactor: use shared LSP config, remove jdtls from vim.lsp.enable"
```

---

## Task 3: Add nvim-jdtls plugin

**Files:**
- Create: `lua/plugins/java.lua`

- [ ] **Step 1: Create `lua/plugins/java.lua`**

```lua
-- lua/plugins/java.lua

return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      local jdtls  = require('jdtls')
      local shared = require('config.lsp-shared')

      local function make_config()
        local root_dir = require('jdtls.setup').find_root({
          'pom.xml', 'build.gradle', 'build.gradle.kts', '.git',
        }) or vim.fn.getcwd()

        local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/'
          .. vim.fn.fnamemodify(root_dir, ':t')

        return {
          cmd         = { vim.fn.stdpath('data') .. '/mason/bin/jdtls', '-data', workspace_dir },
          root_dir    = root_dir,
          on_attach   = shared.on_attach,
          capabilities = shared.capabilities(),
          settings = {
            java = {
              configuration = {
                runtimes = {},
              },
            },
          },
        }
      end

      -- Handle Java buffers opened after the plugin loads
      vim.api.nvim_create_autocmd('FileType', {
        pattern  = 'java',
        callback = function()
          jdtls.start_or_attach(make_config())
        end,
      })

      -- Handle the buffer that triggered the plugin load
      jdtls.start_or_attach(make_config())
    end,
  },
}
```

- [ ] **Step 2: Install the plugin**

Open Neovim and run:
```
:Lazy sync
```

Wait for `nvim-jdtls` to appear in the installed list. Close Neovim.

- [ ] **Step 3: Open a Java file and verify the server attaches**

Open any `.java` file in a Maven or Gradle project. Run:
```
:LspInfo
```

Expected: `jdtls` listed as attached to the buffer. JDT.LS may take 30–60 seconds on first open (it's indexing the project).

- [ ] **Step 4: Verify decompiled source navigation**

In the same Java file, place cursor on a standard library class (e.g. `String`, `List`, `HashMap`). Press `gd`.

Expected: a new read-only buffer opens named something like `jdt://contents/java.base/java.lang/String.class?...=<jdt uri>` showing decompiled source. You can navigate further with `gd` inside that buffer.

- [ ] **Step 5: Verify Maven root detection**

In a Maven project (has `pom.xml`), run:
```vim
:lua print(require('jdtls.setup').find_root({'pom.xml','build.gradle','build.gradle.kts','.git'}))
```

Expected: prints the directory containing `pom.xml`, not just the current file's directory.

- [ ] **Step 6: Verify Gradle root detection**

In a Gradle project (has `build.gradle` or `build.gradle.kts`), run the same command. Expected: prints the directory containing the Gradle file.

- [ ] **Step 7: Verify existing keymaps still work in Java**

With a Java file open and `jdtls` attached:
- `K` → hover doc appears
- `gr` → references shown in Telescope/quickfix
- `<Leader>rn` → rename prompt appears
- `<Leader>jt` → Maven test runs (existing keybinding, unrelated to jdtls)

- [ ] **Step 8: Commit**

```bash
git add lua/plugins/java.lua
git commit -m "feat: add nvim-jdtls for decompiled source navigation"
```

---

## Verification Summary

| Check | How |
|-------|-----|
| `gd` opens decompiled JAR class | Press `gd` on `String` or any dependency class |
| TypeScript LSP unaffected | `:LspInfo` in a `.ts` file shows `ts_ls` |
| Maven root found | `:lua print(require('jdtls.setup').find_root({...}))` in Maven project |
| Gradle root found | Same command in Gradle project |
| All Java keymaps work | `K`, `gr`, `<Leader>rn` in a Java buffer |
