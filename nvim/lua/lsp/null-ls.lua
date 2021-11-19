local null_ls = require'null-ls'

local sources = {
    null_ls.builtins.formatting.isort.with({
        extra_args = {'--profile', 'black'}
    }),
    -- null_ls.builtins.formatting.yapf,
    -- null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.black,

    -- null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.pylint,

    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.formatting.lua_format,

    null_ls.builtins.formatting.prettier,

    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.shellcheck,

    null_ls.builtins.diagnostics.chktex,

    null_ls.builtins.diagnostics.cppcheck,

    null_ls.builtins.diagnostics.proselint,
    null_ls.builtins.diagnostics.write_good,

    null_ls.builtins.diagnostics.vint,

    null_ls.builtins.code_actions.gitsigns,

    null_ls.builtins.code_actions.refactoring,
    -- null_ls.builtins.completion.spell,
}


null_ls.config({
    sources = sources,
    debug = false})
require("lspconfig")["null-ls"].setup({
    on_attach = require'lsp.lsp-config'.on_attach,
    -- capabilities = require'lsp.lsp-config'.capabilities
})