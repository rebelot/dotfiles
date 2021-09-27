local gl = require('galaxyline')
-- local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')
local gls = gl.section

function get_color(hlgroup, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, 'gui')
end

-- TODO:
-- add buftype icons (eg. terminal, qf, etx)
-- generalize color names

gl.short_line_list = {'help', 'NvimTree','vista','tagbar','dbui', 'packer', 'qf', 'dashboard', 'terminal', 'Trouble'}

local terminal_colors = {
    black         = vim.g.terminal_color_0,
    brightblack   = vim.g.terminal_color_8,
    red           = vim.g.terminal_color_1,
    brightred     = vim.g.terminal_color_9,
    green         = vim.g.terminal_color_2,
    brightgreen   = vim.g.terminal_color_10,
    yellow        = vim.g.terminal_color_3,
    brightyellow  = vim.g.terminal_color_11,
    blue          = vim.g.terminal_color_4,
    brightblue    = vim.g.terminal_color_12,
    magenta       = vim.g.terminal_color_5,
    brightmagenta = vim.g.terminal_color_13,
    cyan          = vim.g.terminal_color_6,
    brightcyan    = vim.g.terminal_color_14,
    white         = vim.g.terminal_color_7,
    brightwhite   = vim.g.terminal_color_15,
}

local tokyonight_colors = {
   black         = "#15161E",
   bg            = "#1f2335",
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
   fg        = "#c0caf5",
   gray2     = "#a9b1d6",
   gray3     = "#9aa5ce",
   white     = "#cfc9c2",
   gray4     = "#565f89",
   gray5     = "#414868",
   bg_highlight ="#292e42",
   bg1       = "#24283b",
   bg2       = "#1a1b26",
   diag = {
       error = get_color('LspDiagnosticsSignError', 'fg'),
       warn = get_color('LspDiagnosticsSignWarning', 'fg'),
       hint = get_color('LspDiagnosticsSignHint', 'fg'),
       info = get_color('LspDiagnosticsSignInformation', 'fg'),
   },
   vcs = {
      add = get_color('GitSignsAdd', 'fg'),
      del = get_color('GitSignsDelete', 'fg'),
      change = get_color('GitSignsChange', 'fg'),
  }
}

--    base00 - Default Background
--    base01 - Lighter Background (Used for status bars, line number and folding marks)
--    base02 - Selection Background
--    base03 - Comments, Invisibles, Line Highlighting
--    base04 - Dark Foreground (Used for status bars)
--    base05 - Default Foreground, Caret, Delimiters, Operators
--    base06 - Light Foreground (Not often used)
--    base07 - Light Background (Not often used)
--    base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
--    base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
--    base0A - Classes, Markup Bold, Search Text Background
--    base0B - Strings, Inherited Class, Markup Code, Diff Inserted
--    base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
--    base0D - Functions, Methods, Attribute IDs, Headings
--    base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
--    base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

local base16_colors = {
   b00 = get_color('Normal', 'bg'),         -- Default Background
   b01 = get_color('LineNr', 'fg'),         -- Lighter Background (Used for status bars, line number and folding marks)
   b02 = get_color('Visual', 'bg'),         -- Selection Background
   b03 = get_color('Comments', 'fg'),       -- Comments, Invisibles, Line Highlighting
   b04 = get_color('StatusLineNC', 'bg'),   -- Dark Foreground (Used for status bars)
   b05 = get_color('Normal', 'fg'),         -- Default Foreground, Caret, Delimiters, Operators
   b06 = get_color('Normal', 'fg'),         -- Light Foreground (Not often used)
   b07 = get_color('Pmenu', 'bg'),          -- Light Background (Not often used)
   b08 = get_color('Identifier', 'fg'),     -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
   b09 = get_color('Constant', 'fg'),       -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
   b0A = get_color('Search', 'bg'),         -- Classes, Markup Bold, Search Text Background
   b0B = get_color('String', 'fg'),         -- Strings, Inherited Class, Markup Code, Diff Inserted
   b0C = get_color('Special', 'fg'),        -- Support, Regular Expressions, Escape Characters, Markup Quotes
   b0D = get_color('Function', 'fg'),       -- Functions, Methods, Attribute IDs, Headings
   b0E = get_color('Keyword', 'fg'),        -- Keywords, Storage, Selector, Markup Italic, Diff Changed
   b0F = get_color(''),                     -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
   diag = {
       error = get_color('LspDiagnosticsSignError', 'fg'),
       warn = get_color('LspDiagnosticsSignWarning', 'fg'),
       hint = get_color('LspDiagnosticsSignHint', 'fg'),
       info = get_color('LspDiagnosticsSignInformation', 'fg'),
   },
   vcs = {
      add = get_color('GitSignsAdd', 'fg'),
      del = get_color('GitSignsDelete', 'fg'),
      change = get_color('GitSignsChange', 'fg'),
  }
}

