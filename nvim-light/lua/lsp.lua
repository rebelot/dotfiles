vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
        vim.keymap.set({"n", "x"}, "grf", vim.lsp.buf.format)

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        local augrp = vim.api.nvim_create_augroup("document_highlight", { clear = true })
        if client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function() vim.lsp.buf.document_highlight() end,
                buffer = bufnr,
                group = augrp,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = function() vim.lsp.buf.clear_references() end,
                buffer = args.buf,
                group = augrp,
            })
        end
    end,
})
