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
