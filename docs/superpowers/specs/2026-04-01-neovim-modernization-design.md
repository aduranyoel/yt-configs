# Neovim Modernization Design

**Date:** 2026-04-01
**Status:** Approved

## Overview

Full rewrite of the Neovim configuration from a VimScript + embedded Lua hybrid into a pure Lua, fully modern setup styled as a complete IDE. Replaces vim-plug with lazy.nvim, CoC.nvim with native LSP (mason + nvim-lspconfig + nvim-cmp), and fzf with Telescope.

## Architecture

```
nvim/
├── init.lua                  ← entry point: bootstraps lazy.nvim, loads config/ and plugins/
└── lua/
    ├── config/
    │   ├── options.lua       ← all vim options (no more init.vim)
    │   ├── keymaps.lua       ← all keymaps consolidated (no duplicates)
    │   └── autocmds.lua      ← autocommands
    └── plugins/
        ├── ui.lua            ← theme, lualine, bufferline, nvim-tree, ibl, colorizer
        ├── editor.lua        ← autopairs, surround, comment, multicursor, easymotion, smoothie
        ├── lsp.lua           ← mason, mason-lspconfig, nvim-lspconfig, nvim-cmp, LuaSnip
        ├── git.lua           ← lazygit, diffview, fugitive, rhubarb, gv.vim, gitsigns
        └── tools.lua         ← telescope, toggleterm, tmux-navigator, text-case, editorconfig
```

`init.lua` responsibilities:
1. Bootstrap lazy.nvim (download if not present)
2. `require('config.options')`
3. `require('config.keymaps')`
4. `require('config.autocmds')`
5. `require('lazy').setup('plugins')` — auto-discovers all files in `lua/plugins/`

## Plugin Changes

### Replacements

| Current | Replacement | Reason |
|---|---|---|
| vim-plug | **lazy.nvim** | Lazy-loading, faster startup, modern UI |
| vim-polyglot | **nvim-treesitter** | Superior syntax highlighting, enables ts-autotag etc. |
| vim-signify | **gitsigns.nvim** | Pure Lua, faster, includes inline blame |
| nerdcommenter | **Comment.nvim** | Pure Lua, treesitter-aware |
| vim-closetag | **nvim-ts-autotag** | Treesitter-based, supports more filetypes |
| fzf + fzf.vim | **telescope.nvim** | Native Neovim, better previews, extensible |
| coc.nvim | **mason + nvim-lspconfig + nvim-cmp** | Native LSP, no Node.js dependency |
| auto-pairs | **nvim-autopairs** | Pure Lua, nvim-cmp integration |

### Retained

- `onedark.nvim`, `lualine`, `bufferline.nvim`, `nvim-tree`, `indent-blankline`
- `toggleterm.nvim`, `lazygit.nvim`, `diffview.nvim`
- `vim-fugitive`, `vim-rhubarb`, `gv.vim`
- `vim-surround`, `vim-visual-multi`, `vim-easymotion`
- `vim-tmux-navigator`, `text-case.nvim`, `editorconfig-vim`, `vim-smoothie`
- `nvim-web-devicons`, `nvim-colorizer.lua`, `plenary.nvim`

## LSP Stack

Three layers replacing CoC:

**mason.nvim** — auto-installs and manages LSP server binaries. Servers configured for auto-install:
- `ts_ls` (TypeScript/JavaScript)
- `jdtls` (Java)
- `html`, `cssls`, `jsonls`
- `eslint`

**nvim-lspconfig** — connects installed servers to Neovim buffers via `on_attach`.

**nvim-cmp** — completion engine with sources:
- `cmp-nvim-lsp` — LSP completions
- `cmp-buffer` — words from current buffer
- `cmp-path` — file paths
- `LuaSnip` + `friendly-snippets` — snippets

Prettier formatting via **conform.nvim** — the modern Lua-native formatter plugin. Configured to run `prettier` on JS/TS/JSX/TSX/HTML/CSS/JSON and `google-java-format` on Java.

## Keymaps

