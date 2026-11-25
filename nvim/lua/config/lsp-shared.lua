local M = {}

local function pick_references()
  vim.lsp.buf.references(nil, {
    on_list = function(list)
      local what = { title = list.title, items = list.items, context = list.context }
      vim.fn.setqflist({}, ' ', what)
      local id = vim.fn.getqflist({ id = 0 }).id
      local actions = require('telescope.actions')

      require('telescope.builtin').quickfix({
        id = id,
        prompt_title = 'Referencias',
        layout_config = { width = 0.9, preview_cutoff = 50 },
        trim_text = true,
        attach_mappings = function(prompt, map)
          map('i', '<Esc>', actions.close)
          actions.select_default:replace(function()
            local entry = require('telescope.actions.state').get_selected_entry()
            if not entry then return end
            actions.close(prompt)

            -- Jump once Telescope has left Insert mode so the byte column is retained.
            vim.schedule(function()
              if vim.fn.getqflist({ id = 0 }).id ~= id then
                local nr = vim.fn.getqflist({ id = id, nr = 0 }).nr
                if nr > 0 then
                  vim.cmd.chistory({ count = nr, mods = { silent = true } })
                else
                  vim.fn.setqflist({}, ' ', what)
                end
              end
              vim.cmd.cc({ count = entry.index, mods = { silent = true } })
            end)
          end)
          return true
        end,
      })
    end,
  })
end

function M.setup()
  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('IdeLsp', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      local function map(mode, keys, action, desc)
        vim.keymap.set(mode, keys, action, { buffer = event.buf, desc = desc })
      end

      map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
      map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
      map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
      map('n', 'grr', pick_references, 'Find references with preview')
      map('n', '<Leader>rh', function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end, 'Highlight symbol references in this file')
      map('n', '<Leader>rn', vim.lsp.buf.rename, 'Rename symbol')
      map({ 'n', 'x' }, '<Leader>a', vim.lsp.buf.code_action, 'Code action')

      if client:supports_method('textDocument/completion', event.buf) then
        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        map('i', '<M-Space>', vim.lsp.completion.get, 'Show LSP completions')
      end
      if client.name == 'jdtls' or client:supports_method('textDocument/inlayHint', event.buf) then
        local buffer = { bufnr = event.buf }
        vim.lsp.inlay_hint.enable(true, buffer)
        map('n', '<Leader>uh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(buffer), buffer)
        end, 'Toggle inlay hints')
      end
      if client.name == 'eslint' then
        map('n', '<Leader>ef', '<Cmd>LspEslintFixAll<CR>', 'ESLint fix all')
      end
    end,
  })
end

return M
