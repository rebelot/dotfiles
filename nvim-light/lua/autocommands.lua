local augrp = vim.api.nvim_create_augroup("defaults", { clear = true })
local autocmd = vim.api.nvim_create_autocmd
autocmd("WinLeave", {
    command = [[set nornu nocul]],
    group = augrp
})

autocmd("WinEnter", {
    command = [[let &rnu=&nu | set cul]],
    group = augrp
})
autocmd("TextYankPost", {
    callback = function() vim.hl.on_yank({higroup='IncSearch', timeout=300}) end,
    group = augrp
})

autocmd("VimEnter", {
    command = [[
        aunmenu PopUp.How-to\ disable\ mouse
        aunmenu PopUp.-2-
    ]],
    group = augrp
})
