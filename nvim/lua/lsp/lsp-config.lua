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

vim.lsp.util.close_preview_autocmd = function(events, winnr)
    events = vim.tbl_filter(function(v)
        return v ~= "CursorMovedI" and v ~= "BufLeave"
    end, events)
    vim.api.nvim_command(
        "autocmd "
            .. table.concat(events, ",")
            .. " <buffer> ++once lua pcall(vim.api.nvim_win_close, "
            .. winnr
            .. ", true)"
    )
end

------------------
-- Capabilities --
------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.workDoneProgress = true
capabilities.textDocument.codeAction.dynamicRegistration = true

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- mappings
    local opts = {
        noremap = true,
        silent = true,
        buffer = bufnr,
    }
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set("x", "<leader>la", vim.lsp.buf.range_code_action, opts)
    -- vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set("n", "<C-w>d", "<Cmd>split <bar> Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
    vim.keymap.set("n", "<leader>lt", require("telescope.builtin").lsp_type_definitions, opts)
    vim.keymap.set("n", "<leader>li", require("telescope.builtin").lsp_implementations, opts)
    vim.keymap.set("n", "<leader>la", require("telescope.builtin").lsp_code_actions, opts)
    -- vim.keymap.set("x", "<leader>la", require("telescope.builtin").lsp_range_code_actions, opts)
    vim.keymap.set("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, opts)
    vim.keymap.set("n", "<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set("n", "<leader>lwl", function()
        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    end, opts)
    vim.keymap.set("n", "<leader>lwa", require("lsp.utilities").addWsFolder, opts)
    vim.keymap.set("n", "<leader>lwr", require("lsp.utilities").removeWsFolder, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ld", function()
        vim.diagnostic.open_float(nil, { scope = "line", border = borders })
    end, opts)
    vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set({ "n", "i" }, "<C-q>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, opts)
    -- buf_set_keymap('n', '<leader>lg', peek_definition, opts) -- treesitter does it better atm

    if client.resolved_capabilities.document_formatting then
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.formatting_seq_sync, opts)
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", vim.lsp.buf.formatting_seq_sync, {})
    end

    if client.resolved_capabilities.document_range_formatting then
        vim.keymap.set("x", "<leader>lf", vim.lsp.buf.range_formatting, opts)
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", vim.lsp.buf.formatting_seq_sync, { range = true })
    end

    local lsp_diag_au_id = vim.api.nvim_create_augroup("LSP_diagnostics", { clear = true })
    vim.api.nvim_create_autocmd(
        "CursorHold",
        { callback = require("lsp.utilities").echo_cursor_diagnostic, group = lsp_diag_au_id, buffer = bufnr }
    )
    vim.api.nvim_create_autocmd("CursorMoved", { command = 'echo ""', group = lsp_diag_au_id, buffer = bufnr })

    -- if client.resolved_capabilities.signature_help then
    --     local lsp_signature_help_au_id = vim.api.nvim_create_augroup("LSP_signature_help", { clear = true })
    --     vim.api.nvim_create_autocmd(
    --         { "CursorHoldI" },
    --         { callback = function() vim.lsp.buf.signature_help({ focusable = false }) end, group = lsp_signature_help_au_id, buffer = bufnr }
    --     )
    -- end

    if client.resolved_capabilities.document_highlight then
        local lsp_references_au_id = vim.api.nvim_create_augroup("LSP_references", { clear = true })
        vim.api.nvim_create_autocmd(
            "CursorHold",
            { callback = vim.lsp.buf.document_highlight, buffer = bufnr, group = lsp_references_au_id }
        )
        vim.api.nvim_create_autocmd(
            "CursorMoved",
            { callback = vim.lsp.buf.clear_references, buffer = bufnr, group = lsp_references_au_id }
        )
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
