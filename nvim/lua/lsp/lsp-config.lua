local lspconfig = require("lspconfig")
local configs = require("lsp.servers")
local lsputil = require("lspconfig.util")

require'lspconfig.configs'.pylance = {
    default_config = {
        name = "pylance",
        autostart = true,
        single_file_support = true,
        cmd = {
            "node",
            vim.fn.expand("~/.vscode/extensions/ms-python.vscode-pylance-*/dist/server.bundle.crak.js", false, true)[1],
            "--stdio",
        },
        filetypes = { "python" },
        root_dir = function(fname)
            local markers = {
                "Pipfile",
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
            }
            return lsputil.root_pattern(unpack(markers))(fname)
                or lsputil.find_git_ancestor(fname)
                or lsputil.path.dirname(fname)
        end,
        settings = {
            python = {
                analysis = vim.empty_dict(),
            },
        },
        -- before_init = function(_, config)
        --     if not config.settings.python then
        --         config.settings.python = {}
        --     end
        --     if not config.settings.python.pythonPath then
        --         config.settings.python.pythonPath = "/Users/laurenzi/venvs/base/bin/python"
        --     end
        -- end,
    },
}

local borders = {
    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },
}

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

capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)(),
        },
    },
}

-- capabilities.textDocument.completion.completionItem.workDoneProgress = true
-- capabilities.window.workDoneProgress = true

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- mappings
    local opts = {
        noremap = true,
        silent = true,
    }
    buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")
    -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('x', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    -- buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", opts)
    buf_set_keymap("n", "<C-w>d", "<Cmd>split <bar> Telescope lsp_definitions<CR>", opts)
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
    buf_set_keymap("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts)
    buf_set_keymap("n", "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", opts)
    buf_set_keymap("x", "<leader>la", "<cmd>Telescope lsp_range_code_actions<CR>", opts)
    buf_set_keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
    buf_set_keymap("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
    buf_set_keymap(
        "n",
        "<leader>lwl",
        '<cmd>lua print(table.concat(vim.lsp.buf.list_workspace_folders(), ", "))<CR>',
        opts
    )
    buf_set_keymap("n", "<leader>lwa", '<cmd>lua require"lsp.utilities".addWsFolder()<CR>', opts)
    buf_set_keymap("n", "<leader>lwr", '<cmd>lua require"lsp.utilities".removeWsFolder()<CR>', opts)
    buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap(
        "n",
        "<leader>ld",
        '<cmd>lua vim.diagnostic.open_float(nil, {scope ="line", border = "rounded"})<CR>',
        opts
    )
    buf_set_keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("i", "<C-q>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<C-q>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    -- buf_set_keymap('n', '<leader>lg', '<cmd>lua peek_definition()<CR>', opts) -- treesitter does it better atm

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>", opts)
        vim.cmd([[command! -buffer LspFormat lua vim.lsp.buf.formatting_seq_sync()]])
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("x", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        vim.cmd([[command! -buffer -range LspRangeFormat lua vim.lsp.buf.range_formatting()]])
    end

    vim.cmd([[
        augroup lsp_echo_diagnostics
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua require'lsp.utilities'.echo_cursor_diagnostic()
            "autocmd CursorHold <buffer> lua vim.diagnostic.open_float(nil, {scope = "cursor", border = "rounded", focusable = false})
            autocmd CursorMoved <buffer> echo ""
        augroup END
    ]])

    if client.resolved_capabilities.signature_help then
        vim.cmd([[
            augroup lsp_signature_help
                autocmd! * <buffer>
                "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({focusable = false})
            augroup END
        ]])
    end

    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end

    -- if client.name == "pyright" then
    --     vim.api.nvim_buf_add_user_command(bufnr, "PythonInterpreter", require'lsp.utilities'.change_python_interpreter, {nargs = 1, complete = require'lsp.utilities'.get_python_interpreters})
    -- end
end

for server, config in pairs(configs) do
    config.capabilities = capabilities
    config.on_attach = on_attach
    lspconfig[server].setup(config)
end

--------------
-- Commands --
--------------

vim.api.nvim_add_user_command(
    "PythonInterpreter",
    function(cmd)
        require("lsp.utilities").change_python_interpreter(cmd.args, 'pylance')
    end,
    { nargs = 1, complete = require("lsp.utilities").get_python_interpreters }
)
-- vim.cmd([[
-- command! -nargs=1 -complete=customlist,PythonInterpreterComplete PythonInterpreter lua require'lsp.utilities'.change_python_interpreter(<q-args>)
--
-- function! PythonInterpreterComplete(A,L,P) abort
--   return v:lua.require('lsp.utilities').get_python_interpreters()
-- endfunction
-- ]])

M = {}
M.on_attach = on_attach
M.capabilites = capabilities
M.borders = borders
return M
