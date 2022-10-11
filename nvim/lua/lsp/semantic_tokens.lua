local M = {}

local last_tick = {}
local last_successful_tick = {}
local active_requests = {}

---@private
local function get_bit(n, k)
    --todo(theHamsta): remove once `bit` module is available for non-LuaJIT
    if _G.bit then
        return _G.bit.band(_G.bit.rshift(n, k), 1)
    else
        return math.floor((n / math.pow(2, k)) % 2)
    end
end

---@private
local function modifiers_from_number(x, modifiers_table)
    local modifiers = {}
    for i = 0, #modifiers_table - 1 do
        local bit = get_bit(x, i)
        if bit == 1 then
            table.insert(modifiers, 1, modifiers_table[i + 1])
        end
    end

    return modifiers
end

--- |lsp-handler| for the method `textDocument/semanticTokens/full`
---
--- This function can be configured with |vim.lsp.with()| with the following options for `config`
---
--- `on_token`: A function with signature `function(ctx, token)` that is called
---             whenever a semantic token is received from the server from context `ctx`
---             (see |lsp-handler| for the definition of `ctx`). This can be used for highlighting the tokens.
---             `token` is a table:
---
--- <pre>
---   {
---         line             -- line number 0-based
---         start_char       -- start character 0-based (in Unicode characters, not in byte offset as
---                          -- required by most of Neovim's API. Conversion might be needed for further
---                          -- processing!)
---         length           -- length in characters of this token
---         type             -- token type as string (see https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#semantic-token-classification)
---         modifiers        -- token modifier as string (see https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#semantic-token-classification)
---         offset_encoding  -- offset encoding used by the language server (see |lsp-sync|)
---   }
--- </pre>
---
--- `on_invalidate_range`: A function with signature `function(ctx, line_start, line_end)` called whenever tokens
---                        in a specific line range (`line_start`, `line_end`) should be considered invalidated
---                        (see |lsp-handler| for the definition of `ctx`). `line_end` can be -1 to
---                        indicate invalidation until the end of the buffer.
function M.on_full(err, response, ctx, config)
    active_requests[ctx.bufnr] = false
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end
    -- if tick has changed our response is outdated!
    -- FIXME: this is should be done properly here and in the codelens implementation. Handlers should
    -- not be responsible of checking whether their responses are still valid.
    if
        err
        or not response
        or not config.on_token
        or last_tick[ctx.bufnr] ~= vim.api.nvim_buf_get_changedtick(ctx.bufnr)
    then
        return
    end
    if config and config.on_invalidate_range then
        config.on_invalidate_range(ctx, 0, -1)
    end
    local legend = client.server_capabilities.semanticTokensProvider.legend
    local token_types = legend.tokenTypes
    local token_modifiers = legend.tokenModifiers
    local data = response.data

    local line
    local start_char = 0
    for i = 1, #data, 5 do
        local delta_line = data[i]
        line = line and line + delta_line or delta_line
        local delta_start = data[i + 1]
        start_char = delta_line == 0 and start_char + delta_start or delta_start

        -- data[i+3] +1 because Lua tables are 1-indexed
        local token_type = token_types[data[i + 3] + 1]
        local modifiers = modifiers_from_number(data[i + 4], token_modifiers)

        local token = {
            line = line,
            start_char = start_char,
            length = data[i + 2],
            type = token_type,
            modifiers = modifiers,
            offset_encoding = client.offset_encoding,
        }

        if token_type and config and config.on_token then
            config.on_token(ctx, token)
        end
    end
    last_successful_tick[ctx.bufnr] = last_tick[ctx.bufnr]
end

--- |lsp-handler| for the method `textDocument/semanticTokens/refresh`
---
function M.on_refresh(err, _, ctx, _)
    if not err then
        for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
            M.refresh(bufnr)
        end
    end
    return vim.NIL
end

---@private
function M._save_tick(bufnr)
    last_tick[bufnr] = vim.api.nvim_buf_get_changedtick(bufnr)
    active_requests[bufnr] = true
end

--- Refresh the semantic tokens for the current buffer
---
--- It is recommended to trigger this using an autocmd or via keymap.
---
--- <pre>
---   autocmd BufEnter,CursorHold,InsertLeave <buffer> lua require 'vim.lsp.semantic_tokens'.refresh(vim.api.nvim_get_current_buf())
--- </pre>
---
--- @param bufnr number
function M.refresh(bufnr)
    vim.validate({ bufnr = { bufnr, "number" } })
    if bufnr == 0 then
        bufnr = vim.api.nvim_get_current_buf()
    end
    if not active_requests[bufnr] then
        local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
        if not last_successful_tick[bufnr] or last_successful_tick[bufnr] < vim.api.nvim_buf_get_changedtick(bufnr) then
            M._save_tick(bufnr)
            vim.lsp.buf_request(bufnr, "textDocument/semanticTokens/full", params)
        end
    end
end

function M.extend_capabilities(caps)
    caps.textDocument.semanticTokens = {
        dynamicRegistration = false,
        tokenTypes = {
            "namespace",
            "type",
            "class",
            "enum",
            "interface",
            "struct",
            "typeParameter",
            "parameter",
            "variable",
            "property",
            "enumMember",
            "event",
            "function",
            "method",
            "macro",
            "keyword",
            "modifier",
            "comment",
            "string",
            "number",
            "regexp",
            "operator",
            "decorator",
        },
        tokenModifiers = {
            "declaration",
            "definition",
            "readonly",
            "static",
            "deprecated",
            "abstract",
            "async",
            "modification",
            "documentation",
            "defaultLibrary",
        },
        formats = { "relative" },
        requests = {
            -- TODO(smolck): Add support for this
            -- range = true;
            full = { delta = false },
        },

        overlappingTokenSupport = true,
        -- TODO(theHamsta): Add support for this
        multilineTokenSupport = false,
    }
    return caps
end

local ns = vim.api.nvim_create_namespace("nvim-semantic-tokens")

local defined_hl = {}
M.defined_hl = defined_hl

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

local function resolve_hl(token)
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

local function on_token(ctx, token)
    local linenr = token.line
    local start_col = vim.fn.virtcol2col(0, linenr + 1, token.start_char)
    local end_col = vim.fn.virtcol2col(0, linenr + 1, token.start_char + token.length)
    if start_col < 0 or end_col < 0 then
        return
    end
    local hl = resolve_hl(token)
    vim.api.nvim_buf_set_extmark(ctx.bufnr, ns, linenr, start_col, {
        end_col = end_col,
        hl_group = hl,
        priority = 110,
    })
end

local function clear_highlights(ctx, line_start, line_end)
    vim.api.nvim_buf_clear_namespace(ctx.bufnr, ns, line_start, line_end)
end

vim.lsp.handlers["textDocument/semanticTokens/full"] = vim.lsp.with(M.on_full, {
    on_token = on_token,
    on_invalidate_range = clear_highlights,
})

vim.lsp._request_name_to_capability["textDocument/semanticTokens/full"] = { "semanticTokensProvider" }
function vim.lsp.buf.semantic_tokens_full()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    M._save_tick(vim.api.nvim_get_current_buf())
    return vim.lsp.buf_request(0, "textDocument/semanticTokens/full", params)
end

function vim.lsp.buf.semantic_tokens_range(start_pos, end_pos)
    local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
    vim.lsp.buf_request(
        0,
        "textDocument/semanticTokens/range",
        params,
        vim.lsp.with(M.on_full, {
            on_token = function(ctx, token)
                vim.notify(token.type .. "." .. table.concat(token.modifiers, "."))
            end,
        })
    )
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

--config
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local caps = client.server_capabilities
        if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            local augrp = vim.api.nvim_create_augroup("LSP_semantic_tokens", { clear = true })
            vim.api.nvim_clear_autocmds({
                buffer = bufnr,
                group = augrp,
            })
            vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
                callback = vim.lsp.buf.semantic_tokens_full,
                group = augrp,
                buffer = bufnr,
                desc = "LSP semantic tokens",
            })
            vim.lsp.buf.semantic_tokens_full()
        end
    end,
})

M.hl_map = {
    namespace = "TSNamespace",
    -- module = "",
    type = "TSType",
    class = "TSType",
    enum = "TSField",
    interface = "TSType",
    struct = "TSType",
    typeParameter = "TSParameter",
    parameter = "TSParameter",
    builtinConstant = "Special",
    variable = {
        -- "TSVariable",
        static = "TSConstant",
        readonly = "TSConstant",
        defaultLibrary = "Special",
        builtin = "Special",
    },
    property = "TSProperty",
    enumMember = "TSField",
    event = "TSType",
    ["function"] = { "TSFunction", defaultLibrary = "Special", builtin = "Special", static = "TSFunction" },
    magicFunction = "Special",
    method = "TSMethod",
    macro = "TSPreProc",
    keyword = { "TSKeyword", documentation = "TSAttribute" },
    modifier = "LspModifier",
    comment = "TSComment",
    string = "TSString",
    number = "TSNumber",
    regexp = "TSStringRegex",
    operator = "TSOperator",
}

M.make_highlights(M.hl_map)

return M
