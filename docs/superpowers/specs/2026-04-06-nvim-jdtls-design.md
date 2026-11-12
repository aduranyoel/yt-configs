# nvim-jdtls Integration — Design Spec

**Date:** 2026-04-06  
**Goal:** Enable navigation to decompiled library/JAR code (like IntelliJ's "Navigate to source") by replacing the basic `jdtls` setup with `mfussenegger/nvim-jdtls`.

---

## Problem

The current setup enables `jdtls` via `vim.lsp.enable('jdtls')`. When `gd` is pressed on a class from a dependency JAR, JDT.LS returns a `jdt://` URI that Neovim cannot open by default — the navigation silently fails or errors. `nvim-jdtls` registers a handler for this URI scheme and opens a read-only buffer with the decompiled source.

---

## Architecture

Three files are touched:

| File | Change |
|------|--------|
| `lua/config/lsp-shared.lua` | **New.** Exports `on_attach` and `capabilities` |
| `lua/plugins/lsp.lua` | Import shared module; remove `jdtls` from `vim.lsp.enable` |
| `lua/plugins/java.lua` | **New.** Full `nvim-jdtls` configuration |

---

## `lua/config/lsp-shared.lua`

Extracts the two values that both `lsp.lua` and `java.lua` need:

- `M.on_attach(_, bufnr)` — the existing keymaps (`gd`, `gy`, `gi`, `gr`, `K`, `<Leader>rn`, `<Leader>a`, `<Leader>f`, `<Leader>ef`, `[g`, `]g`, `<Leader>da`)
- `M.capabilities` — built from `require('cmp_nvim_lsp').default_capabilities()`

---

## `lua/plugins/lsp.lua`

Two changes only:

1. Replace the local `on_attach` / `capabilities` definitions with `require('config.lsp-shared')`.
2. Remove `'jdtls'` from the `vim.lsp.enable(...)` call. Keep it in `mason-lspconfig`'s `ensure_installed` so Mason still downloads the binary.

---

## `lua/plugins/java.lua`

Lazy spec: `{ 'mfussenegger/nvim-jdtls', ft = 'java', ... }`

### Root dir detection

Uses `require('jdtls.setup').find_root()` with markers searched in priority order:
`pom.xml`, `build.gradle`, `build.gradle.kts`, `.git`

Falls back to `vim.fn.getcwd()` if none found (bare file editing).

### Workspace dir

Each project gets an isolated workspace to avoid index conflicts:

```
~/.local/share/nvim/jdtls-workspace/<project-name>
```

where `<project-name>` is the tail of `root_dir`.

### Server command

Mason installs the binary at `~/.local/share/nvim/mason/bin/jdtls`:

```lua
cmd = { vim.fn.stdpath('data') .. '/mason/bin/jdtls', '-data', workspace_dir }
```

### `start_or_attach` trigger

An `autocmd FileType java` inside the `config` function calls `jdtls.start_or_attach(config)`. This handles:
- The first Java file opened (lazy.nvim fires FileType to load the plugin, then the autocmd fires)
- Subsequent Java buffers in the same session

### Inherited config

Passes `on_attach` and `capabilities` from `lsp-shared` so Java buffers get the same keymaps and completion capabilities as every other language.

### Java settings

Minimal settings block — only what's needed now:

```lua
settings = {
  java = {
    configuration = {
      runtimes = {},  -- auto-detected by jdtls
    },
  },
}
```

No Lombok, no bundles, no test adapters — YAGNI. These can be added later.

---

## What does NOT change

- `<Leader>jt` Maven test runner in `keymaps.lua` — stays as-is.
- All other LSP servers — unaffected.
- Mason install list — `jdtls` remains in `ensure_installed`.
- `conform.nvim` `google-java-format` — unaffected.

---

## Success criteria

1. `gd` on a class from `java.util`, Spring, or any Maven/Gradle dependency opens a read-only buffer with decompiled source.
2. All existing LSP keymaps work in Java files (`gd`, `gr`, `K`, etc.).
3. No regressions in TypeScript, HTML, CSS, or other LSP servers.
4. Project root is correctly detected for both `pom.xml` and `build.gradle` projects.
