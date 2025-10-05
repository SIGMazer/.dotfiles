-- Modern LSP configuration for Neovim 0.11+
-- Migrated from deprecated lsp-zero v1.x

-- LSP key mappings
local function on_attach(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

-- Get completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure diagnostic signs
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

-- Enable TypeScript/JavaScript LSP
vim.lsp.enable({
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Enable Rust Analyzer
vim.lsp.enable({
  name = 'rust_analyzer',
  cmd = { 'rust-analyzer' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Enable Lua Language Server
vim.lsp.enable({
  name = 'lua_ls',
  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    }
  }
})

-- Enable Clangd
vim.lsp.enable({
  name = 'clangd',
  cmd = { "clangd", "--compile-commands-dir=." },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Enable OmniSharp for C#
vim.lsp.enable({
    name = 'omnisharp',
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    root_markers = { "*.csproj", "*.sln", ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        -- sdk = {
        --     path = "/home/sigmazer/.dotnet/sdk/6.0.424/"
        -- },
    }
})

-- Enable Java LSP
vim.lsp.enable({
  name = 'jdtls',
  cmd = { 'jdtls' },
  root_markers = { 'pom.xml', 'build.gradle', '.git' },
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.set_log_level("ERROR")
vim.lsp.set_log_level("ERROR")

