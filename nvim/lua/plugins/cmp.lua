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
    -- preselect = cmp.PreselectMode.None,
    -- enabled = function()
    --     local prompt = vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
    --     local command_line = vim.fn.bufname("%") ~= '[Command Line]'
    --     return prompt and command_line
    -- end,
    window = {
        documentation = {
            winhighlight = "Search:None",
            border = require("lsp.lsp-config").borders,
        },
        -- completion = {
        --     winhighlight = "Normal:Pmenu,FloatBorder:CmpCompletionBorder,CursorLine:PmenuSel,Search:None",
        --     border = require'lsp.lsp-config'.borders
        -- }
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
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
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
                    return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
                else
                    fallback()
                end
            end,
        }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<C-n>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
        }),
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
        -- ['<C-e>']  = cmp.mapping.close(),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
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
        ghost_text = true,
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- vim_item = require("lspkind").cmp_format()(entry, vim_item)
            local icon = require("lspkind").symbol_map[vim_item.kind] .. " "

            local alias = {
                buffer = "buffer",
                path = "path",
                nvim_lsp = "LSP",
                luasnip = "LuaSnip",
                ultisnips = "UltiSnips",
                nvim_lua = "Lua",
                tmux = "tmux",
                latex_symbols = "Latex",
                nvim_lsp_signature_help = "LSP Signature",
            }

            if entry.source.name == "nvim_lsp" then
                vim_item.menu = entry.source.source.client.name
            else
                vim_item.menu = alias[entry.source.name] or entry.source.name
            end

            if entry.source.name == "copilot" then
                icon = " " --  
                vim_item.kind_hl_group = "String"
            end
            vim_item.menu = vim_item.kind -- .. " (" .. vim_item.menu .. ')'
            vim_item.kind = icon
            return vim_item
        end,
    },
    sources = {
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "ultisnips" },
        { name = "path" },
        { name = "buffer" },
        -- { name = "tmux", option = { all_panes = true } },
    },
})

-- Use buffer source for `/`.
-- { name = "buffer", option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
cmp.setup.cmdline("/", {
    completion = { autocomplete = false },
    sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" }, --, option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
        -- { name = "buffer" },
    },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    completion = { autocomplete = false },
    sources = cmp.config.sources(
        {
            { name = "path" },
        },
        -- {
        --     { name = "nvim_lua" },
        -- },
        {
            { name = "cmdline" },
        }
    ),
    -- sources = {
    --     -- { name = 'cmdline_history', max_item_count = 2 },
    --     { name = "cmdline" },
    --     { name = "nvim_lua" },
    --     { name = "path" },
    -- },
})

cmp.setup.filetype({ "markdown", "pandoc", "text", "tex" }, {
    sources = {
        { name = "nvim_lsp_signature_help" },
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        { name = "path" },
        { name = "buffer" },
        -- { name = "dictionary", keyword_length = 2 },
        { name = "latex_symbols" },
        -- { name = "tmux", option = { all_panes = true } },
    },
})

-- cmp.setup.filetype({ "lua" }, {
--     sources = {
--         { name = "nvim_lsp_signature_help" },
--         { name = "copilot" },
--         -- { name = "nvim_lua" },
--         { name = "nvim_lsp" },
--         { name = "ultisnips" },
--         { name = "path" },
--         { name = "buffer" },
--         -- { name = "tmux", option = { all_panes = true } },
--     },
-- })

-- local rec_au = vim.api.nvim_create_augroup('CmpRecording', { clear = true })
-- vim.api.nvim_create_autocmd('RecordingEnter', {
--     group = rec_au,
--     command = [[lua require'cmp'.setup.buffer({ enabled = false })]]
-- })
-- vim.api.nvim_create_autocmd('RecordingLeave', {
--     group = rec_au,
--     command = [[lua require'cmp'.setup.buffer({ enabled = true })]]
-- })
