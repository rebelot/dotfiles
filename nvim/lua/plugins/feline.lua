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
        'dap%-repl',
        'dapui_.*'
    },
    buftypes = {
        'terminal',
        'nofile'
    },
    bufnames = {}
}
-- local disable = {filetypes = {}, buftypes = {}, bufnames = {}}

local function get_color(hlgroup, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, 'gui')
end

local function copy_update_component(component, updates)
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
--    provider = function([component, opts]) -> str or str,
--    short_provider = function([component, opts]) -> str or str,
--    truncate_hide = bool
--    priority = int
--    enabled = bool or function() -> bool
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
    winid = winid or 0
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].buftype == '' then return false
    else return true end
end


local function hide_in_width(winid)
    winid = winid or 0
    return vim.fn.winwidth(winid) >= 100
end

local function is_focused()
    return vim.api.nvim_get_current_buf() == tonumber(vim.g.actual_curbuf)
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
    -- right_sep = {'right_rounded', '  '},
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

local Snippet = {
    -- enabled = function()
    --     return vim.fn['UltiSnips#CanJumpForwards']() == 1 or vim.fn['UltiSnips#CanJumpBackwards']() == 1
    -- end,
    -- icon = {str = 'Snip: ', style = 'bold'},
    provider = function()
        local fwd = ""
        local bwd = ""
        if vim.fn['UltiSnips#CanJumpForwards']() == 1 then
            fwd =  ""
        else
            fwd = ""
        end
        if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
            bwd = " "
        else
            bwd = ""
        end
        return  vim.tbl_contains({'s', 'i'}, vim.fn.mode()) and bwd..fwd or ''
    end,
    hl = {fg = 'red', bg = "brightbg", syle='bold'},
    right_sep = {
        {str = 'right_rounded', always_visible = true},
        {str = ' ', always_visible = true}
    },
}

local FileSize = {
    enabled = hide_in_width,
    provider = 'file_size',
    right_sep = " "
}

local FileName = {
    enabled = function(winid) return not has_buftype(winid) end,
    provider = function(component)
        local filename = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(filename, ":~:.")
        path = path == '' and "[No Name]" or path
        if (not hide_in_width()) or (#path > 0.29 * vim.fn.winwidth(0)) then
            path = vim.fn.pathshorten(path)
        end

        local extension = vim.fn.fnamemodify(filename, ':e')
        local icon_str, icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        local icon = { str = icon_str .. " ", hl = {fg = icon_color}}

        component.right_sep = {}
        if vim.bo.modified then
            table.insert(component.right_sep, {str = "[+]", hl = {fg = 'green', name='FelineFileFlagModified'}})
        end
        if vim.bo.readonly then
            table.insert(component.right_sep,  {str = " ", hl = {fg = 'red', name='FelineFileFlagRO'}})
        end
        table.insert(component.right_sep, "%<  ")
        return path, icon
    end,
    hl = function()
        if vim.bo.modified then
            return {fg = "magenta", style = "bold", name = 'FelineFileNameModified'}
        else
            return {fg = "purple", style = "bold", name = 'FelineFileName'}
        end
    end,
}

local HelpFilename = {
    enabled = function()
        return vim.bo.filetype == 'help'
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
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
    provider = '  ',
    enabled = function()
        return next(vim.lsp.buf_get_clients(0)) ~= nil
    end
}

local DiagErr = {
    provider = function()
        local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
        return count ~= 0 and tostring(count) or ''
    end,
    icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
    hl = {fg = 'diag_error'},
    right_sep = ' '
}
local DiagWarn = {
    provider = function()
        local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
        return count ~= 0 and tostring(count) or ''
    end,
    icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
    hl = {fg = 'diag_warn'},
    right_sep = ' '
}
local DiagHint = {
    provider = function()
        local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT})
        return count ~= 0 and tostring(count) or ''
    end,
    icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
    hl = {fg = 'diag_hint'},
    right_sep = ' '
}
local DiagInfo = {
    provider = function()
        local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})
        return count ~= 0 and tostring(count) or ''
    end,
    icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
    hl = {fg = 'diag_info'},
    right_sep = ' '
}

