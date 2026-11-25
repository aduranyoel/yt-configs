local function refresh_java_hints(err, params, ctx)
  local reply = vim.lsp.handlers['client/registerCapability'](err, params, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and vim.iter(params.registrations):any(function(registration)
    return registration.method == 'textDocument/inlayHint'
  end) then
    for bufnr in pairs(client.attached_buffers) do
      local buffer = { bufnr = bufnr }
      if vim.lsp.inlay_hint.is_enabled(buffer) then
        vim.lsp.inlay_hint.enable(true, buffer)
      end
    end
  end
  return reply
end

return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      local jdtls = require('jdtls')
      local markers = {
        { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts' },
        { 'pom.xml', 'build.gradle', 'build.gradle.kts' },
        '.git',
      }

      local function start(event)
        if vim.fn.executable('jdtls') ~= 1 then
          vim.notify_once('Instalá JDTLS con :MasonInstall jdtls y volvé a abrir el archivo.', vim.log.levels.WARN)
          return
        end

        local root = vim.fs.root(event.buf, markers) or vim.fs.dirname(event.file) or vim.uv.cwd()
        root = vim.uv.fs_realpath(root) or root
        local workspace = vim.fn.stdpath('data') .. '/jdtls-workspace/'
          .. vim.fs.basename(root) .. '-' .. vim.fn.sha256(root):sub(1, 12)

        jdtls.start_or_attach({
          cmd = { 'jdtls', '-data', workspace },
          root_dir = root,
          handlers = { ['client/registerCapability'] = refresh_java_hints },
          settings = {
            java = { inlayHints = { parameterNames = { enabled = 'literals' } } },
          },
        })
      end

      -- Lazy replays FileType for the buffer that caused this plugin to load.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('IdeJava', { clear = true }),
        pattern = 'java',
        callback = start,
      })
    end,
  },
}
