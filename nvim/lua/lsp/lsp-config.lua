local lspconfig = require("lspconfig")

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

------------------
-- Capabilities --
------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.workDoneProgress = true

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

    -- mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set(
    --     "x",
    --     "<leader>la",
    --     vim.lsp.buf.range_code_action,
    --     { unpack(opts), desc = "List LSP Code Actions for selected range." }
    -- )
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
        "n",
        "<leader>la",
        require("telescope.builtin").lsp_code_actions,
        { unpack(opts), desc = "List LSP Code Actions" }
    )
    vim.keymap.set(
        "x",
        "<leader>la",
        [[:<C-U>lua require("telescope.builtin").lsp_code_actions({ params = vim.lsp.util.make_given_range_params() })<CR>]],
        -- function()
        --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
        --     local params = vim.lsp.util.make_given_range_params()
        --     require("telescope.builtin").lsp_code_actions({ params = params })
        -- end,
        { unpack(opts), desc = "List LSP Code Actions for selected range" }
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
        require("lsp.utilities").addWsFolder,
        { unpack(opts), desc = "Add LSP workspace folder" }
    )
    vim.keymap.set(
        "n",
        "<leader>lwr",
        require("lsp.utilities").removeWsFolder,
        { unpack(opts), desc = "Remove LSP workspace folder" }
    )
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { unpack(opts), desc = "LSP rename" })
    vim.keymap.set("n", "<leader>ld", function()
        vim.diagnostic.open_float(nil, { scope = "line", border = borders })
    end, { unpack(opts), desc = "Show line diagnostics" })
    vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { unpack(opts), desc = "Send diagnostics to quickfix" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "LSP Hover" })
    vim.keymap.set(
        { "n", "i" },
        "<C-q>",
        vim.lsp.buf.signature_help,
        { unpack(opts), desc = "Show LSP signature help" }
    )
    vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, { unpack(opts), desc = "Go to previous diagnostic" })
    vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, { unpack(opts), desc = "Go to next diagnostic" })
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm

    if client.resolved_capabilities.document_formatting then
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.formatting_seq_sync, { unpack(opts), desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "LspFormat",
            vim.lsp.buf.formatting_seq_sync,
            { desc = "LSP format" }
        )
    end

    if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        vim.keymap.set("x", "<leader>lf", vim.lsp.buf.range_formatting, { unpack(opts), desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "LspRangeFormat",
            vim.lsp.buf.formatting_seq_sync,
            { range = true, desc = "LSP range format" }
        )
    end

    local lsp_diag_au_id = vim.api.nvim_create_augroup("LSP_diagnostics", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = require("lsp.utilities").echo_cursor_diagnostic,
        group = lsp_diag_au_id,
        buffer = bufnr,
        desc = "Echo cursor diagnostics",
    })
    vim.api.nvim_create_autocmd(
        "CursorMoved",
        { command = 'echo ""', group = lsp_diag_au_id, buffer = bufnr, desc = "Clear cursor diagnostics" }
    )

    -- if client.resolved_capabilities.signature_help then
    --     local lsp_signature_help_au_id = vim.api.nvim_create_augroup("LSP_signature_help", { clear = true })
    --     vim.api.nvim_create_autocmd(
    --         { "CursorHoldI" },
    --         { callback = function() vim.lsp.buf.signature_help({ focusable = false }) end, group = lsp_signature_help_au_id, buffer = bufnr }
    --     )
    -- end

    if client.resolved_capabilities.document_highlight then
        local lsp_references_au_id = vim.api.nvim_create_augroup("LSP_references", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "LSP document highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = lsp_references_au_id,
            desc = "Clear LSP document highlight",
        })
    end
end

local function make_config(server_name)
    local ok, config = pcall(require, "lsp.server_configurations." .. server_name)
    if not ok then
        config = {}
    end
    local client_on_attach = config.on_attach
    -- wrap client-specific on_attach with default custom on_attach
    if client_on_attach then
        config.on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            client_on_attach(client, bufnr)
        end
    else
        config.on_attach = on_attach
    end
    config.capabilites = capabilities
    return config
end

local servers = {
    "ccls",
    "pylance",
    -- "pyright",
    "sumneko_lua",
    "texlab",
    "ltex",
    "vimls",
    "bashls",
    "julials",
}

for _, server in ipairs(servers) do
    -- call make_config() before trying to access lspconfig[server] to ensure
    -- registering custom servers
    local config = make_config(server)
    lspconfig[server].setup(config)
end

M = {}
M.on_attach = on_attach
M.capabilities = capabilities
M.borders = borders
return M
