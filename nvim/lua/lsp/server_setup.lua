local servers = {
    -- "ccls",
    "clangd",
    "pylance",
    "ruff",
    -- "pyright",
    -- "basedpyright",
    "marksman",
    "lua_ls",
    "texlab",
    "ltex",
    "vimls",
    "bashls",
    "julials",
    "ts_ls",
    "eslint",
    -- "rust_analyzer", -- handled by rustacean
    "tinymist",
    "html",
    "cssls",
    "yamlls",
    "asm_lsp",
}

for _, server in ipairs(servers) do
    local ok, config = pcall(require, "lsp.servers." .. server_name)
    if not ok then
        config = {}
    end
    vim.lsp.config(server, config)
end
