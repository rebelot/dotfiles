local lspconfig = require("lspconfig")

local M = {}

function M.echo_cursor_diagnostic()
    local severity_hl = {
        "DiagnosticError",
        "DiagnosticSignWarn",
        "DiagnosticInfo",
        "DiagnosticHint",
    }
    local severity_prefix = { "[Error]", "[Warning]", "[Info]", "[Hint]" }
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

    if vim.tbl_isempty(line_diagnostics) then
        return
    end

    local message = {}
    for i, diagnostic in ipairs(line_diagnostics) do
        local diag_col = diagnostic.col
        local diag_end_col = diagnostic.end_col
        if diag_col <= col and col < diag_end_col then
            local severity = severity_prefix[diagnostic.severity] .. " "
            local source = diagnostic.source or ""
            local msg = source .. ": " .. diagnostic.message:gsub("\n", "") .. " "
            table.insert(message, { severity, severity_hl[diagnostic.severity] })
            table.insert(message, { msg:sub(1, vim.v.echospace - #severity), "Normal" })
            vim.api.nvim_echo(message, false, {})
        end
    end
end

function M.addWsFolder()
    vim.ui.input({
        prompt = "Add Workspace folder: ",
        completion = "dir",
    }, function(input)
        if input then
            vim.lsp.buf.add_workspace_folder(input)
        end
    end)
end

function M.removeWsFolder()
    vim.ui.input({
        prompt = "Remove Workspace folder: ",
        completion = "dir",
    }, function(input)
        if input then
            vim.lsp.buf.remove_workspace_folder(input)
        end
    end)
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

function M.update_settings(client, settings)
    settings = { settings = vim.tbl_deep_extend('force', client.config.settings, settings) }
    client.notify("workspace/didChangeConfiguration", settings)
end



return M
