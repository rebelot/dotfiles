local vim = vim
local g = vim.g

-- g.gruvbox_italic = 1
-- g.gruvbox_sign_column = 'bg0'
vim.opt.background = "dark"
g.gruvbox_material_background = 'medium'
g.gruvbox_material_palette = 'original'
g.gruvbox_material_enable_italic = 1
g.gruvbox_material_enable_bold = 1
g.gruvbox_material_enable_italic = 1
g.gruvbox_material_sign_column_background = 'none'
g.gruvbox_material_diagnostic_virtual_text = 'colored'
vim.cmd('colorscheme gruvbox-material') -- this has to be specified last

require'nvim-web-devicons'.setup()

-- Colorscheme Overrides {{{
vim.cmd('hi! link SpecialKey Blue')
-- vim.cmd('hi! link pythonDot GruvboxRed')
--}}}

-- Highlights {{{
-- vim.cmd('hi LspReferenceRead gui=underline guisp=yellow')
-- vim.cmd('hi LspReferenceText gui=underline guisp=yellow')
-- vim.cmd('hi LspReferenceWrite gui=underline guisp=yellow')
vim.cmd("exe 'hi LspReferenceRead gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
vim.cmd("exe 'hi LspReferenceText gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
vim.cmd("exe 'hi LspReferenceWrite gui=underline guisp=' . synIDattr(synIDtrans(hlID('Yellow')), 'fg', 'gui') . ' guibg=' . synIDattr(synIDtrans(hlID('Visual')), 'bg', 'gui')")
vim.cmd("exe 'hi LspSignatureActiveParameter gui=underline guisp=' . synIDattr(synIDtrans(hlID('Search')), 'bg', 'gui')")

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

