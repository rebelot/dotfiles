local function wininput(opts, on_confirm, win_opts)
    -- {listed, scratch}
    local buf = vim.api.nvim_create_buf(false, false)
    vim.bo[buf].buftype = "prompt"
    vim.bo[buf].bufhidden = "wipe"

    local prompt = "> " --opts.prompt or ""
    local default_text = opts.default or ""

    local deferred_callback = function(input)
        vim.defer_fn(function()
            on_confirm(input)
        end, 10)
    end

    vim.fn.prompt_setcallback(buf, deferred_callback)
    vim.fn.prompt_setprompt(buf, prompt)

    vim.keymap.set({ "i", "n" }, "<CR>", "<CR><Esc>:close!<CR>:stopinsert<CR>", { silent = true, buffer = buf })
    vim.keymap.set("n", "<esc>", "<cmd>close!<CR>", { silent = true, buffer = buf })
    vim.keymap.set("n", "q", "<cmd>close!<CR>", { silent = true, buffer = buf })

    local default_win_opts = {
        relative = "editor",
        row = vim.o.lines / 2 - 1,
        col = vim.o.columns / 2 - 25,
        width = 50,
        height = 1,
        focusable = true,
        style = "minimal",
        border = "none",
        title = opts.prompt
    }

    win_opts = vim.tbl_deep_extend("force", default_win_opts, win_opts)
    win_opts.width = #default_text + #prompt + 5 < win_opts.width and win_opts.width or #default_text + #prompt + 5

    local win = vim.api.nvim_open_win(buf, true, win_opts)
    vim.wo[win].winhighlight = "Search:None"

    vim.cmd("startinsert!")
    vim.defer_fn(function()
        vim.api.nvim_buf_set_text(buf, 0, #prompt, 0, #prompt, { default_text })
        vim.cmd("startinsert!")
    end, 10)
end

-- wininput({
--     prompt = "Enter a number: ",
--     default = "42",
--     },
--     function(input)
--         print("input: " .. input)
--     end,
--     {}
-- )

local orig_ui_input = vim.ui.input
vim.api.nvim_create_namespace("winui")
vim.ui.input = function(opts, on_confirm)
    local ft = vim.bo.filetype
    if vim.tbl_contains({"TelescopePrompt", "NvimTree"}, ft) then
        orig_ui_input(opts, on_confirm)
    else
        wininput(
            opts,
            on_confirm,
            { border = vim.g.FloatBorders, relative = "cursor", row = 1, col = 0, width = 1 }
        )
    end
end
