local borders = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }

-----------------------
-- Handlers override --
-----------------------

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    silent = true,
    max_height = "10",
    border = borders,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = borders,
})

local lsprename = vim.lsp.buf.rename

vim.lsp.buf.rename = function(new_name, options)
    options = options or {}

    local filter = function(client)
        return not vim.tbl_contains({ "null-ls", "copilot" }, client.name)
    end

    options.filter = options.filter or filter

    lsprename(new_name, options)
end

require("lsp.inlay_hints")

------------------
-- Capabilities --
------------------

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = require("lsp.semantic_tokens").extend_capabilities(capabilities)

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- mappings
    local map = function(mode, key, expr, opts)
        opts = vim.tbl_extend("keep", { noremap = true, silent = true, buffer = bufnr }, opts)
        return vim.keymap.set(mode, key, expr, opts)
    end
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
    map("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Go to LSP definition" })
    map(
        "n",
        "<C-w>d",
        "<Cmd>split <bar> Telescope lsp_definitions<CR>",
        { desc = " Go to LSP definition (split window)" }
    )
    map("n", "gD", vim.lsp.buf.declaration, { desc = " Go to LSP declaration" })
    map("n", "gr", require("telescope.builtin").lsp_references, { desc = "Go to LSP references" })
    map("n", "<leader>lt", require("telescope.builtin").lsp_type_definitions, { desc = "Go to LSP type definitions" })
    map("n", "<leader>li", require("telescope.builtin").lsp_implementations, { desc = "Go to LSP implementations" })
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "List LSP Code Actions" })
    map("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, { desc = "List LSP document symbols" })
    map(
        "n",
        "<leader>lS",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        { desc = "List LSP workspace symbols" }
    )
    map("n", "<leader>lwl", function()
        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "List LSP workspace folders" })
    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add LSP workspace folder" })
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove LSP workspace folder" })
    map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
    map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
    map({ "n", "i" }, "<C-q>", vim.lsp.buf.signature_help, { desc = "Show LSP signature help" })
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm

    if client.server_capabilities.documentFormattingProvider then
        -- set eventignore=all
        map("n", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { range = false, desc = "LSP format" })
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        map("x", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", function(args)
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                range = { start = { args.line1, 0 }, ["end"] = { args.line2, 0 } },
            })
        end, { range = true, desc = "LSP range format" })
    end

    -- if client.server_capabilities.signatureHelpProvider then
    --     local lsp_signature_help_au_id = vim.api.nvim_create_augroup("LSP_signature_help", { clear = true })
    --     vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
    --         callback = function()
    --             vim.lsp.buf.signature_help({ focusable = false })
    --         end,
    --         group = lsp_signature_help_au_id,
    --         buffer = bufnr,
    --     })
    -- end

    if client.server_capabilities.documentHighlightProvider then
        local lsp_references_au_id = vim.api.nvim_create_augroup("LSP_document_highlight", { clear = false })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = lsp_references_au_id,
        })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "LSP document highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "WinLeave" }, {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "Clear LSP document highlight",
        })
    end
end

M = {}
M.default_on_attach = on_attach
M.default_capabilities = capabilities
M.borders = borders
return M
