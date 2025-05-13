local M = {}
local borders = vim.g.FloatBorders

------------------
-- Capabilities --
------------------

vim.lsp.config("*", {
    capabilities = {
        workspace = {
            fileOperations = {
                didCreate = true,
                didDelete = true,
                didRename = true,
                willCreate = true,
                willDelete = true,
                willRename = true
            }
        }
    }
})

------------
-- Config --
------------

local servers = {
    -- "ccls",
    "clangd",
    "pylance",
    "ruff",
    -- "pyright",
    -- "basedpyright",
    "marksman",
    "luals",
    "texlab",
    "ltex",
    "vimls",
    "bashls",
    "julials",
    "ts_ls",
    "eslint",
    -- "rust_analyzer", -- handled by rustacean
    "tinymist",
    "html",
    "cssls",
    "yamlls",
    "asm_lsp",
}

for _, server in ipairs(servers) do
    local ok, config = pcall(require, "lsp." .. server)
    if not ok then
        config = {}
    end
    vim.lsp.config(server, config)
end

vim.lsp.enable(servers)

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    local map = function(mode, key, expr, opts)
        opts = vim.tbl_extend("force", { noremap = true, silent = true, buffer = bufnr, desc = "LSP" }, opts)
        return vim.keymap.set(mode, key, expr, opts)
    end
    map("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "LSP: go to definition" })

    -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
    -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
    -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
    -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
    -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
    map("n", "K", function() vim.lsp.buf.hover({ border = borders }) end, { desc = "LSP: Hover" })
    map("i", "<C-s>", function() vim.lsp.buf.signature_help({ border = borders }) end, { desc = "LSP: signature help" })
    -- map(
    --     "n",
    --     "<C-w>d",
    --     "<Cmd>split <bar> Telescope lsp_definitions<CR>",
    --     { desc = "LSP: go to definition (split window)" }
    -- )
    map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: go to declaration" })
    map("n", "grt", require("telescope.builtin").lsp_references, { desc = "LSP: references" })
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

    map("n", "<leader>lpd", function()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, vim.lsp.protocol.Methods.textDocument_definition, params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then return end
            vim.lsp.util.preview_location(result[1],
                { border = borders, title = "Preview definition", title_pos = "left" })
        end)
    end, { desc = "LSP: floating preview" })

    map("n", "<leader>lpD", function()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, vim.lsp.protocol.Methods.textDocument_declaration, params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then return end
            vim.lsp.util.preview_location(result[1],
                { border = borders, title = "Preview declaration", title_pos = "left" })
        end)
    end, { desc = "LSP: floating preview" })

    map("n", "<leader>lpi", function()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, vim.lsp.protocol.Methods.textDocument_implementation, params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then return end
            vim.lsp.util.preview_location(result[1],
                { border = borders, title = "Preview implementation", title_pos = "left" })
        end)
    end, { desc = "LSP: floating preview" })

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
        -- set eventignore=all
        map("n", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP: format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { range = false, desc = "LSP: format" })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting) then
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
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        vim.api.nvim_buf_create_user_command(bufnr, "LspInlayHints", function(args)
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, { desc = "LSP: inlay hints toggle" })
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
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method('textDocument/documentColor') then
        vim.lsp.document_color.enable(true, bufnr)
        vim.notify("LSP: Document color enabled")
    end

    vim.api.nvim_buf_create_user_command(bufnr, "LspSemanticHlStop", function(args)
        vim.lsp.semantic_tokens.stop(bufnr, args.args)
    end, { desc = "LSP: stop semantic tokens" })
    vim.api.nvim_buf_create_user_command(bufnr, "LspSemanticHlStart", function(args)
        vim.lsp.semantic_tokens.start(bufnr, args.args)
    end, { desc = "LSP: stop semantic tokens" })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, args.buf)
    end
})

vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            vim.api.nvim_clear_autocmds({
                buffer = args.buf,
                group = "LSP_document_highlight",
            })
        end
    end
})

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

return M
