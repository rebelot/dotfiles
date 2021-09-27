local vim = vim
local g = vim.g

-- some old stuff is for community gruvbox
-- g.gruvbox_italic = 1
-- g.gruvbox_sign_column = 'bg0'

function get_color(hlgroup, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, 'gui')
  -- return vim.api.nvim_get_hl_by_name(hlgroup, true)[attr]
end

vim.opt.background = "dark"

local function gruvbox()
    g.gruvbox_material_background = 'medium'
    g.gruvbox_material_palette = 'original'
    g.gruvbox_material_enable_bold = 1
    g.gruvbox_material_enable_italic = 1
    g.gruvbox_material_sign_column_background = 'none'
    g.gruvbox_material_diagnostic_virtual_text = 'colored'
    vim.cmd('colorscheme gruvbox-material') -- this has to be specified last
end

local function tokyonight()
    g.tokyonight_style = "night"
    g.tokyonight_sidebars = {} -- { "qf", "vista", "terminal", "packer", "NvimTree" , 'Trouble', 'tagbar' }
    vim.cmd('colorscheme tokyonight') -- this has to be specified last
    vim.cmd('hi VertSplit guifg=' .. get_color('Visual', 'bg')) -- .. ' guibg=' .. get_color('StatusLine', 'bg'))
end

tokyonight()
-- gruvbox()

-- temporary...
vim.cmd('hi link DiagnosticError LspDiagnosticsDefaultError')
vim.cmd('hi link DiagnosticWarn LspDiagnosticsDefaultWarning')
vim.cmd('hi link DiagnosticHint LspDiagnosticsDefaultHint')
vim.cmd('hi link DiagnosticInfo LspDiagnosticsDefaultInformation')

vim.cmd('hi link LspDiagnosticsSignError LspDiagnosticsDefaultError')
vim.cmd('hi link LspDiagnosticsSignWarning LspDiagnosticsDefaultWarning')
vim.cmd('hi link LspDiagnosticsSignHint LspDiagnosticsDefaultHint')
vim.cmd('hi link LspDiagnosticsSignInformation LspDiagnosticsDefaultInformation')

vim.fn.sign_define('DiagnosticSignError', { text = "" , texthl= 'DiagnosticSignError'})
vim.fn.sign_define('DiagnosticSignWarn', { text = "", texthl= 'DiagnosticSignWarn'})
vim.fn.sign_define('DiagnosticSignInfo', { text = "", texthl= 'DiagnosticSignInfo'})
vim.fn.sign_define('DiagnosticSignHint', { text = "" , texthl= 'DiagnosticSignHint'})

vim.cmd('hi DiagnosticUnderlineError gui=undercurl guisp=' .. get_color('DiagnosticError', 'fg'))
vim.cmd('hi DiagnosticUnderlineWarn gui=undercurl guisp=' .. get_color('DiagnosticWarn', 'fg'))
vim.cmd('hi DiagnosticUnderlineInfo gui=undercurl guisp=' .. get_color('DiagnosticInfo', 'fg'))
vim.cmd('hi DiagnosticUnderlineHint gui=undercurl guisp=' .. get_color('DiagnosticHint', 'fg'))


-- Colorscheme Overrides {{{
-- vim.cmd('hi! link SpecialKey Blue')
-- vim.cmd('hi! link pythonDot GruvboxRed')
--}}}

-- Highlights {{{
-- vim.cmd('hi LspReferenceRead gui=underline guisp=yellow')
-- vim.cmd('hi LspReferenceText gui=underline guisp=yellow')
-- vim.cmd('hi LspReferenceWrite gui=underline guisp=yellow')

-- vim.cmd("exe 'hi LspReferenceRead gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
-- vim.cmd("exe 'hi LspReferenceText gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
-- vim.cmd("exe 'hi LspReferenceWrite gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
-- vim.cmd("exe 'hi LspSignatureActiveParameter gui=underline guisp=' . synIDattr(synIDtrans(hlID('Search')), 'bg', 'gui')")


-- Spell {{{
-- vim.cmd('hi link SpellBad ErrorText')
-- vim.cmd('hi link SpellLocal WarningText')
-- vim.cmd('hi link SpellCap HintText')
-- vim.cmd('hi link SpellRare InfoText')
-- }}}

-- python syntax {{{
-- https://stackoverflow.com/questions/18774910/how-to-partially-link-highlighting-groups
-- exe 'hi pythonClassVar gui=italic guifg=' . synIDattr(synIDtrans(hlID('pythonClassVar')), 'fg', 'gui')
-- exe 'hi pythonBuiltinType gui=italic guifg=' . synIDattr(synIDtrans(hlID('pythonBuiltinType')), 'fg', 'gui')
-- vim.cmd("exe 'hi SignColumn guibg=' . synIDattr(synIDtrans(hlID('normal')), 'bg', 'gui')")
-- vim.cmd("exe 'hi pythonBuiltinType gui=italic guifg=' . synIDattr(synIDtrans(hlID('Aqua')), 'fg', 'gui')")
-- vim.cmd("exe 'hi pythonClassVar gui=italic guifg=' . synIDattr(synIDtrans(hlID('Blue')), 'fg', 'gui')")
-- vim.cmd('hi link pythonClass AquaBold')
-- exe 'hi pythonClass gui=bold guifg=' . synIDattr(synIDtrans(hlID('GruvboxAquaBold')), 'fg', 'gui')

