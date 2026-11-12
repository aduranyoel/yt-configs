# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration styled after VS Code. Uses VimScript as the main structure with Lua blocks for modern plugins. Entry point is `init.vim`.

## Plugin Management

Plugins are managed with **vim-plug**. After adding/removing plugins in `plugins.vim`:

```vim
:PlugInstall   " Install new plugins
:PlugUpdate    " Update plugins
:PlugClean     " Remove unused plugins
```

CoC extensions are auto-installed via `g:coc_global_extensions` in `coc-config.vim`. To manage manually:
```vim
:CocInstall coc-tsserver
:CocUpdate
```

## Architecture

| File | Purpose |
|------|---------|
| `init.vim` | Entry point — options, sources all modules |
| `plugins.vim` | vim-plug declarations |
| `plugins-config.vim` | Plugin settings (sources `coc-config.vim` and `lua-plugins.vim`) |
| `lua-plugins.vim` | Lua configuration for VS Code-like plugins (theme, nvim-tree, lualine, bufferline, indent guides, terminal) |
| `coc-config.vim` | CoC.nvim LSP config + `g:coc_global_extensions` |
| `coc-settings.json` | CoC JSON settings (Java, Node.js, React, Prettier, ESLint) |
| `maps.vim` | All keybindings (leader = Space) |

## VS Code-like Features

| Feature | Plugin | Shortcut |
|---------|--------|----------|
| Theme | `Mofiqul/vscode.nvim` | — |
| File explorer | `nvim-tree/nvim-tree.lua` | `<Leader>e` (reveal), `<Leader>E` (toggle) |
| Tabs | `akinsho/bufferline.nvim` | `Tab` / `Shift+Tab` |
| Status bar | `nvim-lualine/lualine.nvim` | — |
| Integrated terminal | `akinsho/toggleterm.nvim` | `Ctrl+\` (horizontal), `<Leader>tf` (float) |
| Indent guides | `lukas-reineke/indent-blankline.nvim` | — |
| Comment toggle | `scrooloose/nerdcommenter` | `Ctrl+/` (`<C-_>`) |

## Autocompletion (CoC extensions)

| Language | Extension |
|----------|-----------|
| Java | `coc-java` (downloads Eclipse JDT.LS on first use — requires Java 21+) |
| Node.js / TypeScript | `coc-tsserver` |
| React (JSX/TSX) | `coc-tsserver` + `coc-react-refactor` |
| ESLint | `coc-eslint` |
| Prettier | `coc-prettier` |
| HTML / CSS / JSON | `coc-html`, `coc-css`, `coc-json` |
| Emmet | `coc-emmet` |

## Key Design Decisions

- `let g:loaded_netrw = 1` is set at the top of `init.vim` before any source — required by nvim-tree
- `set laststatus=3` enables the global statusline used by lualine
- `g:coc_global_extensions` in `coc-config.vim` auto-installs all LSP extensions on first launch
- All Lua plugin configs live in `lua-plugins.vim` to keep the VimScript/Lua boundary clear
