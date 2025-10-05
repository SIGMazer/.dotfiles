-- Mason configuration for LSP server management
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",           -- TypeScript/JavaScript
        "rust_analyzer",   -- Rust
        "lua_ls",          -- Lua
        "clangd",          -- C/C++
        "jdtls",           -- Java
    },
    automatic_installation = true,
})