local colors = tokyonight_colors


local function not_in_short_line_list()
    for _, v in pairs(gl.short_line_list) do
        if vim.bo.filetype == v then
            return false
        end
    end
    return true
end

local function get_file_flag()
    if vim.bo.readonly then
        vim.api.nvim_command('hi GalaxyFileFlags guifg='..colors.red)
        return "  "
    elseif vim.bo.modifiable then
        if vim.bo.modified then
            vim.api.nvim_command('hi GalaxyFileFlags guifg='..colors.green)
            return "[+]"
        end
    end
end

local function highlight_file_changed()
  if vim.bo.modifiable then
    if vim.bo.modified then
      vim.api.nvim_command('hi GalaxyFileName guifg='..colors.magenta)
    else
      vim.api.nvim_command('hi GalaxyFileName guifg='..colors.purple)
    end
  end
end

local function smart_filename()
  local path = vim.fn.expand("%:p:~:.")
  if path == '' then return "[No Name]" end
    if (not condition.hide_in_width()) or (#path > 0.29 * vim.fn.winwidth(0)) then
      path = vim.fn.pathshorten(path)
    end
  return path
end

local function get_viMode()
  local mode_color = {
      n      = colors.red,
      i      = colors.green,
      v      = colors.blue,
      [''] = colors.blue,
      c      = colors.orange,
      s      = colors.magenta,
      [''] = colors.magenta,
      r      = colors.yellow,
      ['!']  = colors.red,
      t      = colors.green
   }

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

  vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[string.sub(vim.fn.mode():lower(), 0, 1)])
  return ' ' .. mode_name[vim.fn.mode()] -- vim.fn.mode(1):upper()
end

-- require('galaxyline').section.left[1]= {
--   ComponentName = {
--     provider = string matching default component or function -> str or table (for multiple providers),
--     condition = function -> bool load component when true
--     icon = string or function
--     highlight = {fg, bg, gui} or str highlight group
--     separator = string, expand statutsline items
--     separator_highlight = same as highlight
--     event = string. configure a plugin's event that will reload the statusline.
--   }
-- }

local i = 1
gls.left[i] = {
  RainbowRed = {      --   ▊
    provider = function() return '▊ ' end,
    highlight = {colors.blue,colors.bg}
  },
}

i = i + 1
gls.left[i] = {
  ViMode = {
    provider = get_viMode,
    separator = ' ',
    highlight = {"NONE", colors.bg, 'bold'},
    separator_highlight = {"NONE", colors.bg}
  },
}
i = i + 1
gls.left[i] = {
  FileSize = {
    provider = 'FileSize',
    condition = function() return condition.buffer_not_empty() and condition.hide_in_width() end,
    highlight = {colors.fg,colors.bg}
  }
}

-- i = i + 1
-- gls.left[i] = {
--     WorkDir = {
--         provider = function()
--             return ' ' .. (vim.fn.haslocaldir() == 1 and 'l' or 'g') end, --.. " " .. vim.fn.getcwd() end,
--         separator = ' ',
--         highlight = {colors.fg,colors.bg},
--         separator_highlight = {colors.fg,colors.bg}
--     }
-- }

i = i + 1
gls.left[i] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
}

i = i + 1
gls.left[i] = {
  FileName = {
    provider = function()
        highlight_file_changed()
        return smart_filename()
    end,

    highlight = {colors.magenta,colors.bg,'bold'},
  }
}
i = i + 1
gls.left[i] = {
  FileFlags = {
    -- condition = condition.buffer_not_empty,
    provider = get_file_flag,
    separator = " %<",
    highlight = {'NONE', colors.bg},
    separator_highlight = {'NONE', colors.bg}
  }
}

i = i + 1
gls.left[i] = {
  GitIcon = {
    provider = function() return '    ' end,
    condition = condition.check_git_workspace,
    -- separator = ' ',
    -- separator_highlight = {colors.yellow, colors.bg},
    highlight = {colors.gray, colors.bg,'bold'},
  }
}

i = i + 1
gls.left[i] = {
  GitBranch = {
    provider = 'GitBranch',
    separator = "  ",
    condition = condition.check_git_workspace,
    highlight = {colors.yellow, colors.bg,'bold'},
    separator_highlight = {colors.orange, colors.bg,'bold'},
  }
}

