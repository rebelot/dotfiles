vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
    float = { source = "always", border = require("lsp.lsp-config").borders },
    virtual_text = false, -- , source = 'always'},
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})

local function echo_cursor_diagnostic()
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
vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, { desc = "Go to next diagnostic" })
