local vim = vim
vim.o.completeopt = "menu,menuone,noselect"

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
  },

  -- You must set mapping if you want.
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  },

  formatting = {
      format = function(entry, vim_item)
          vim_item.menu = entry.source.name
          return vim_item
      end
  },

  sources = {
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'tmux', opts = {all_panes = true}},
  },
}