local LSPMessages = {
    enabled = function() return next(vim.lsp.buf_get_clients(0)) ~= nil end,
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
            local filename = vim.api.nvim_buf_get_name(0)
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
    enabled = function() return hide_in_width() or has_buftype() end,
    provider = 'file_type',
    hl = {fg='blue', style='bold' },
    right_sep = ' '
}

local InactiveFileType = copy_update_component(FileType, {
    enabled = has_buftype,
    right_sep = {str = ' %q', hl = {fg = 'blue'}}
})

local FileFormat = {
    enabled = function()
        return vim.bo.fileformat ~= 'unix' and hide_in_width()
    end,
    provider = function() return vim.bo.fileformat:upper() end,
    hl = {fg = 'green'},
    right_sep = ' '
}
local FileEncoding = {
    enabled = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        return enc ~= 'utf-8' and hide_in_width()
    end,
    provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
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
    enabled = function()
        return next(vim.lsp.buf_get_clients(0)) ~= nil
    end,
    icon = ' ',
    provider = '[LSP]',
    hl = {fg = 'green', style='bold'},
    right_sep = ' '
}

local WorkDir = {
    provider = function()
        local icon = (vim.fn.haslocaldir(0) == 1 and 'l' or 'g') .. ' ' .. ' '
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if (not hide_in_width()) or (#cwd > 0.22 * vim.fn.winwidth(0)) then
            cwd = vim.fn.pathshorten(cwd)
        end
        return cwd..'/', icon
    end,
    right_sep = ' ',
    hl = {fg = 'blue1'},
}

local TerminalName = {
    enabled = function()
        return vim.bo.buftype == 'terminal'
    end,
    icon = ' ', -- 
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return tname
    end,
    hl = {fg = 'purple', style = 'bold'}
}

local TerminalMode = copy_update_component(ViMode, {
    enabled = function()
        local terminals = {"terminal", "dap-repl"}
        return vim.fn.index(terminals, vim.bo.filetype) ~= -1 and is_focused()
    end,
})

local Spell = {
    enabled = function()
        return vim.wo.spell
    end,
    provider = 'SPELL',
    hl = {fg='yellow', style='bold'},
    right_sep = ' '
}

local Gps = {
	enabled = function()
		return require'nvim-gps'.is_available()
    end,
    provider = function()
		return require'nvim-gps'.get_location()
	end,
    hl = {fg = 'gray4'}
}

local UltestPassed = {
    enabled = function()
        return vim.api.nvim_call_function('ultest#is_test_file', {}) ~= 0
    end,
    icon = {str = vim.fn.sign_getdefined('test_pass')[1].text, hl = {fg = get_color('UltestPass', 'fg')}},
    provider = function()
        local status = vim.api.nvim_call_function('ultest#status', {})
        return tostring(status.passed)
    end,
    left_sep = '  ',
    right_sep = ' '
}

local UltestFailed = {
    enabled = function()
        return vim.api.nvim_call_function('ultest#is_test_file', {}) ~= 0
    end,
    icon = {str = vim.fn.sign_getdefined('test_fail')[1].text, hl = {fg = get_color('UltestFail', 'fg')}},
    provider = function()
        local status = vim.api.nvim_call_function('ultest#status', {})
        return tostring(status.failed)
    end,
    right_sep = ' '
}

local UltestTests = {
    enabled = function()
        return vim.api.nvim_call_function('ultest#is_test_file', {}) ~= 0
    end,
    provider = function()
        local status = vim.api.nvim_call_function('ultest#status', {})
        return tostring(status.tests - 1)
    end,
    left_sep = {str = 'of ', hl = {fg = colors.fg}}
}



local components = {
    active = {
        {
            -- LeftCloser,
            -- {provider = " ", hl={fg='green', style='bold'}}, -- 
            ViMode,
            Snippet,
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
            DiagInfo,
            UltestPassed,
            UltestFailed,
            UltestTests
        },
        {
            LSPMessages,
            Gps,
            -- TSMessages,
            DAPMessages,
        },
        {
            LSPActive,
            Spell,
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
    -- colors = colors,
    theme = colors,
    components = components,
    force_inactive = force_inactive,
    -- highlight_reset_triggers = {}
    -- update_triggers = {'VimEnter', 'WinEnter', 'WinClosed', 'FileChangedShellPost', 'BufModifiedSet'},
    -- custom_providers = {},
    -- separators = {},
    -- disable = {}
}
