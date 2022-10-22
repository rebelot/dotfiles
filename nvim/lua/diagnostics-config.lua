local fn = vim.fn
local api = vim.api
local map = vim.keymap.set

fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
--    

vim.diagnostic.config({
    float = { source = "always", border = require("lsp").borders },
    virtual_text = false, -- , source = 'always'},
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})

local severity_hl = {
    "DiagnosticError",
    "DiagnosticSignWarn",
    "DiagnosticInfo",
    "DiagnosticHint",
}
local severity_prefix = { "[Error]", "[Warning]", "[Info]", "[Hint]" }

local clear_msg_callback_is_running
local function echo_cursor_diagnostic()
    local line, col = unpack(api.nvim_win_get_cursor(0))
    local line_diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

    if vim.tbl_isempty(line_diagnostics) then
        return
    end

    local cursor_diagnostics = vim.tbl_filter(function(diag)
        return col >= diag.col and col <= diag.end_col
    end, line_diagnostics)

    if vim.tbl_isempty(cursor_diagnostics) then
        return
    end

    local message = {}
    local avail_space = vim.v.echospace
    for _, diagnostic in ipairs(cursor_diagnostics) do
        local severity = severity_prefix[diagnostic.severity] .. " "
        local msg = (diagnostic.source or "")
            .. ": "
            .. fn.trim(fn.substitute(diagnostic.message, "\n", "", "g"))
            .. " "

        if avail_space > (#severity + #msg) then
            table.insert(message, { severity, severity_hl[diagnostic.severity] })
            table.insert(message, { msg, "Normal" })
        else
            break
        end

        avail_space = avail_space - (#severity + #msg)
    end

    api.nvim_echo(message, false, {})
    if not clear_msg_callback_is_running then
        clear_msg_callback_is_running = true
        vim.defer_fn(function()
            api.nvim_echo({}, false, {})
            clear_msg_callback_is_running = false
        end, 5000)
    end
end

local diag_au_id = api.nvim_create_augroup("Cursor_Diagnostics", { clear = true })
api.nvim_create_autocmd("CursorHold", {
    callback = echo_cursor_diagnostic,
    group = diag_au_id,
    desc = "Echo cursor diagnostics",
})
-- api.nvim_create_autocmd("CursorMoved", { command = 'echo ""', group = diag_au_id, desc = "Clear cursor diagnostics" })

map("n", "<leader>ld", function()
    vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Show line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
