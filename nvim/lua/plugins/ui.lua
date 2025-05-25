return {
    {
        "rebelot/kanagawa.nvim",
        dev = true,
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.o.background = nil
            local c = require("kanagawa.lib.color")
            -- vim.cmd("set bg=")
            vim.o.cmdheight = 0
            -- vim.o.pumblend = 10

            require("kanagawa").setup({
                compile = true,
                dimInactive = false,
                -- transparent = true,
                background = { light = "lotus", dark = "wave" },
                -- colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
                overrides = function(colors)
                    local theme = colors.theme
                    local function blend_bg(diag)
                        return { fg = diag, bg = c(diag):blend(theme.ui.bg, 0.95):to_hex() }
                    end

                    return {
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                        NormalFloat = { bg = "none" },
                        FloatTitle = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                        TroubleNormal = { link = "NormalDark" },
                        TroubleNormalNC = { link = "TroubleNormal" },
                        NeoTreeNormal = { link = "NormalDark" },
                        NeoTreeNormalNC = { link = "NeoTreeNormal" },
                        DiagnosticVirtualTextError = blend_bg(theme.diag.error),
                        DiagnosticVirtualTextWarn = blend_bg(theme.diag.warning),
                        DiagnosticVirtualTextHint = blend_bg(theme.diag.hint),
                        DiagnosticVirtualTextInfo = blend_bg(theme.diag.info),
                        DiagnosticVirtualTextOk = blend_bg(theme.diag.ok),
                        -- LspInlayHint = { fg = theme.ui.special },
                        -- EndOfBuffer = { link = 'NonText' }
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa")
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "kanagawa*",
                callback = function()
                    if vim.o.background == "light" then
                        vim.fn.system("kitty +kitten themes Kanagawa_light")
                        -- vim.fn.system("~/.config/alacritty/switch_theme kanagawa_lotus.toml")
                    elseif vim.o.background == "dark" then
                        vim.fn.system("kitty +kitten themes Kanagawa")
                        -- vim.fn.system("~/.config/alacritty/switch_theme kanagawa_wave.toml")
                    end
                end,
            })
        end,
    },

    { "rebelot/lucy.nvim", lazy = false, dev = true, enabled = false },

    {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
        -- config = true,
        opts = {
            default = true,
        },
    },

    {
        "rebelot/heirline.nvim",
        dev = true,
        -- event = "VimEnter",
        event = "BufEnter",
        enabled = true,
        config = function()
            require("plugins.heirline")
        end,
    },

    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        opts = { bar_len = 60 },
    },

}
