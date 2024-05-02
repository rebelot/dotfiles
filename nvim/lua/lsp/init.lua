local M = {}
local borders = vim.g.FloatBorders

M.symbol_icons = {
    -- SymbolKind
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = " ",
    Interface = " ",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = " ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = " ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
    -- unique to CompletionIntemKind
    Text = " ",
    Unit = " ",
    Value = " ",
    Keyword = " ",
    Snippet = " ",
    Color = " ",
    Reference = " ",
    Folder = " ",

    -- Others
    Copilot = " ",
}

M.symbol_hl = {
    File = "Directory",
    Module = "@module",
    Namespace = "@module",
    Package = "@module",
    Class = "Type",
    Method = "@function.method",
    Property = "@property",
    Field = "@variable.member",
    Constructor = "@constructor",
    Enum = "Type",
    Interface = "Type",
    Function = "Function",
    Variable = "@variable",
    Constant = "Constant",
    String = "String",
    Number = "Number",
    Boolean = "Boolean",
    Array = "Type",
    Object = "Type",
    Key = "Identifier",
    Null = "Type",
    EnumMember = "Constant",
    Struct = "Type",
    Event = "@property",
    Operator = "Operator",
    TypeParameter = "Type",

    Text = "@variable",
    Unit = "Number",
    Value = "String",
    Keyword = "Keyword",
    Snippet = "Special",
    Color = "Special",
    Reference = "Special",
    Folder = "Directory",

    Copilot = "String",
}

-- https://code.visualstudio.com/api/references/icons-in-labels

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
        opts = vim.tbl_extend("force", { noremap = true, silent = true, buffer = bufnr, desc = "LSP" }, opts)
        return vim.keymap.set(mode, key, expr, opts)
    end
    map("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "LSP: go to definition" })
    map(
        "n",
        "<C-w>d",
        "<Cmd>split <bar> Telescope lsp_definitions<CR>",
        { desc = "LSP: go to definition (split window)" }
    )
    map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: go to declaration" })
    map("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP: references" })
    map("n", "<leader>lt", require("telescope.builtin").lsp_type_definitions, { desc = "LSP: go to type definitions" })
    map("n", "<leader>li", require("telescope.builtin").lsp_implementations, { desc = "LSP: go to implementations" })
    map("n", "gs", require("telescope.builtin").lsp_document_symbols, { desc = "LSP: document symbols" })
    map(
        "n",
        "gS",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        { desc = "LSP: dynamic workspace symbols" }
    )
    map("n", "<leader>lwl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "LSP: list workspace folders" })
    map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: add workspace folder" })
    map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: remove workspace folder" })
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm
    map("n", "<leader>lci", vim.lsp.buf.incoming_calls, { desc = "LSP: incoming calls" })
    map("n", "<leader>lco", vim.lsp.buf.outgoing_calls, { desc = "LSP: outgoing calls" })
    map("n", "<leader>lht", function()
        vim.lsp.buf.typehierarchy("subtypes")
    end, { desc = "LSP: subtypes" })
    map("n", "<leader>lhT", function()
        vim.lsp.buf.typehierarchy("supertypes")
    end, { desc = "LSP: supertypes" })
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
        -- set eventignore=all
        map("n", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP: format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { range = false, desc = "LSP: format" })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting) then
        vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})"
        map("x", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP: range format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", function(args)
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                range = { start = { args.line1, 0 }, ["end"] = { args.line2, 0 } },
            })
        end, { range = true, desc = "LSP: range format" })
    end
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "LSP document highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "WinLeave" }, {
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "Clear LSP document highlight",
        })
    end
end

M.default_on_attach = on_attach
M.default_capabilities = capabilities
return M
