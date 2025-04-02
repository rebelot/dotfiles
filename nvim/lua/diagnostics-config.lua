local fn = vim.fn
local api = vim.api
local map = vim.keymap.set

fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
--    

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        linehl = {},
        numhl = {},
    },
    float = {
        source = true,
        title = "Diagnostics",
        title_pos = "left",
        header = "",
    },
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })

vim.keymap.set('n', 'gL', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })
