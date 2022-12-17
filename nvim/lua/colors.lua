local g = vim.g

local M = {}

function M.get_color(hlgroup, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, "gui")
    -- return vim.api.nvim_get_hl_by_name(hlgroup, true)[attr]
end

-- vim.opt.background = "dark"

function M.gruvbox()
    g.gruvbox_material_background = "medium"
    g.gruvbox_material_palette = "original"
    g.gruvbox_material_enable_bold = 1
    g.gruvbox_material_enable_italic = 1
    g.gruvbox_material_sign_column_background = "none"
    g.gruvbox_material_diagnostic_virtual_text = "colored"
    vim.cmd("colorscheme gruvbox-material") -- this has to be specified last
end

function M.tokyonight()
    g.tokyonight_style = "night"
    g.tokyonight_sidebars = {} -- { "qf", "vista", "terminal", "packer", "NvimTree" , 'Trouble', 'tagbar' }
    vim.cmd("colorscheme tokyonight") -- this has to be specified last
    -- vim.cmd('hi VertSplit guifg=' .. require'colors'.get_color('Visual', 'bg')) -- .. ' guibg=' .. get_color('StatusLine', 'bg'))
end

function M.kanagawa(theme)
    vim.o.background = nil
    local colors = require("kanagawa.colors").setup({theme = theme})
    require("kanagawa").setup({
        dimInactive = false,
        globalStatus = true,
        overrides = {
            -- Pmenu = { fg = colors.fg_dark, bg = colors.bg_light0 },
            -- PmenuSel = { fg = "NONE", bg = colors.bg_light1 },
            -- PmenuSbar = { bg = colors.bg_dim },
            -- PmenuThumb = { bg = colors.bg_light1 },

            TelescopeNormal = { bg = colors.bg_dim },
            TelescopeBorder = { fg = colors.bg_dim, bg = colors.bg_dim},
            TelescopeTitle = { fg = colors.bg_light3, bold=true},

            TelescopePromptNormal = { bg = colors.bg_light0 },
            TelescopePromptBorder = { fg = colors.bg_light0, bg = colors.bg_light0},

            TelescopeResultsNormal = { bg = "#1a1a22" },
            TelescopeResultsBorder = { fg = "#1a1a22", bg = "#1a1a22" },

            TelescopePreviewNormal = { bg = colors.bg_dim },
            TelescopePreviewBorder = { bg = colors.bg_dim, fg = colors.bg_dim }
        },
        theme = theme,
    })
    vim.cmd("colorscheme kanagawa")
end

-- tokyonight()
-- gruvbox()
M.kanagawa("default")

return M
