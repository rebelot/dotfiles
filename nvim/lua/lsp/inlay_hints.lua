local M = {}

local enabled = false

local namespace = vim.api.nvim_create_namespace("inlayHints")

function M.disable()
    enabled = false
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

function M.enable()
    enabled = true
    M.show()
end

function M.toggle()
    if enabled then
        M.disable()
    else
        M.enable()
    end
end

local function set_mark(bufnr, line, text, highlight)
    vim.api.nvim_buf_set_extmark(bufnr, namespace, line, 0, {
        virt_text = { { text, highlight } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    })
end

local function show_handler(err, result, ctx, config)
    if err or not result then
        return
    end
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
    local bufnr = ctx.bufnr
    for _, value in pairs(result) do
        local line = tonumber(value.position.line)
        local label = value.label
        if type(label) == "table" then
            label = label.value or label[1].value
        end
        pcall(set_mark, bufnr, line, label, config and config.highlight or "NonText")
    end
end

local function apply_edits_handler(err, result, ctx, config)
    if err or not result then
        return
    end
    local bufnr = ctx.bufnr
    local text_edits = {}
    for _, value in pairs(result) do
        if value.textEdits then
            for _, edit in pairs(value.textEdits) do
                table.insert(text_edits, edit)
            end
        end
    end
    if next(text_edits) ~= nil then
        vim.lsp.util.apply_text_edits(text_edits, bufnr, "utf-16")
    end
end

function M.show(start_pos, end_pos, config)
    if not enabled then
        return
    end
    start_pos = start_pos or { 1, 0 }
    end_pos = end_pos or { vim.api.nvim_buf_line_count(0) - 1, 0 }
    local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
    vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx, _)
        show_handler(err, result, ctx, config)
    end)
end

function M.apply(start_pos, end_pos, config)
    local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
    vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx, _)
        apply_edits_handler(err, result, ctx, config)
    end)
end

vim.lsp.handlers["textDocument/inlayHint"] = show_handler

-- config

local augrp = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })

local function setup_au(bufnr)
    vim.api.nvim_create_autocmd({
        "TextChanged",
        "InsertLeave",
    }, {
        callback = function() M.show() end,
        group = augrp,
        buffer = bufnr,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            setup_au(args.buf)
            M.enable()
        end
    end,
    group = augrp,
})

vim.api.nvim_create_user_command("InlayHintsToggle", M.toggle, {})
vim.api.nvim_create_user_command("InlayHintsApply", function(args)
    local start_pos, end_pos = { args.line1, 0 }, { args.line2, 0 }
    M.apply(start_pos, end_pos)
end, { range = true })

-- {
--     {
--         kind = 1,
--         label = " -> None",
--         position = {
--             character = 14,
--             line = 172,
--         },
--     },
--     {
--         kind = 1,
--         label = ": list[int] ",
--         position = {
--             character = 18,
--             line = 173,
--         },
--     },
-- }
return M
