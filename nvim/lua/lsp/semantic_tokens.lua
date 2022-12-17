local M = {}

local defined_hl = {}
M.defined_hl = defined_hl

local STHighlighter = vim.lsp.semantic_tokens.__STHighlighter

local function chain_link_hl(hl_tbl, hl_name)
    if defined_hl[hl_name] then
        return
    end

    table.remove(hl_tbl)
    local hl_base_name = next(hl_tbl) and "Lsp." .. table.concat(hl_tbl, ".") or nil

    vim.api.nvim_set_hl(0, hl_name, { default = true, link = hl_base_name })
    defined_hl[hl_name] = true

    if hl_base_name then
        chain_link_hl(hl_tbl, hl_base_name)
    end
end

local function highlighter(token)
    local hl
    if token.modifiers then
        hl = { token.type, unpack(token.modifiers) }
    else
        hl = { token.type }
    end
    local hl_name = "Lsp." .. table.concat(hl, ".")

    chain_link_hl(hl, hl_name)

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
                        hl_group = highlighter(token),
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


function M.make_highlights(hl_map)
    for key, val in pairs(hl_map) do
        if type(val) == "table" then
            for k, v in pairs(val) do
                local name = key .. ((type(k) == "number" and "") or ("." .. k))
                M.make_highlights({ [name] = v })
            end
        else
            vim.api.nvim_set_hl(0, "Lsp." .. key, { link = val })
        end
    end
end

--TODO:
M.hl_map = {
    namespace = "@namespace",
    -- module = "",
    type = "@type",
    class = "@type",
    enum = "@field",
    interface = "@type",
    struct = "@type",
    typeParameter = "@parameter",
    parameter = "@parameter",
    selfParameter = "@variable.builtin",
    builtinConstant = "Special",
    variable = {
        -- "@variable",
        global = "@constant",
        static = "@constant",
        readonly = "@constant",
        defaultLibrary = "Special",
        builtin = "Special",
    },
    property = "@property",
    enumMember = "@field",
    event = "@type",
    ["function"] = {
        "@function",
        defaultLibrary = "Special",
        builtin = "Special",
        static = "@function",
    },
    magicFunction = "Special",
    method = "@method",
    macro = "@preproc",
    keyword = {
        "@keyword",
        documentation = "@attribute",
    },
    -- modifier = "LspModifier",
    -- comment = "@comment",
    string = "@string",
    number = "@number",
    regexp = "@string.regex",
    operator = { "@operator", controlFlow = "@exception" },
}

M.make_highlights(M.hl_map)

return M
