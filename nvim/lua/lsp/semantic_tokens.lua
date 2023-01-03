local M = {}

local STHighlighter = vim.lsp.semantic_tokens.__STHighlighter

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
            local mode = spec_priority > priority and "force" or "keep"
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

--- on_win handler for the decoration provider (see |nvim_set_decoration_provider|)
---
--- If there is a current result for the buffer and the version matches the
--- current document version, then the tokens are valid and can be applied. As
--- the buffer is drawn, this function will add extmark highlights for every
--- token in the range of visible lines. Once a highlight has been added, it
--- sticks around until the document changes and there's a new set of matching
--- highlight tokens available.
---
--- If this is the first time a buffer is being drawn with a new set of
--- highlights for the current document version, the namespace is cleared to
--- remove extmarks from the last version. It's done here instead of the response
--- handler to avoid the "blink" that occurs due to the timing between the
--- response handler and the actual redraw.
---
---@private
function STHighlighter:on_win(topline, botline)
    for _, state in pairs(self.client_state) do
        local current_result = state.current_result
        if current_result.version and current_result.version == vim.lsp.util.buf_versions[self.bufnr] then
            if not current_result.namespace_cleared then
                vim.api.nvim_buf_clear_namespace(self.bufnr, state.namespace, 0, -1)
                current_result.namespace_cleared = true
            end

            -- We can't use ephemeral extmarks because the buffer updates are not in
            -- sync with the list of semantic tokens. There's a delay between the
            -- buffer changing and when the LSP server can respond with updated
            -- tokens, and we don't want to "blink" the token highlights while
            -- updates are in flight, and we don't want to use stale tokens because
            -- they likely won't line up right with the actual buffer.
            --
            -- Instead, we have to use normal extmarks that can attach to locations
            -- in the buffer and are persisted between redraws.
            local highlights = current_result.highlights
            local idx = binary_search(highlights, topline)

            for i = idx, #highlights do
                local token = highlights[i]

                if token.line > botline then
                    break
                end

                if not token.extmark_added then
                    -- `strict = false` is necessary here for the 1% of cases where the
                    -- current result doesn't actually match the buffer contents. Some
                    -- LSP servers can respond with stale tokens on requests if they are
                    -- still processing changes from a didChange notification.
                    --
                    -- LSP servers that do this _should_ follow up known stale responses
                    -- with a refresh notification once they've finished processing the
                    -- didChange notification, which would re-synchronize the tokens from
                    -- our end.
                    --
                    -- The server I know of that does this is clangd when the preamble of
                    -- a file changes and the token request is processed with a stale
                    -- preamble while the new one is still being built. Once the preamble
                    -- finishes, clangd sends a refresh request which lets the client
                    -- re-synchronize the tokens.
                    vim.api.nvim_buf_set_extmark(self.bufnr, state.namespace, token.line, token.start_col, {
                        hl_group = highlighter(token, self.bufnr),
                        end_col = token.end_col,
                        priority = vim.highlight.priorities.semantic_tokens,
                        strict = false,
                    })

                    --TODO(jdrouhard): do something with the modifiers

                    token.extmark_added = true
                end
            end
        end
    end
end

-- function M.make_highlights(hl_map)
--     for name, spec in pairs(hl_map) do
--         local hlname = name
--         for k, v in pairs(spec) do
--             if k == "hl" then
--                 v.default = true
--                 vim.api.nvim_set_hl(0, "@" .. name, v)
--             else
--                 hlname = name .. "." .. k
--                 M.make_highlights({ [hlname] = v })
--             end
--         end
--     end
-- end

-- M.hl_map = {
--     -- namespace = "@namespace",
--     module = { hl = { link = "@variable" } },
--     selfParameter = { hl = { link = "@variable.builtin" } },
--     builtinConstant = { hl = { link = "Special" } },
--     variable = {
--         hl = {},
--         global = { hl = { link = "@constant" } },
--         static = { hl = { link = "@constant" } },
--         readonly = { hl = { link = "@constant" } },
--         declaration = { readonly = { hl = { link = "@constant" } } },
--         defaultLibrary = { hl = { link = "Special" } },
--         builtin = { hl = { link = "Special" } },
--     },
--     ["function"] = {
--         hl = { link = "Function" },
--         defaultLibrary = { hl = { link = "Special" } },
--         builtin = { hl = { link = "Special" } },
--         static = { hl = { link = "@function" } },
--     },
--     magicFunction = { hl = { link = "Special" } },
--     keyword = {
--         hl = { link = "@keyword" },
--         documentation = { hl = { link = "@attribute" } },
--     },
--     operator = { controlFlow = { hl = { link = "@exception" } } },
-- }

-- M.make_highlights(M.hl_map)
M.hl_table = {
    module = { link = "@variable" },
    selfParameter = { link = "@variable.builtin" },
    builtinConstant = { link = "Special" },
    ["@variable.*global"] = { link = "@constant" },
    ["@variable.*static"] = { link = "@constant" },
    ["@variable.*readonly"] = { link = "@constant" },
    ["@variable.*defaultLibrary"] = { link = "Special" },
    ["@variable.*builtin"] = { link = "Special" },

    ["@function.*defaultLibrary"] = { link = "Special" },
    ["@method.*defaultLibrary"] = { link = "Special" },
    ["@function.*builtin"] = { link = "Special" },
    magicFunction = { link = "Special" },
    ["@keyword.*documentation"] = { link = "@attribute" },
    ["@operator.*controlFlow"] = { link = "@exception" },
    readonly = { link = "@constant" },
    -- builtin = { link = "Special" },
    -- defaultLibrary = { link = "Special" },
}

return M
