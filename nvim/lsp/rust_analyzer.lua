---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
        },
    },
}
