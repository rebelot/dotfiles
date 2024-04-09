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
    -- null_ls.builtins.formatting.latexindent,
    -- null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.formatting.lua_format,

    null_ls.builtins.formatting.prettier,

    null_ls.builtins.formatting.shfmt,
    -- null_ls.builtins.formatting.beautysh,
    null_ls.builtins.formatting.shellharden,
    -- null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.clang_format,

    -- null_ls.builtins.diagnostics.chktex,

    null_ls.builtins.diagnostics.cppcheck,

    -- null_ls.builtins.diagnostics.proselint,
    -- null_ls.builtins.diagnostics.write_good,

    null_ls.builtins.diagnostics.vint,

    null_ls.builtins.code_actions.gitsigns.with({ disabled_filetypes = { "NvimTree" } }),

    -- null_ls.builtins.code_actions.refactoring,
    -- null_ls.builtins.completion.spell,
}

local on_attach = function(client, bufnr)
    local map = function(mode, key, expr, opts)
        opts = vim.tbl_extend("keep", { noremap = true, silent = true, buffer = bufnr }, opts)
        return vim.keymap.set(mode, key, expr, opts)
    end
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "List LSP Code Actions" })
    if client.server_capabilities.documentFormattingProvider then
        -- set eventignore=all
        map("n", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { range = false, desc = "LSP format" })
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        map("x", "<leader>lf", function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end, { desc = "LSP range format" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspRangeFormat", function(args)
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                range = { start = { args.line1, 0 }, ["end"] = { args.line2, 0 } },
            })
        end, { range = true, desc = "LSP range format" })
    end
end

null_ls.setup({
    sources = sources,
    on_attach = on_attach,
    debug = false,
})
