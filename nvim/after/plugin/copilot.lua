-- GitHub Copilot configuration using copilot.lua
-- This replaces the old copilot.vim plugin to fix range errors

-- Ensure old copilot.vim is completely disabled (but don't block new copilot.lua)
if vim.g.copilot_enabled ~= 0 then
  vim.g.copilot_enabled = 0
  vim.g.copilot_filetypes = {}
  vim.g.copilot_no_maps = 1
  vim.g.copilot_assume_mapped = 1
end

-- Only warn about old copilot but don't block the new one
if vim.g.loaded_copilot then
  vim.notify("Old copilot.vim detected alongside copilot.lua - this may cause conflicts", vim.log.levels.WARN)
end

require("copilot").setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 100,  -- Increased for better performance
    keymap = {
      accept = false,        -- Disable default accept (we'll handle it with Tab)
      accept_word = false,   -- Disable default accept_word
      accept_line = false,   -- Disable default accept_line
      next = false,          -- Disable default next
      prev = false,          -- Disable default prev
      dismiss = "<C-e>",     -- Use Ctrl+e for dismiss
    },
    -- Enhanced suggestion settings
    show_ghost_text = true,
    ghost_text = {
      hl_group = "CopilotSuggestion",
    },
  },
  filetypes = {
    -- Enable for common programming languages
    javascript = true,
    typescript = true,
    javascriptreact = true,
    typescriptreact = true,
    lua = true,
    python = true,
    rust = true,
    go = true,
    java = true,
    c = true,
    cpp = true,
    csharp = true,
    php = true,
    ruby = true,
    swift = true,
    kotlin = true,
    scala = true,
    html = true,
    css = true,
    scss = true,
    sass = true,
    less = true,
    json = true,
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})

-- LSP integration to prevent range errors
local original_handlers = vim.lsp.handlers

-- Create a safer LSP handler that prevents range errors
local function safe_lsp_handler(handler_name)
  return function(_, result, ctx, config)
    -- Add error handling and debouncing
    local success, err = pcall(function()
      vim.defer_fn(function()
        if original_handlers[handler_name] then
          original_handlers[handler_name](_, result, ctx, config)
        end
      end, 50) -- Increased delay to prevent rapid changes
    end)
    
    if not success then
      vim.notify("LSP handler error: " .. tostring(err), vim.log.levels.WARN)
    end
  end
end

-- Override problematic LSP handlers
vim.lsp.handlers = vim.tbl_extend("force", vim.lsp.handlers, {
  ["textDocument/didChange"] = safe_lsp_handler("textDocument/didChange"),
  ["textDocument/didOpen"] = safe_lsp_handler("textDocument/didOpen"),
  ["textDocument/didClose"] = safe_lsp_handler("textDocument/didClose"),
})

-- Configure TypeScript LSP to work better with Copilot
local function on_attach_copilot(client, bufnr)
  -- Disable some LSP features that can conflict with Copilot
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

-- Add the copilot-specific on_attach to existing LSP configs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach_copilot(client, args.buf)
  end,
})

-- Smart Tab for both Copilot and completion
vim.keymap.set("i", "<Tab>", function()
  local copilot = require("copilot.suggestion")
  local cmp = require("cmp")
  
  if copilot.is_visible() then
    -- If Copilot suggestion is visible, accept it
    copilot.accept()
  elseif cmp.visible() then
    -- If completion menu is visible, select next item
    cmp.select_next_item()
  else
    -- Check if we're at beginning of line or in whitespace for indentation
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    local is_whitespace_or_beginning = col == 0 or current_line:sub(1, col):match("^%s*$")
    
    if is_whitespace_or_beginning then
      -- Use for indentation
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    else
      -- Trigger completion if there are words before cursor
      local has_words = col ~= 0 and current_line:sub(col, col):match("%s") == nil
      if has_words then
        cmp.complete()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end
  end
end, { desc = "Smart Tab: Copilot accept, completion, or indent" })

-- Right arrow to accept Copilot suggestions
vim.keymap.set("i", "<Right>", function()
  local copilot = require("copilot.suggestion")
  
  if copilot.is_visible() then
    -- If Copilot suggestion is visible, accept it
    copilot.accept()
  else
    -- If no Copilot suggestion, move cursor right normally
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
  end
end, { desc = "Accept Copilot suggestion or move cursor right" })

-- Enhanced Copilot controls with better integration
vim.keymap.set("i", "<C-w>", function()
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    copilot.accept_word()
  else
    -- Fallback to normal word completion
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", false)
  end
end, { desc = "Accept Copilot word or normal word completion" })

vim.keymap.set("i", "<C-l>", function()
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    copilot.accept_line()
  else
    -- Fallback to normal line completion
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
  end
end, { desc = "Accept Copilot line or normal line completion" })

vim.keymap.set("i", "<C-n>", function()
  local copilot = require("copilot.suggestion")
  local cmp = require("cmp")
  
  if copilot.is_visible() then
    copilot.next()
  elseif cmp.visible() then
    cmp.select_next_item()
  else
    -- Trigger completion
    cmp.complete()
  end
end, { desc = "Next suggestion (Copilot or completion)" })

vim.keymap.set("i", "<C-p>", function()
  local copilot = require("copilot.suggestion")
  local cmp = require("cmp")
  
  if copilot.is_visible() then
    copilot.prev()
  elseif cmp.visible() then
    cmp.select_prev_item()
  end
end, { desc = "Previous suggestion (Copilot or completion)" })

vim.keymap.set("i", "<C-e>", function()
  local copilot = require("copilot.suggestion")
  local cmp = require("cmp")
  
  if copilot.is_visible() then
    copilot.dismiss()
  elseif cmp.visible() then
    cmp.abort()
  end
end, { desc = "Dismiss suggestion (Copilot or completion)" })

-- Additional useful keybindings
vim.keymap.set("i", "<C-Space>", function()
  local cmp = require("cmp")
  cmp.complete()
end, { desc = "Trigger completion" })

vim.keymap.set("i", "<C-y>", function()
  local cmp = require("cmp")
  if cmp.visible() then
    cmp.confirm({ select = true })
  end
end, { desc = "Confirm completion" })

-- Toggle Copilot panel
vim.keymap.set("n", "<leader>cp", function()
  require("copilot.panel").open()
end, { desc = "Open Copilot panel" })

-- Enable/Disable Copilot commands
vim.api.nvim_create_user_command("CopilotEnable", function()
  require("copilot.suggestion").enable()
  vim.notify("Copilot enabled", vim.log.levels.INFO)
end, { desc = "Enable Copilot suggestions" })

vim.api.nvim_create_user_command("CopilotDisable", function()
  require("copilot.suggestion").disable()
  vim.notify("Copilot disabled", vim.log.levels.INFO)
end, { desc = "Disable Copilot suggestions" })

vim.api.nvim_create_user_command("CopilotStatus", function()
  local status = require("copilot.suggestion").is_enabled()
  vim.notify("Copilot status: " .. (status and "Enabled" or "Disabled"), vim.log.levels.INFO)
end, { desc = "Check Copilot status" })

-- Toggle Copilot on/off
vim.keymap.set("n", "<leader>ct", function()
  local status = require("copilot.suggestion").is_enabled()
  if status then
    require("copilot.suggestion").disable()
    vim.notify("Copilot disabled", vim.log.levels.INFO)
  else
    require("copilot.suggestion").enable()
    vim.notify("Copilot enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Copilot on/off" })
