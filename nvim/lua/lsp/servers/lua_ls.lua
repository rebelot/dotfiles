return {
    -- cmd = {
    --     "lua-language-server",
    -- },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                -- globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            completion = {
                keywordSnippet = "Replace",
                callSnippet = "Replace",
            },
            telemetry = {
                enable = false,
            },
            hint = {
                enable = true
            }
        },
    },
}
