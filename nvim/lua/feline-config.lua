local force_inactive = {
    filetypes = {
        'NvimTree',
        'packer',
        'dashboard',
        'fugitive',
        'fugitiveblame',
        'qf',
        'help',
        'Trouble',
        'vista',
        'tagbar',
        'terminal', -- ../viml/autocommands.vim: autocmd TermOpen * setlocal filetype=terminal
        'dap%-repl'
    },
    buftypes = {
        'terminal'
    },
    bufnames = {}
}
-- local disable = {filetypes = {}, buftypes = {}, bufnames = {}}

local function get_color(hlgroup, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, 'gui')
end

local function update_component(component, updates)
    local new_component = {}
    for k, v in pairs(component) do
        new_component[k] = v
    end
    for k, v in pairs(updates) do
        new_component[k] = v
    end
    return new_component
end

-- local function update_components_list(components_list, updates)
--     for _, component in ipairs(components_list) do
--         for k, v in pairs(updates) do
--             component[k] = v
--         end
--     end
-- end


local tokyonight_colors = {
   black         = "#15161E",
   bg            = get_color('StatusLine', 'bg'),
   fg            = get_color('StatusLine', 'fg'),
   brightbg      = "#3b4261",

   red       = "#f7768e",
   orange    = "#ff9e64",
   orange2   = "#db4b4b",
   yellow    = "#e0af68",
   green     = "#9ece6a",
   aqua      = "#73daca",
   lightblue = "#b4f9f8",
   teal      = "#2ac3de",
   cyan      = "#7dcfff",
   blue      = "#7aa2f7",
   blue1     = "#3d59a1",
   blue2     = "#33467C",
   magenta   = "#bb9af7",
   purple    = "#9d7cd8",
   gray1     = "#c0caf5",
   -- fg        = "#c0caf5",
   gray2     = "#a9b1d6",
   gray3     = "#9aa5ce",
   white     = "#cfc9c2",
   gray4     = "#565f89",
   gray5     = "#414868",
   bg_highlight ="#292e42",
   bg1       = "#24283b",
   bg2       = "#1a1b26",
   diag_error = get_color('DiagnosticError', 'fg'),
   diag_warn = get_color('DiagnosticWarn', 'fg'),
   diag_hint = get_color('DiagnosticHint', 'fg'),
   diag_info = get_color('DiagnosticInfo', 'fg'),
   vcs_add = get_color('GitSignsAdd', 'fg'),
   vcs_del = get_color('GitSignsDelete', 'fg'),
   vcs_change = get_color('GitSignsChange', 'fg'),
}

local colors = tokyonight_colors

-- require('feline.providers').add_provider(name, function)
-- component = {
--    provider = function([component, winid]) -> str or str,
--    enabled = bool or function([winid]) -> bool
--    icon = table(str, hl), str or function() -> str
--    hl = table(fg=hex or name, bg, style, name), str to hl-group or function() -> table or str
--    left_sep = [list of ] str, table(str, hl, always_visible (bool)) or function() -> str or table
--    right_sap = [list of ] str, table(str, hl, always_visible (bool)) or function() -> str or table
-- }


local function is_in_list(val, list)
    for _, item in pairs(list) do
        if string.match(item, val) then return true end
    end
    return false
end

local function has_buftype(winid)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].buftype == '' then return false
    else return true end
end


local function hide_in_width(winid)
    return vim.fn.winwidth(winid) >= 100
end



local LeftCloser = {
    provider = '▊',
    right_sep = "  ",
    hl = {fg = "blue"}
}

local RightCloser = {
    provider = '▊',
    left_sep = " ",
    hl = {fg = "blue"}
}

