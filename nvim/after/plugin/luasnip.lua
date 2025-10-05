-- LuaSnip configuration
local luasnip = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- LuaSnip key mappings for tab completion
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

vim.keymap.set({"i", "s"}, "<Tab>", tab_complete, {expr = true})
vim.keymap.set({"i", "s"}, "<S-Tab>", s_tab_complete, {expr = true})
