local vim = vim
vim.o.completeopt = "menu,menuone,noselect"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
  },
  -- preselect = cmp.PreselectMode.None,
  -- enabled = function()
  --     local prompt = vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
  --     local command_line = vim.fn.bufname("%") ~= '[Command Line]'
  --     return prompt and command_line
  -- end,

  -- You must set mapping if you want.
  mapping = {
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-n>'] = cmp.mapping.select_next_item(),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.fn.feedkeys(t("<Plug>(ultisnips_jump_forward)"))
            else
                fallback()
            end
        end, {'i', 's'}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
            elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                return vim.fn.feedkeys(t("<Plug>(ultisnips_jump_backward)"))
            else
                fallback()
            end
        end, {'i', 's'}),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  },

  experimental = {
      native_menu = false,
      ghost_text = true,
    },

  formatting = {
    format = function(entry, vim_item)
        -- vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
        vim_item = require'lspkind'.cmp_format()(entry, vim_item)

        local alias =  {
            buffer = "buffer",
            path = 'path',
            nvim_lsp = "LSP",
            luasnip = "LuaSnip",
            ultisnips = "UltiSnips",
            nvim_lua = "Lua",
            tmux = 'tmux',
            latex_symbols = "Latex"}

        if entry.source.name == 'nvim_lsp' then
            vim_item.menu = entry.source.source.client.name
        else
            vim_item.menu = alias[entry.source.name] or entry.source.name
        end
        return vim_item
      end
  },
  sources = {
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'tmux', opts = {all_panes = true}},
  },
}

-- vim.cmd [[
-- augroup cmp-confg
--     autocmd!
--     autocmd InsertEnter * lua if vim.fn.bufname("%") == "[Command Line]" then
--     \   require'cmp'.setup.buffer { experimental = {native_menu = true} }
--     \   end
-- augroup END
-- ]]

-- vim.cmd [[ hi! link CmpItemKind Keyword]]
-- vim.cmd [[ hi! link CmpItemMenu Cursorlinenr]]
vim.cmd [[ hi! link CmpItemAbbrMatch Directory]]
vim.cmd [[ hi! link CmpItemAbbrMatchFuzzy Directory]]
-- vim.cmd [[ hi! link CmpItemAbbr Normal]]