i = i + 1
gls.left[i] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '+',
    highlight = {colors.vcs.add,colors.bg},
  }
}
i = i + 1
gls.left[i] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = '~',
    highlight = {colors.vcs.change,colors.bg},
  }
}

i = i + 1
gls.left[i] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '-',
    highlight = {colors.vcs.del, colors.bg},
  }
}

i = i + 1
gls.left[i] = {
    DiagnosticSep = {
        provider = function() return "  " end,
        condition = function()
            if vim.lsp.buf_get_clients() then
                return true
            else
                return false
            end
        end,
        highlight = {'NONE', colors.bg}
    }
}
i = i + 1
gls.left[i] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = vim.fn.sign_getdefined('LspDiagnosticsSignError')[1].text,
    highlight = {colors.diag.error, colors.bg}
  }
}
i = i + 1
gls.left[i] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = vim.fn.sign_getdefined('LspDiagnosticsSignWarning')[1].text,
    highlight = {colors.diag.warn, colors.bg}
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = vim.fn.sign_getdefined('LspDiagnosticsSignHint')[1].text,
    highlight = {colors.diag.hint, colors.bg}
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = vim.fn.sign_getdefined('LspDiagnosticsSignInformation')[1].text,
    highlight = {colors.diag.info, colors.bg}
  }
}


require'lsp-status'.config{
  -- kind_labels = {},
  current_function = false,
  diagnostics = false,
  indicator_separator = '',
  component_separator = '',
  indicator_errors = ' ',
  indicator_warnings = ' ',
  indicator_info = ' ',
  indicator_hint = ' ',
  indicator_ok = ' ',
  spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
  -- status_symbol = '[LSP] ',
  status_symbol = '',
  select_symbol = nil,
  -- select_symbol = function(cursor_pos, symbol)
  --   if symbol.valueRange then
  --     local value_range = {
  --       ["start"] = {
  --         character = 0,
  --         line = vim.fn.byte2line(symbol.valueRange[1])
  --       },
  --       ["end"] = {
  --         character = 0,
  --         line = vim.fn.byte2line(symbol.valueRange[2])
  --       }
  --     }
  --     return require("lsp-status.util").in_range(cursor_pos, value_range)
  --   end
  -- end,
  update_interval = 100
}

i = 0
i = i + 1
gls.mid[i] = {
  ShowLspStatus = {
    provider = require'lsp-status'.status,
    condition = function()
        if vim.lsp.buf_get_clients() then
            return true
        else
            return false
        end
    end,
    highlight = {colors.gray4, colors.bg}
  }
}
i = i + 1
gls.mid[i] = {
  TreeSitter = {
    provider = function() return require'nvim-treesitter'.statusline({indicator_size=50}) end,
    highlight = {colors.gray4, colors.bg}
  }
}

i = 0
i = i + 1
gls.right[i] = {
  FileTypeName = {
    -- provider = 'FileTypeName',
    provider = function() return vim.bo.filetype:upper() end,
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

i = i + 1
gls.right[i] = {
  FileEncode = {
    provider = 'FileEncode',
    condition = function()
        return condition.hide_in_width() and not (vim.bo.fileencoding == 'utf-8' or vim.bo.fileencoding == '')
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

i = i + 1
gls.right[i] = {
  FileFormat = {
    provider = 'FileFormat',
    condition = function()
        return condition.hide_in_width() and (vim.bo.fileformat ~= 'unix')
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

i = i + 1
gls.right[i] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    icon = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

i = i + 1
gls.right[i] = {
  PerCent = {
    provider = 'LinePercent',
    icon = " ",
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'},
  }
}

i = i + 1
gls.right[i] = {
  RainbowBlue = {
    provider = function() return ' ▊' end,
    highlight = {colors.blue,colors.bg}
  },
}

i = 0
i = i + 1
gls.short_line_left[i] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' %q',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

i = i + 1
gls.short_line_left[i] = {
  SFileName = {
    condition = not_in_short_line_list,
    provider = smart_filename,
    highlight = {colors.fg,colors.bg,'bold'}
  }
}

i = i + 1
gls.short_line_left[i] = {
  FileFlags = {
    condition = not_in_short_line_list,
    provider = get_file_flag,
    separator = " %<",
    highlight = {'NONE', colors.bg},
    separator_highlight = {'NONE', colors.bg},
    event = 'TextChanged'
  }
}

i = 0
i = i + 1
gls.short_line_right[i] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.fg,colors.bg}
  }
}
