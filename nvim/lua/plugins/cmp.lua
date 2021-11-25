vim.o.completeopt = "menu,menuone,noselect"

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
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
        ["<Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end
        }),
        ["<S-Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end
        }),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
        ['<C-n>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        -- ['<C-e>']  = cmp.mapping.close(),
        ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end
        }),
    },
    experimental = {
        native_menu = false,
        ghost_text = true
    },

    formatting = {
        format = function(entry, vim_item)
            -- vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            vim_item = require'lspkind'.cmp_format()(entry, vim_item)

            local alias = {
                buffer = "buffer",
                path = 'path',
                nvim_lsp = "LSP",
                luasnip = "LuaSnip",
                ultisnips = "UltiSnips",
                nvim_lua = "Lua",
                tmux = 'tmux',
                latex_symbols = "Latex"
            }

            if entry.source.name == 'nvim_lsp' then
                vim_item.menu = entry.source.source.client.name
            else
                vim_item.menu = alias[entry.source.name] or entry.source.name
            end
            return vim_item
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'tmux', option = { all_panes = true } }
        -- { name = "latex_symbols" },
        -- { name = "dictionary", keyword_length = 2 },
    }
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
        -- { name = 'buffer' }
        { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } }
    }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    sources = {
        -- { name = 'cmdline_history', max_item_count = 2 },
        { name = 'cmdline' },
        { name = 'nvim_lua'},
        { name = 'path' },
    }
})
-- vim.cmd [[
-- augroup cmp-confg
--     autocmd!
--     autocmd InsertEnter * lua if vim.fn.bufname("%") == "[Command Line]" then
--     \   require'cmp'.setup.buffer { experimental = {native_menu = true} }
--     \   end
-- augroup END
-- ]]


local default_sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'tmux', option = { all_panes = true } }
}

local spell_sources = {
    { name = "latex_symbols" },
    { name = "dictionary", keyword_length = 2 },
}

local M = {}
function M.set_sources(source_set)
    source_set = source_set or ''
    local sources = default_sources
    if source_set == "spell" then
    sources = vim.tbl_extend('force', default_sources, spell_sources)
    end
    require'cmp'.setup.buffer{sources = sources}
end

vim.cmd("autocmd OptionSet spell lua require'plugins.cmp'.set_sources('spell')")
vim.cmd("autocmd OptionSet nospell lua require'plugins.cmp'.set_sources()")

-- vim.cmd [[ hi! link CmpItemKind Keyword]]
-- vim.cmd [[ hi! link CmpItemMenu Cursorlinenr]]
vim.cmd [[ hi! link CmpItemAbbrMatch Directory]]
vim.cmd [[ hi! link CmpItemAbbrMatchFuzzy Directory]]
-- vim.cmd [[ hi! link CmpItemAbbr Normal]]

return M
