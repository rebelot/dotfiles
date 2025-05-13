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
    -- virtual_text = { current_line = false },
    -- virtual_lines = { current_line = true },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })

vim.keymap.set('n', 'gL', function()
    local virt_lines = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = virt_lines, virtual_text = not virt_lines })
    -- if type(virt_lines) == 'table' then
    --     vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
    -- else
    --     vim.diagnostic.config({
    --         virtual_text = { current_line = false },
    --         virtual_lines = { current_line = true },
    --     })
    -- end
end, { desc = 'Toggle diagnostic virtual_lines' })
