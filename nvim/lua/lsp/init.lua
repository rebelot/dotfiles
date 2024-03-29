local M = {}
local borders = vim.g.FloatBorders

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
    title = "Hover",
})

------------------
-- Capabilities --
------------------

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    -- vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "List LSP workspace folders" })
    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add LSP workspace folder" })
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove LSP workspace folder" })
    map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
    -- map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
    map({ "n", "i" }, "<C-q>", vim.lsp.buf.signature_help, { desc = "Show LSP signature help" })
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
        -- set eventignore=all
        map("n", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { range = false, desc = "LSP format" })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting) then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        map("x", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", function(args)
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                range = { start = { args.line1, 0 },["end"] = { args.line2, 0 } },
            })
        end, { range = true, desc = "LSP range format" })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(bufnr, true)
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

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local lsp_references_au_id = vim.api.nvim_create_augroup("LSP_document_highlight", { clear = false })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = lsp_references_au_id,
        })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function() vim.lsp.buf.document_highlight() end,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "LSP document highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "WinLeave" }, {
            callback = function() vim.lsp.buf.clear_references() end,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "Clear LSP document highlight",
        })
    end
end

M.default_on_attach = on_attach
M.default_capabilities = capabilities
M.borders = borders
return M
