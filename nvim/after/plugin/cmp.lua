
local cmp = require'cmp'
local luasnip = require'luasnip'

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
    -- Tab for smart completion and indentation
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- If completion menu is visible, cycle through items
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        -- If snippet is available, expand or jump
        luasnip.expand_or_jump()
      elseif has_words_before() then
        -- If there are words before cursor, trigger completion
        cmp.complete()
      elseif is_whitespace_or_beginning() then
        -- If at beginning of line or in whitespace, use for indentation
        fallback()
      else
        -- Default fallback
        fallback()
      end
    end, { 'i', 's' }),
    
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Enter for confirmation and new lines
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- If completion menu is visible, confirm selection
        cmp.confirm({ select = true })
      else
        -- Default: insert new line
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Escape to close
    ['<Esc>'] = cmp.mapping.abort(),
    
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
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'copilot', priority = 900 },
  }, {
    { name = 'buffer', priority = 500, keyword_length = 3 },
    { name = 'path', priority = 250 },
    { name = 'git', priority = 200 },
    { name = 'emoji', priority = 100 },
    { name = 'calc', priority = 100 },
    { name = 'treesitter', priority = 300 },
  }),
  
  -- Auto-completion settings
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
    keyword_length = 1,
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
      cmp.TriggerEvent.InsertEnter,
      cmp.TriggerEvent.CompleteDone,
    },
  },
  
  -- Performance settings
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 500,
  },
  
  -- Experimental features for better completion
  experimental = {
    ghost_text = true,
  },
  
  -- Enhanced UI formatting
  formatting = {
    format = function(entry, vim_item)
      -- Add icons for different sources
      local icons = {
        nvim_lsp = '🔧',
        luasnip = '📝',
        copilot = '🤖',
        buffer = '📄',
        path = '📁',
        git = '🌿',
        emoji = '😀',
        calc = '🧮',
        treesitter = '🌳',
      }
      
      vim_item.menu = icons[entry.source.name] or '❓'
      
      -- Truncate long items
      if vim_item.abbr and #vim_item.abbr > 50 then
        vim_item.abbr = vim_item.abbr:sub(1, 47) .. '...'
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
  
  -- Enhanced sorting
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

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

