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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.workDoneProgress = true
capabilities = require("lsp.semantic_tokens").extend_capabilities(capabilities)

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set(
        "n",
        "gd",
        require("telescope.builtin").lsp_definitions,
        { unpack(opts), desc = "Go to LSP definition" }
    )
    vim.keymap.set(
        "n",
        "<C-w>d",
        "<Cmd>split <bar> Telescope lsp_definitions<CR>",
        { unpack(opts), desc = " Go to LSP definition (split window)" }
    )
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = " Go to LSP declaration" })
    vim.keymap.set(
        "n",
        "gr",
        require("telescope.builtin").lsp_references,
        { unpack(opts), desc = "Go to LSP references" }
    )
    vim.keymap.set(
        "n",
        "<leader>lt",
        require("telescope.builtin").lsp_type_definitions,
        { unpack(opts), desc = "Go to LSP type definitions" }
    )
    vim.keymap.set(
        "n",
        "<leader>li",
        require("telescope.builtin").lsp_implementations,
        { unpack(opts), desc = "Go to LSP implementations" }
    )
    vim.keymap.set(
        { "n", "x" },
        "<leader>la",
        vim.lsp.buf.code_action,
        { unpack(opts), desc = "List LSP Code Actions" }
    )
    vim.keymap.set(
        "n",
        "<leader>ls",
        require("telescope.builtin").lsp_document_symbols,
        { unpack(opts), desc = "List LSP document symbols" }
    )
    vim.keymap.set(
        "n",
        "<leader>lS",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        { unpack(opts), desc = "List LSP workspace symbols" }
    )
    vim.keymap.set("n", "<leader>lwl", function()
        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    end, { unpack(opts), desc = "List LSP workspace folders" })
    vim.keymap.set(
        "n",
        "<leader>lwa",
        vim.lsp.buf.add_workspace_folder,
        { unpack(opts), desc = "Add LSP workspace folder" }
    )
    vim.keymap.set(
        "n",
        "<leader>lwr",
        vim.lsp.buf.remove_workspace_folder,
        { unpack(opts), desc = "Remove LSP workspace folder" }
    )
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { unpack(opts), desc = "LSP rename" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "LSP Hover" })
    vim.keymap.set(
        { "n", "i" },
        "<C-q>",
        vim.lsp.buf.signature_help,
        { unpack(opts), desc = "Show LSP signature help" }
    )
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm

    if client.server_capabilities.documentFormattingProvider then
        -- set eventignore=all
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { unpack(opts), desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "LspFormat",
            vim.lsp.buf.format,
            { range = false, desc = "LSP format" }
        )
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        vim.keymap.set("x", "<leader>lf", vim.lsp.buf.format, { unpack(opts), desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", function(args)
            vim.lsp.buf.format({ { args.line1, 0 }, { args.line2, 0 } })
        end, { range = true, desc = "LSP range format" })
    end

    -- if client.server_capabilities.signatureHelpProvider then
    --     local lsp_signature_help_au_id = vim.api.nvim_create_augroup("LSP_signature_help", { clear = true })
    --     vim.api.nvim_create_autocmd(
    --         { "CursorHoldI" },
    --         { callback = function() vim.lsp.buf.signature_help({ focusable = false }) end, group = lsp_signature_help_au_id, buffer = bufnr }
    --     )
    -- end

    if client.server_capabilities.documentHighlightProvider then
        local lsp_references_au_id = vim.api.nvim_create_augroup("LSP_references", { clear = true })
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