vim.lsp.handlers["textDocument/inlayHint"] = function() end

local M = {}

M.config = {
    current_line_only = false,
    current_line_au = { "CursorHold" },
    highlight = "NonText",
}

local enabled = false

local namespace = vim.api.nvim_create_namespace("inlayHints")

function M.send_request()
    enabled = true
    local params = vim.lsp.util.make_given_range_params()
    params["range"]["start"]["line"] = 0
    params["range"]["end"]["line"] = vim.api.nvim_buf_line_count(0) - 1
    vim.lsp.buf_request(0, "textDocument/inlayHint", params)
end

function M.disable()
    enabled = false
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

function M.toggle()
    if enabled then
        M.disable()
    else
        M.send_request()
    end
end

function set_mark(bufnr, ns, line, text)
    vim.api.nvim_buf_set_extmark(bufnr, namespace, line, 0, {
        virt_text = { { text, M.config.highlight } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    })
end

function M.handler(err, result, ctx, config)
    if err then
        return
    end
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
    local bufnr = ctx.bufnr
    for _, value in pairs(result) do
        -- local range = value.position
        -- local kind = value.kind
        local line = tonumber(value.position.line)
        local label = value.label

        if not (M.config.current_line_only and line + 1 ~= vim.api.nvim_win_get_cursor(0)[1]) then
            pcall(set_mark, {bufnr, namespace, line, label})
        end
    end
end

local augrp = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })

local function setup_au(bufnr)
    vim.api.nvim_create_autocmd({
        "TextChanged",
        "ModeChanged",
        M.config.current_line_only and unpack(M.config.current_line_au) or nil,
    }, {
        callback = function()
            if enabled then
                M.send_request()
            end
        end,
        group = augrp,
        buffer = bufnr,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            setup_au(args.buf)
            M.send_request()
        end
    end,
    group = augrp,
})

vim.api.nvim_create_user_command("InlayHintsToggle", M.toggle, {})

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
