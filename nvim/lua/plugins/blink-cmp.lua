local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
---@module 'blink.cmp'
---@type blink.cmp.Config
local config = {
    keymap = {
        preset = 'default',
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    appearance = {
        nerd_font_variant = 'normal'
    },
    completion = {
        documentation = { auto_show = true, window = { border = vim.g.FloatBorders } },
        ghost_text = { enabled = true },
        menu = {
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local kind_icon = require("lsp.init").symbol_icons[ctx.kind]
                            return kind_icon
                        end,
                    }
                },
                columns = {
                    { "kind_icon" }, { 'label', 'label_description', gap = 1 }, { "kind" }
                },
            }
        },
        list = {
            selection = { preselect = false, auto_insert = true }
        }
    },
    cmdline = {
        keymap = {
            ["<CR>"] = { "accept", "fallback" },
            ["<C-N>"] = { "select_next",
                function(cmp)
                    vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                    return true
                end
            },
            ["<C-P>"] = { "select_prev",
                function(cmp)
                    vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                    return true
                end
            }
        }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 0,
                async = true,
            },
        },
    },
    signature = { enabled = true, window = { border = vim.g.FloatBorders } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
}
require("blink-cmp").setup(config)
