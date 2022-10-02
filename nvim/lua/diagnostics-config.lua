vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

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

local function echo_cursor_diagnostic()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
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
            .. vim.fn.trim(vim.fn.substitute(diagnostic.message, "\n", "", "g"))
            .. " "

        if avail_space > (#severity + #msg) then
            table.insert(message, { severity, severity_hl[diagnostic.severity] })
            table.insert(message, { msg, "Normal" })
        else
            break
        end

        avail_space = avail_space - (#severity + #msg)
    end
    vim.api.nvim_echo(message, false, {})
end

local diag_au_id = vim.api.nvim_create_augroup("Cursor_Diagnostics", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    callback = echo_cursor_diagnostic,
    group = diag_au_id,
    desc = "Echo cursor diagnostics",
})
vim.api.nvim_create_autocmd(
    "CursorMoved",
    { command = 'echo ""', group = diag_au_id, desc = "Clear cursor diagnostics" }
)

vim.keymap.set("n", "<leader>ld", function()
    vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
