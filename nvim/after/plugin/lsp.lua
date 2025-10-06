-- LSP configuration using native vim.lsp.config (Neovim 0.11+)
-- Modern approach without deprecated lspconfig framework

local function on_attach(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  
  -- Disable some LSP features that can conflict with Copilot
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    -- Reduce aggressive completion that can cause conflicts
    client.server_capabilities.completionProvider.resolveProvider = false
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    }
  }
})

-- LSP servers are now configured with lazy loading below

-- Lazy loading system - only start LSP when file type matches
local function setup_lazy_lsp()
  -- Create autocmd to start LSP servers only when needed
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
      -- Only start ts_ls if not already running
      local clients = vim.lsp.get_clients({ name = "ts_ls" })
      if #clients == 0 then
        vim.lsp.start({
          name = "ts_ls",
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }, { upward = true })[1]),
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            typescript = {
              suggest = { completeFunctionCalls = false },
              diagnostics = { ignoredCodes = { 80001 } },
            },
            javascript = {
              suggest = { completeFunctionCalls = false },
              diagnostics = { ignoredCodes = { 80001 } },
            },
          },
          debounce_text_changes = 150,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
      local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
      if #clients == 0 then
        vim.lsp.start({
          name = "rust_analyzer",
          cmd = { 'rust-analyzer' },
          filetypes = { 'rust' },
          root_dir = vim.fs.dirname(vim.fs.find({ 'Cargo.toml', 'rust-project.json', '.git' }, { upward = true })[1]),
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
      local clients = vim.lsp.get_clients({ name = "lua_ls" })
      if #clients == 0 then
        vim.lsp.start({
          name = "lua_ls",
          cmd = { 'lua-language-server' },
          filetypes = { 'lua' },
          root_dir = vim.fs.dirname(vim.fs.find({ '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' }, { upward = true })[1]),
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function()
      local clients = vim.lsp.get_clients({ name = "clangd" })
      if #clients == 0 then
        vim.lsp.start({
          name = "clangd",
          cmd = { 'clangd' },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
          root_dir = vim.fs.dirname(vim.fs.find({ 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' }, { upward = true })[1]),
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      local clients = vim.lsp.get_clients({ name = "pyright" })
      if #clients == 0 then
        vim.lsp.start({
          name = "pyright",
          cmd = { 'pyright-langserver', '--stdio' },
          filetypes = { 'python' },
          root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'setup.py', 'requirements.txt', 'Pipfile', '.git' }, { upward = true })[1]),
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        })
      end
    end,
  })
end

-- Initialize lazy loading
setup_lazy_lsp()

-- Set LSP log level to INFO for better debugging
vim.lsp.set_log_level("INFO")

-- Add commands to manage LSP log level
vim.api.nvim_create_user_command("LspLogLevel", function(opts)
  local level = opts.args or "INFO"
  vim.lsp.set_log_level(level:upper())
  vim.notify("LSP log level set to: " .. level:upper(), vim.log.levels.INFO)
end, { nargs = "?", desc = "Set LSP log level (OFF, ERROR, WARN, INFO, DEBUG, TRACE)" })

-- Add command to check LSP status
vim.api.nvim_create_user_command("LspStatus", function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    vim.notify("No LSP clients are currently running", vim.log.levels.INFO)
  else
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    vim.notify("Active LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
  end
end, { desc = "Show current LSP client status" })

-- Add command to stop all LSP servers
vim.api.nvim_create_user_command("LspStopAll", function()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name ~= "copilot" then -- Don't stop Copilot
      vim.lsp.stop_client(client.id)
    end
  end
  vim.notify("Stopped all LSP servers (except Copilot)", vim.log.levels.INFO)
end, { desc = "Stop all LSP servers except Copilot" })