### Strategy
- All general keymaps live in `lua/config/keymaps.lua`
- LSP keymaps defined inside `on_attach` in `lua/plugins/lsp.lua` (active only when LSP is attached)
- No duplicates — current duplicates between `maps.vim` and `coc-config.vim` are eliminated

### LSP Keymaps (on_attach)

| Action | Keymap |
|---|---|
| Go to definition | `gd` |
| Go to type definition | `gy` |
| Go to implementation | `gi` |
| Find references | `gr` |
| Hover documentation | `K` |
| Rename symbol | `<Leader>rn` |
| Code action | `<Leader>a` |
| Previous diagnostic | `[g` |
| Next diagnostic | `]g` |
| Format buffer | `<Leader>f` |
| ESLint fix | `<Leader>ef` |

### Telescope Keymaps (replaces FZF)

| Action | Keymap |
|---|---|
| Find files | `<Leader>p` |
| Live grep (ripgrep) | `<Leader>rg` |
| Search in workspace (CoC search replacement) | `<Leader>gs` |
| Open buffers | `<Leader>bf` |

### All Other Keymaps
Migrated 1:1 from `maps.vim` — same keys, same behavior, pure Lua syntax.

## Documentation

`KEYMAPS.md` is regenerated as part of this plan — full reference document with all keymaps organized by category:
- Navigation
- File Explorer
- Fuzzy Search (Telescope)
- LSP
- Git
- Terminal
- Editor
- Buffers
- String Case Conversion
- Tmux

## Setup Guide (New Machine)

Step-by-step to get a fully working IDE on a fresh machine.

### 1. System dependencies

**macOS (Homebrew):**
```bash
brew install neovim          # >= 0.10 required
brew install git
brew install ripgrep         # telescope live grep
brew install fd              # telescope file finder
brew install lazygit         # LazyGit TUI
brew install node            # required by some LSP servers (ts_ls, eslint)
brew install java            # Java 21+ required by jdtls (Java LSP)
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install neovim git ripgrep fd-find nodejs default-jdk
# lazygit: install from GitHub releases (no apt package)
```

**Verify Neovim version:**
```bash
nvim --version   # must be >= 0.10
```

### 2. Install a Nerd Font

Icons (nvim-tree, bufferline, lualine) require a patched font.

Recommended: **JetBrainsMono Nerd Font** or **FiraCode Nerd Font**

- Download from: https://www.nerdfonts.com/font-downloads
- Set it as your terminal font (iTerm2, Warp, Kitty, etc.)

### 3. Clone the config

The config lives at `~/.config/nvim` (standard Neovim XDG path):

```bash
git clone <your-repo-url> ~/.config/nvim
```

Or symlink if keeping the repo elsewhere:
```bash
ln -s /path/to/your/nvim ~/.config/nvim
```

### 4. First launch — let lazy.nvim do its work

```bash
nvim
```

On first launch:
1. lazy.nvim bootstraps itself automatically (no manual install needed)
2. All plugins are downloaded and installed
3. Treesitter parsers are compiled
4. Mason downloads LSP servers in the background

Wait for all installations to complete. You can check progress with `:Lazy` and `:Mason`.

### 5. Install LSP servers via Mason

Mason auto-installs configured servers on first open of a relevant file. To install everything upfront:

```
:MasonInstall ts_ls html cssls jsonls eslint jdtls
```

### 6. Install Treesitter parsers

```
:TSInstall javascript typescript tsx lua vim html css json java
```

### 7. Verify everything works

| Check | Command |
|---|---|
| Plugins loaded | `:Lazy` |
| LSP servers | `:Mason` |
| LSP active in buffer | `:LspInfo` |
| Treesitter active | `:TSBufInfo` |
| Health check | `:checkhealth` |

### Optional: prettier

For formatting to work, `prettier` must be available in the project or globally:
```bash
npm install -g prettier
```

### Optional: tmux integration

`vim-tmux-navigator` requires the tmux plugin as well. Add to `~/.tmux.conf`:
```
set -g @plugin 'christoomey/vim-tmux-navigator'
```
Then press `prefix + I` to install.

---

## Non-Goals

- No changes to the visual style (theme stays onedark darker)
- No changes to existing keymap assignments (same muscle memory)
- No additional languages beyond what CoC already supported
