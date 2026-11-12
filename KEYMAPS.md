# Neovim Keymaps Reference

**Leader key:** `Space`

> Generated for the modern Lua config (lazy.nvim + native LSP + Telescope)

---

## Save / Quit

| Keymap | Action |
|---|---|
| `<Leader>w` | Save file |
| `<Leader>q` | Quit |
| `<Leader>Q` | Force quit |
| `<Leader>ur` | Reload file from disk |
| `<Leader>so` | Reload config (`init.lua`) |

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
| `<Leader>bf` | List open buffers |
| `<Leader>fs` | Find files (alternate) |

---

## LSP (active when a language server is attached)

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
| `<Leader>ai` | Open Claude Code terminal (floating, 90% screen) |

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
| `<Leader>h` | Resize split left (−20 cols) |
| `<Leader>l` | Resize split right (+20 cols) |
| `<M-Space>` | Trigger completion manually |

---

## String Case Conversion

Works on current word (normal mode) or selection (visual mode).

| Keymap | Action |
|---|---|
| `<Leader>Cc` | Convert to camelCase |
| `<Leader>Ck` | Convert to dash-case |
| `<Leader>CC` | Convert to CONSTANT_CASE |
| `<Leader>Cu` | Convert to snake_case |

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
