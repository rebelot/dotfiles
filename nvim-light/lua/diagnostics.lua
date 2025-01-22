vim.diagnostic.config({
    float = { source = true },
    virtual_text = { enabled = true },
    severity_sort = true
})

-- function(diagnostic)
--     if diagnostic.severity == vim.diagnostic.severity.ERROR then
--         return string.format("E: %s", diagnostic.message)
--     end
--     return diagnostic.message
-- end

vim.keymap.set("n", "<leader>d", vim.diagnostic.setqflist)

local namespace = vim.api.nvim_create_namespace("diagnostics")

vim.api.nvim_create_user_command("Cgetprog", function(args)
    local bufnr = vim.api.nvim_get_current_buf()
    local set_diagnostics = function()
        vim.cmd(string.format("cgetexpr system(expandcmd('%s'))", args.args))
        vim.diagnostic.set(namespace, bufnr, vim.diagnostic.fromqflist(vim.fn.getqflist()), {})
    end
    set_diagnostics()

    local augrp = vim.api.nvim_create_augroup("diagnostic_refresh", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost",  {
        callback = set_diagnostics,
        buffer = bufnr,
        group = augrp
    })
end, { nargs = "+" })
