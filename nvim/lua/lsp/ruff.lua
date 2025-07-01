---@type vim.lsp.Config
return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    -- init_options = {
    --     settings = {
    --         lint = {
    --             select = { "E", "F", "UP", "B", "SIM", "C4", "FIX", "RET", "PD", "PL", "UP", "RUF" },
    --             -- select = { "ALL" }
    --         }
    --     }
    -- }
}