local ViMode = {
    icon = ' ',
    provider = function()

        local mode_name = {
        n        = 'N ', no     = 'N?', nov    = 'N?', noV = 'N?',
        ['no'] = 'N?', niI    = 'Ni', niR    = 'Nr', niV = 'Nv',
        v        = 'V ', V      = 'V_', [''] = '^V', s   = 'S ',
        S        = 'S_', [''] = '^S', vs     = 'Vs', Vs  = 'Vs',
        ['s']  = 'Vs', i      = 'I ', ic     = 'Ic', ix  = 'Ix',
        R        = 'R ', Rc     = 'Rc', Rv     = 'Rv', Rx  = 'Rx',
        c        = 'C ', cv     = 'C ', r      = '> ', rm  = 'M ',
        ['r?']   = '? ', ['!']  = '! ', t      = 'T '
        }

        return mode_name[vim.fn.mode()] -- vim.fn.mode(1):upper()
    end,
    right_sep = {'right_rounded', '  '},
    left_sep = 'left_rounded',
    hl = function()
        local mode_color_table = {
            n      = {color = "red", name = 'NORMAL'},
            i      = {color = "green", name = 'INSERT'},
            v      = {color = "blue", name = 'VISUAL'},
            [''] = {color = "blue", name = 'VISUAL'},
            c      = {color = "orange", name = 'COMMAND'},
            s      = {color = "magenta", name = 'SELECT'},
            [''] = {color = "magenta", name = 'SELECT'},
            r      = {color = "yellow", name = 'REPLACE'},
            ['!']  = {color = "red", name = 'SHELL'},
            t      = {color = "green", name = 'TERMINAL'},
        }
        local mode = mode_color_table[string.sub(vim.fn.mode():lower(), 0, 1)]
        return {fg = mode.color, name = 'FelineViMode'..mode.name, bg='brightbg', style='bold'}
    end
    -- hl = {name = 'FelineViMode'}

}

local FileSize = {
    enabled = hide_in_width,
    provider = 'file_size',
    right_sep = " "
}

