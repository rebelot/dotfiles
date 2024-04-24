local default_on_attach = require("lsp").default_on_attach
local default_capabilities = require("lsp").default_capabilities
local lspconfig = require("lspconfig")

local function make_config(server_name)
    local ok, config = pcall(require, "lsp.servers." .. server_name)
    if not ok then
        config = {}
    end
    local client_on_attach = config.on_attach
    -- wrap client-specific on_attach with default custom on_attach
    if client_on_attach then
        config.on_attach = function(client, bufnr)
            default_on_attach(client, bufnr)
            client_on_attach(client, bufnr)
        end
    else
        config.on_attach = default_on_attach
    end
    config.capabilities = default_capabilities
    return config
end

local servers = {
    -- "ccls",
    "clangd",
    "pylance",
    -- "pyright",
    -- "basedpyright",
    "marksman",
    "lua_ls",
    "texlab",
    "ltex",
    "vimls",
    "bashls",
    "julials",
    "tsserver",
    "rust_analyzer",
    "typst_lsp",
}

for _, server in ipairs(servers) do
    -- call make_config() before trying to access lspconfig[server] to ensure
    -- registering custom servers
    local config = make_config(server)
    lspconfig[server].setup(config)
end
