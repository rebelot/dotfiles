local api = vim.api
local util = require("vim.lsp.util")
local STHighlighter = vim.lsp.semantic_tokens.__STHighlighter

local M = {}

M.hl_table = {}
local bufnr_to_ft_cache = {}
local hl_cache = {}

function M.clear_cache()
    for k, _ in pairs(hl_cache) do
        hl_cache[k] = nil
    end
end

local function highlighter(token, bufnr)
    local ft = bufnr_to_ft_cache[bufnr]
    if not ft then
        ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        bufnr_to_ft_cache[bufnr] = ft
    end
    local hl = { token.type, unpack(token.modifiers or {}) }
    local hl_name = "@" .. table.concat(hl, ".") .. "." .. ft

    if hl_cache[hl_name] then
        return hl_name
    end

    local hl_spec = {}
    local priority = 0
    for pattern, spec in pairs(M.hl_table) do
        if string.match(hl_name, pattern) then
            local spec_priority = spec.priority or 0
            local mode = spec_priority >= priority and "force" or "keep"
            priority = spec_priority
            hl_spec = vim.tbl_extend(mode, hl_spec, spec)
        end
    end
    hl_spec.priority = nil
    if next(hl_spec) then
        vim.api.nvim_set_hl(0, hl_name, hl_spec)
    end
    hl_cache[hl_name] = true
    return hl_name
end

local function binary_search(tokens, line)
    local lo = 1
    local hi = #tokens
    while lo < hi do
        local mid = math.floor((lo + hi) / 2)
        if tokens[mid].line < line then
            lo = mid + 1
        else
            hi = mid
        end
    end
    return lo
end

function STHighlighter:on_win(topline, botline)
    for _, state in pairs(self.client_state) do
        local current_result = state.current_result
        if current_result.version and current_result.version == util.buf_versions[self.bufnr] then
            if not current_result.namespace_cleared then
                api.nvim_buf_clear_namespace(self.bufnr, state.namespace, 0, -1)
                current_result.namespace_cleared = true
            end

            local highlights = current_result.highlights
            local idx = binary_search(highlights, topline)

            for i = idx, #highlights do
                local token = highlights[i]

                if token.line > botline then
                    break
                end

                if not token.extmark_added then
                    api.nvim_buf_set_extmark(self.bufnr, state.namespace, token.line, token.start_col, {
                        hl_group = highlighter(token, self.bufnr),
                        end_col = token.end_col,
                        priority = vim.highlight.priorities.semantic_tokens,
                        end_right_gravity = true,
                        strict = false,
                    })

                    token.extmark_added = true
                end
            end
        end
    end
end

function M.setup(hl_table)
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            M.clear_cache()
        end,
    })
    M.hl_table = hl_table
end

return M
