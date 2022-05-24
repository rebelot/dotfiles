local null_ls = require("null-ls")

local sources = {
    null_ls.builtins.formatting.isort.with({
        extra_args = { "--profile", "black" },
    }),
    -- null_ls.builtins.formatting.yapf,
    -- null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.black,

    -- null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.pylint,

    null_ls.builtins.formatting.stylua.with({
        args = { "--indent-width", "4", "--indent-type", "Spaces", "-" },
    }),

    -- null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.formatting.lua_format,

    null_ls.builtins.formatting.prettier,

    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.shellcheck,

    null_ls.builtins.diagnostics.chktex,

    null_ls.builtins.diagnostics.cppcheck,

    -- null_ls.builtins.diagnostics.proselint,
    -- null_ls.builtins.diagnostics.write_good,

    null_ls.builtins.diagnostics.vint,

    null_ls.builtins.code_actions.gitsigns,

    -- null_ls.builtins.code_actions.refactoring,
    -- null_ls.builtins.completion.spell,
}

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(
        "n",
        "<leader>la",
        vim.lsp.buf.code_action,
        { unpack(opts), desc = "List LSP Code Actions" }
    )
    vim.keymap.set(
        "x",
        "<leader>la",
        ":<C-u>lua vim.lsp.buf.range_code_action()<cr>", --https://github.com/neovim/neovim/issues/18340
        { unpack(opts), desc = "List LSP Code Actions for selected range" }
    )
    if client.server_capabilities.documentFormattingProvider then
        -- set eventignore=all
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { unpack(opts), desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "LspFormat",
            vim.lsp.buf.format,
            { range = false, desc = "LSP format" }
        )
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        vim.keymap.set("x", "<leader>lf", vim.lsp.buf.range_formatting, { unpack(opts), desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "LspRangeFormat",
            vim.lsp.buf.range_formatting,
            { range = true, desc = "LSP range format" }
        )
    end
end

null_ls.setup({
    sources = sources,
    on_attach = on_attach,
    -- capabilities = require'lsp.lsp-config'.capabilities
    debug = false,
})
