local cmp = require'cmp'
local luasnip = require'luasnip'

-- Helper function to check if Copilot suggestion is visible
local function copilot_suggestion_visible()
  local copilot_ok, suggestion = pcall(require, "copilot.suggestion")
  if copilot_ok then
    return suggestion.is_visible()
  end
  return false
end

-- Helper function to accept Copilot suggestion
local function accept_copilot()
  local copilot_ok, suggestion = pcall(require, "copilot.suggestion")
  if copilot_ok and suggestion.is_visible() then
    suggestion.accept()
    return true
  end
  return false
end

-- Helper function for Tab completion
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Helper function to check if we're at the beginning of a line or in whitespace
local is_whitespace_or_beginning = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return col == 0 or current_line:sub(1, col):match("^%s*$")
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    -- Smart Tab: Copilot > cmp > snippets > completion > indentation
    ['<Tab>'] = cmp.mapping(function(fallback)
      -- Priority 1: Accept Copilot suggestion if visible
      if copilot_suggestion_visible() then
        if accept_copilot() then
          return
        end
      end
      
      -- Priority 2: Navigate cmp menu if visible
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        return
      end
      
      -- Priority 3: Expand or jump in snippet
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        return
      end
      
      -- Priority 4: Trigger completion if we have words before cursor
      if has_words_before() then
        cmp.complete()
        return
      end
      
      -- Priority 5: Default indentation for whitespace/beginning of line
      fallback()
    end, { 'i', 's' }),
    
    -- Smart Shift-Tab: Reverse navigation
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Smart Enter: Accept completion or create new line
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true }) -- Auto-select and confirm first item
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Escape: Close completion and Copilot
    ['<Esc>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      end
      -- Also dismiss Copilot suggestion
      local copilot_ok, suggestion = pcall(require, "copilot.suggestion")
      if copilot_ok and suggestion.is_visible() then
        suggestion.dismiss()
      end
      fallback()
    end, { 'i', 's' }),
    
    -- Additional mappings for better control
    ['<C-Space>'] = cmp.mapping.complete(), -- Force completion trigger
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Alternative confirm
    
    -- Keep existing mappings for compatibility
    ['<M-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<M-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<M-y>'] = cmp.mapping.confirm({ select = true }),
    ['<M-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    })
  },
  sources = cmp.config.sources({
    { 
      name = 'nvim_lsp', 
      priority = 1000,
      keyword_length = 1, -- Trigger faster
      max_item_count = 20,
    },
    { 
      name = 'luasnip', 
      priority = 750,
      keyword_length = 1,
    },
  }, {
    { 
      name = 'buffer', 
      priority = 500, 
      keyword_length = 3,
      max_item_count = 10,
    },
    { 
      name = 'path', 
      priority = 250,
      keyword_length = 2,
    },
  }),
  
  -- Auto-completion settings optimized for Copilot integration
  completion = {
    completeopt = 'menu,menuone,noinsert', -- Auto-select first item
    keyword_length = 1, -- Trigger after 1 character for faster completions
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
    },
  },
  
  -- Performance settings optimized for Copilot coexistence
  performance = {
    debounce = 100, -- Faster for more responsive completion
    throttle = 40,
    fetching_timeout = 500,
    max_view_entries = 15, -- Show fewer items, best ones first
  },
  
  -- Experimental features
  experimental = {
    ghost_text = false, -- Disable to avoid conflicts with Copilot
  },
  
  -- Simplified UI formatting for less visual noise
  formatting = {
    format = function(entry, vim_item)
      local icons = {
        nvim_lsp = '󰒋',
        luasnip = '󰩫',
        buffer = '󰈔',
        path = '󰝰',
      }
      
      vim_item.menu = icons[entry.source.name] or ''
      
      -- Truncate very long items
      if vim_item.abbr and #vim_item.abbr > 40 then
        vim_item.abbr = vim_item.abbr:sub(1, 37) .. '...'
      end
      
      return vim_item
    end,
  },
  
  -- Better window configuration
  window = {
    completion = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    }),
    documentation = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    }),
  },
  
  -- Enhanced sorting - prioritize best matches first
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.exact, -- Exact matches first
      cmp.config.compare.locality, -- Nearby in file
      cmp.config.compare.recently_used, -- Recently used
      cmp.config.compare.score, -- Fuzzy match score
      cmp.config.compare.offset,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  
  -- Preselect first item automatically
  preselect = cmp.PreselectMode.Item,
})

-- Copilot configuration for seamless integration
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Configure Copilot to work nicely with cmp
local copilot_ok, copilot = pcall(require, "copilot")
if copilot_ok then
  copilot.setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = false, -- We handle this in cmp mapping
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = false, -- We handle this in cmp mapping
      },
    },
    panel = { enabled = false }, -- We don't need the panel
    copilot_node_command = 'node',
  })
end

-- Disable default Copilot keymaps to avoid conflicts
vim.api.nvim_set_keymap('i', '<Tab>', '', { noremap = true, silent = true })

-- Filetype-specific completion settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "javascript", "typescript" },
  callback = function()
    -- Ensure completion is more responsive for these languages
    vim.opt_local.updatetime = 200
  end,
})

-- Debug helper to check if completion is working
vim.api.nvim_create_user_command("CmpStatus", function()
  local sources = require('cmp').get_config().sources
  local active_sources = {}
  for _, source_group in ipairs(sources) do
    for _, source in ipairs(source_group) do
      table.insert(active_sources, source.name)
    end
  end
  vim.notify("Active cmp sources: " .. table.concat(active_sources, ", "), vim.log.levels.INFO)
  
  -- Check LSP clients
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  if #client_names > 0 then
    vim.notify("Active LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
  else
    vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
  end
end, { desc = "Show cmp and LSP status" })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Completion capabilities are now handled in lsp.lua
-- No need for redundant LSP configuration here

