local configs = require'lsp.servers'
local lspconfig = require'lspconfig'

local M = {}

function M.echo_cursor_diagnostic()
    local severity_hl = {
        'DiagnosticError', 'DiagnosticSignWarn', 'DiagnosticInfo',
        'DiagnosticHint'
    }
    local severity_prefix = {"[Error]", "[Warning]", "[Info]", "[Hint]"}
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

    if vim.tbl_isempty(line_diagnostics) then return end

    local message = {}
    for i, diagnostic in ipairs(line_diagnostics) do
        local diag_col = diagnostic.col
        local diag_end_col = diagnostic.end_col
        if diag_col <= col and col <= diag_end_col then
            local source = diagnostic.source or ''
            local severity = severity_prefix[diagnostic.severity] .. " "
            local msg = source .. ': ' .. diagnostic.message:gsub("\n", "")
            local avail_space = vim.v.echospace - (#severity + #msg)
            table.insert(message, {severity, severity_hl[diagnostic.severity]})
            table.insert(message, {msg:gsub(1, avail_space), 'Normal'})
            vim.api.nvim_echo(message, false, {})
        end
    end
end

function M.addWsFolder()
    vim.ui.input(
        {
            prompt = "Add Workspace folder: ",
            completion="dir",
        },
        function(input)
            if input then
                vim.lsp.buf.add_workspace_folder(input)
            end
        end
    )
end

function M.removeWsFolder()
    vim.ui.input(
        {
            prompt = "Remove Workspace folder: ",
            completion="dir",
        },
        function(input)
            if input then
                vim.lsp.buf.remove_workspace_folder(input)
            end
        end
    )
end
-- local function preview_location_callback(err, result, ctx)
--     if result == nil or vim.tbl_isempty(result) then
--         -- print('No location found')
--         return nil
--     end
--     -- print(vim.inspect(result))
--     if vim.tbl_islist(result) then
--         vim.lsp.util.preview_location(result[1])
--     else
--         vim.lsp.util.preview_location(result)
--     end
-- end
--
-- function M.peek_definition()
--     local params = vim.lsp.util.make_position_params()
--     return vim.lsp.buf_request(0, 'textDocument/definition', params,
--                                preview_location_callback)
-- end

-- function code_action_listener()
--     local context = {
--         diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
--     }
--     local params = vim.lsp.util.make_range_params()
--     params.context = context
--     vim.lsp.buf_request(0, 'textDocument/codeAction', params,
--                         function(err, _, result) print(vim.inspect(result)) end)
-- end


function M.change_python_interpreter(path)
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    configs.pyright.settings.python.pythonPath = path
    lspconfig.pyright.setup(configs.pyright)
    vim.cmd('e%')
end

function M.get_python_interpreters(a, l, p)
    local paths = {}
    local is_home_dir = function()
        return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
    end
    local commands = {'find $HOME/venvs -name python', 'which -a python', is_home_dir() and '' or 'find . -name python'}
    for _, cmd in ipairs(commands) do
        local _paths = vim.fn.systemlist(cmd)
        if _paths then
            for _, path in ipairs(_paths) do
                table.insert(paths, path)
            end
        end
    end
    table.sort(paths)
    local res = {}
    for i, path in ipairs(paths) do
        if path ~= paths[i+1] then table.insert(res, path) end
    end
    if a then
        for _, p in ipairs(res) do
            if not string.find(p, a) then
                res = vim.fn.getcompletion(a, 'file')
            end
        end
    end
    return res
end

return M
