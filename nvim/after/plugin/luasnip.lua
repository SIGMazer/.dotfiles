-- Enhanced LuaSnip configuration
local luasnip = require("luasnip")

-- Load snippet collections
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

-- Load custom snippets
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/snippets" } })

-- Enhanced LuaSnip configuration
luasnip.setup({
  -- Enable autosnippets
  enable_autosnippets = true,
  
  -- Better history
  history = true,
  
  -- Delete checkpoints when leaving insert mode
  delete_check_events = "TextChanged",
})

-- Enhanced key mappings for better snippet navigation
local function tab_complete()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
  end
end

local function s_tab_complete()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    return vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
  end
end

-- Tab completion for snippets
vim.keymap.set({"i", "s"}, "<Tab>", tab_complete, {expr = true, desc = "Expand or jump to next snippet"})
vim.keymap.set({"i", "s"}, "<S-Tab>", s_tab_complete, {expr = true, desc = "Jump to previous snippet"})

-- Additional snippet controls
vim.keymap.set({"i", "s"}, "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, {desc = "Next snippet choice"})

vim.keymap.set({"i", "s"}, "<C-h>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  end
end, {desc = "Previous snippet choice"})

-- Reload snippets
vim.keymap.set("n", "<leader>sr", function()
  require("luasnip.loaders.from_vscode").lazy_load()
  vim.notify("Snippets reloaded", vim.log.levels.INFO)
end, {desc = "Reload snippets"})

-- Show available snippets
vim.keymap.set("n", "<leader>ss", function()
  require("luasnip.loaders.from_vscode").edit_snippet_files()
end, {desc = "Edit snippet files"})
