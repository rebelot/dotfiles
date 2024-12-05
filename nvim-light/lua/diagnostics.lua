local namespace = vim.api.nvim_create_namespace("diagnostics")

vim.api.nvim_create_user_command("Diagnostics", function(args)
    local bufnr = vim.api.nvim_get_current_buf()
    local set = function()
        vim.cmd(string.format("cgetexpr system(expandcmd('%s'))", args.args))
        vim.diagnostic.set(namespace, bufnr, vim.diagnostic.fromqflist(vim.fn.getqflist()), {})
    end
    local augrp = vim.api.nvim_create_augroup("diagnostic_refresh", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost",  {
        callback = set,
        buffer = bufnr,
        group = augrp
    })
    set()
end, { nargs = "+" })