local FileName = {
    enabled = function(winid) return not has_buftype(winid) end,
    icon = '',
    provider = function(winid, component)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local path = vim.fn.fnamemodify(filename, ":~:.")
        path = path == '' and "[No Name]" or path
        if (not hide_in_width(winid)) or (#path > 0.29 * vim.fn.winwidth(winid)) then
            path = vim.fn.pathshorten(path)
        end

        local extension = vim.fn.fnamemodify(filename, ':e')
        local icon_str, icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        component.icon = { str = icon_str .. " ", hl = {fg = icon_color}}

        component.hl = {fg = "purple", style = "bold", name = 'FelineFileName'}
        component.right_sep = {}
        if vim.bo[bufnr].modified then
            table.insert(component.right_sep, {str = "[+]", hl = {fg = 'green', name='FelineFileFlagModified'}})
            component.hl = {fg = "magenta", style = "bold", name = 'FelineFileNameModified'}
        end
        if vim.bo[bufnr].readonly then
            table.insert(component.right_sep, {str = " ", hl = {fg = 'red', name='FelineFileFlagRO'}})
        end
        table.insert(component.right_sep, "%<  ")

        return path
    end,
}
local HelpFilename = {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        return vim.bo[bufnr].filetype == 'help'
    end,
    provider = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = {fg = 'blue'}
}

local GitBranch = {
    provider = 'git_branch',
    hl = {fg = "yellow"},
    right_sep = ' ',
}
local DiffAdd = {
    provider = 'git_diff_added',
    icon = '+',
    right_sep = ' ',
    hl = {fg = 'vcs_add'}
}
local DiffDel = {
    provider = 'git_diff_removed',
    icon = '-',
    right_sep = ' ',
    hl = {fg = 'vcs_del'},
}
local DiffChange = {
    provider = 'git_diff_changed',
    icon = '~',
    right_sep = ' ',
    hl = {fg = 'vcs_change'}
}

local DiagSep = {
    provider = ' ',
    enabled = function(_, winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        return not not vim.lsp.buf_get_clients(bufnr)
    end
}

local DiagErr = {
    provider = 'diagnostic_errors',
    icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
    hl = {fg = 'diag_error'},
    right_sep = ' '
}
local DiagWarn = {
    provider = 'diagnostic_warnings',
    icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
    hl = {fg = 'diag_warn'},
    right_sep = ' '
}
local DiagHint = {
    provider = 'diagnostic_hints',
    icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
    hl = {fg = 'diag_hint'},
    right_sep = ' '
}
local DiagInfo = {
    provider = 'diagnostic_info',
    icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
    hl = {fg = 'diag_info'},
    right_sep = ' '
}

local LSPMessages = {
    provider = function() return require('lsp-status').status() end,
    hl = {fg = 'gray4'},
    right_sep = ' '
}

local TSMessages = {
    provider = function() return require'nvim-treesitter'.statusline({indicator_size=50}) or '' end,
    hl={fg='gray4'},
    right_sep = ' '
}

local DAPMessages = {
    enabled = function(winid)
        local session = require'dap'.session()
        if session then
            local bufnr = vim.api.nvim_win_get_buf(winid)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            if session.config then
                local progname = session.config.program
                return filename == progname
            end
        end
        return false
    end,
    icon = ' ',
    provider = function() return require'dap'.status() end,
    hl = {fg = 'red'}
}
local FileType = {
    enabled = function(winid) return hide_in_width(winid) or has_buftype(winid) end,
    provider = 'file_type',
    hl = {fg='blue', style='bold' },
    right_sep = ' '
}

local InactiveFileType = update_component(FileType, {
    enabled = has_buftype,
    right_sep = {str = ' %q', hl = {fg = 'blue'}}
})

local FileFormat = {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        return vim.bo[bufnr].fileformat ~= 'unix' and hide_in_width()
    end,
    provider = function(_, winid) return vim.bo[vim.api.nvim_win_get_buf(winid)].fileformat:upper() end,
    hl = {fg = 'green'},
    right_sep = ' '
}
local FileEncoding = {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local enc = (vim.bo[bufnr].fenc ~= '' and vim.bo[bufnr].fenc) or vim.o.enc
        return enc ~= 'utf-8' and hide_in_width()
    end,
    provider = function(_, winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local enc = (vim.bo[bufnr].fenc ~= '' and vim.bo[bufnr].fenc) or vim.o.enc
        return enc:upper()
    end,
    hl = {fg = 'green'},
    right_sep = ' '
}
local Position = {
    provider = 'position',
    right_sep = ' ',
    -- left_sep = {str='vertical_bar', hl = {fg='blue'}}
    left_sep = ' '
}
local Percent = {
    enabled = hide_in_width,
    provider = 'line_percentage',
    right_sep = ' '
}
local ScrollBar = {
    provider = 'scroll_bar',
    hl = {fg='blue'}
}

local LSPActive = {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        return next(vim.lsp.buf_get_clients(bufnr)) ~= nil
    end,
    icon = ' ',
    provider = '[LSP]',
    hl = {fg = 'green', style='bold'},
    right_sep = ' '
}

local Snippet = {
    enabled = function()
        return vim.fn['UltiSnips#CanJumpForwards']() == 1 or vim.fn['UltiSnips#CanJumpBackwards']() == 1
    end,
    icon = {str = 'Snip: ', style = 'bold'},
    provider = function()
        local fwd = ""
        local bwd = ""
        if vim.fn['UltiSnips#CanJumpForwards']() == 1 then fwd =  "" end
        if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then bwd = " " end
        return  bwd .. fwd
    end,
    hl = {fg = 'gray3'}
}

local WorkDir = {
    provider = function(winid)
        local icon = (vim.fn.haslocaldir(winid) == 1 and 'l' or 'g') .. ' ' .. ' '
        local cwd = vim.fn.getcwd(winid)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if (not hide_in_width(winid)) or (#cwd > 0.29 * vim.fn.winwidth(winid)) then
            cwd = vim.fn.pathshorten(cwd)
        end
        return cwd..'/', icon
    end,
    right_sep = ' ',
    hl = {fg = 'blue1'},
}

local TerminalName = {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        return vim.bo[bufnr].buftype == 'terminal'
    end,
    icon = ' ', -- 
    provider = function(winid, _)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local tname, _ = vim.api.nvim_buf_get_name(bufnr):gsub(".*:", "")
        return tname
    end,
    hl = {fg = 'purple', style = 'bold'}
}

local TerminalMode = update_component(ViMode, {
    enabled = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local terminals = {"terminal", "dap-repl"}
        return vim.fn.index(terminals, vim.bo[bufnr].filetype) ~= -1 and bufnr == vim.api.nvim_win_get_buf(0)
    end,
})

local components = {
    active = {
        {
            -- LeftCloser,
            ViMode,
            WorkDir,
            FileName,
            GitBranch,
            DiffAdd,
            DiffDel,
            DiffChange,
            DiagSep,
            DiagErr,
            DiagWarn,
            DiagHint,
            DiagInfo
        },
        {
            LSPMessages,
            Snippet,
            -- TSMessages,
            DAPMessages
        },
        {
            LSPActive,
            FileSize,
            FileType,
            FileFormat,
            FileEncoding,
            Position,
            Percent,
            ScrollBar,
        }
    },
    inactive = {{TerminalMode, InactiveFileType, HelpFilename, TerminalName, FileName}, {}}
}

require"feline".setup{
    components = components,
    colors = colors,
    force_inactive = force_inactive,
    update_triggers = {'VimEnter', 'WinEnter', 'WinClosed', 'FileChangedShellPost', 'BufModifiedSet'},
    -- custom_providers = {},
    -- separators = {},
    -- disable = {}
}
