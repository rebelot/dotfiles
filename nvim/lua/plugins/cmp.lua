vim.o.completeopt = "menu,menuone,noselect"

-- TODO: cmp.complete_common_string

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    preselect = cmp.PreselectMode.None,
    window = {
        documentation = {
            winhighlight = "Search:None",
            border = vim.g.FloatBorders,
        },
        -- completion = {
        --     winhighlight = "Normal:Pmenu,FloatBorder:CmpCompletionBorder,CursorLine:CmpCompletionSel,Search:None",
        --     border = 'none'
        -- border = vim.g.FloatBorders,
        -- },
    },
    mapping = {
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
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
                elseif vim.snippet.jump(1) then
                    return
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
                elseif vim.snippet.jumpable(1) then
                    vim.snippet.jump(1)
                else
                    fallback()
                end
            end,
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
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
                elseif vim.snippet.jump(-1) then
                    return
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
                elseif vim.snippet.jumpable(-1) then
                    vim.snippet.jump(-1)
                else
                    fallback()
                end
            end,
        }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<C-n>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.complete()
                    -- fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.complete()
                    -- fallback()
                end
            end,
        }),
        ["<C-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if cmp.get_active_entry() then
                    return cmp.complete_common_string()
                end
                fallback()
            end
            fallback()
        end, { "i", "c" }),
        ["<C-]>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        -- ["<C-Space>"] = cmp.mapping(function()
        --     cmp.complete({ config = { sources = { { name = "nvim_lsp" }, { name = "ultisnips" } } } })
        --     -- if not cmp.get_entries() then
        --     --     print("no entries")
        --     --     cmp.complete()
        --     -- end
        -- end, { "i" }),
        ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
        ["<CR>"] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
        }),
    },
    experimental = {
        ghost_text = { hl_group = "Comment" },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local menu
            local kind = require("lsp.init").symbol_icons[vim_item.kind] -- .. " " .. vim_item.kind

            -- local alias = {
            --     buffer = "[B]",
            --     path = "[P]",
            --     nvim_lsp = "[LSP]",
            --     luasnip = "[LS]",
            --     ultisnips = "[US]",
            --     nvim_lua = "Lua",
            --     tmux = "[T]",
            --     latex_symbols = "[TX]",
            --     nvim_lsp_signature_help = "[S]",
            -- }

            -- if entry.source.name == "nvim_lsp" then
            --     menu = entry.source.source.client.name
            -- else
            --     menu = alias[entry.source.name] or entry.source.name
            -- end

            vim_item.menu = vim_item.kind
            vim_item.kind = kind
            return vim_item
        end,
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            -- cmp.config.compare.scopes,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        { name = "path" },
        -- { name = "copilot" },
    }, {
        -- { name = "buffer" },
        -- { name = "tmux", option = { all_panes = true } },
    }),
})

-- { name = "buffer", option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
cmp.setup.cmdline({ "/", "?" }, {
    completion = { autocomplete = false },
    sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" }, --, option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
    },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline({ ":", "@", "=" }, {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

cmp.setup.filetype({ "markdown", "pandoc", "text", "tex" }, {
    sources = {
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        { name = "path" },
        -- { name = "copilot" },
        { name = "buffer" },
        -- { name = "dictionary", keyword_length = 2 },
        { name = "latex_symbols" },
        -- { name = "tmux", option = { all_panes = true } },
    },
})

vim.keymap.set("i", "<C-X>c", function()
    cmp.complete({ config = { sources = { { name = "copilot" } } } })
end, { silent = true })

-- cmp.event:on("menu_opened", function()
--     vim.b.copilot_suggestion_hidden = true
-- end)
--
-- cmp.event:on("menu_closed", function()
--     vim.b.copilot_suggestion_hidden = false
-- end)
