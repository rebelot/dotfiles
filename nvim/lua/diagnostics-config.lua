local fn = vim.fn
local api = vim.api
local map = vim.keymap.set

fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
--    

vim.diagnostic.config({
    float = {
        source = "always",
        border = vim.g.FloatBorders,
        title = "Diagnostics",
        title_pos = "left",
        header = "",
    },
    virtual_text = true,
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

    -- api.nvim_echo(message, false, {})
    return message
end

-- local diag_au_id = api.nvim_create_augroup("Cursor_Diagnostics", { clear = true })
-- api.nvim_create_autocmd("CursorHold", {
--     callback = function(args)
--         local msg = echo_cursor_diagnostic()
--         if msg then
--             if not (vim.fn.exists("b:cursor_diag_au") and vim.b[args.buf].cursor_diag_au) then
--                 vim.api.nvim_create_autocmd("CursorMoved", {
--                     callback = function(args)
--                         -- print('creating cleanup autocmd')
--                         vim.cmd("echo 'cleanup! " .. os.clock() .. "'")
--                         vim.b[args.buf].cursor_diag_au = false
--                         return true
--                     end,
--                     buf = args.bufnr,
--                 })
--             end
--             vim.b[args.buf].cursor_diag_au = true
--             api.nvim_echo(msg, false, {})
--         end
--     end,
--     group = diag_au_id,
--     desc = "Echo cursor diagnostics",
-- })

map("n", "<leader>ld", function()
    vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Show line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
