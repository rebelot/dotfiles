local vim = vim
local g = vim.g

-- Plugins
require "plugins"

-- plugin otions {{{

-- git--signs {{{
require("gitsigns").setup {
  -- signs = {
  --   add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn', show_count=true},
  --   change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn', show_count=true},
  --   delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn', show_count=true},
  --   topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn', show_count=true},
  --   changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn', show_count=true},
  --     },
  -- watch_index = {
  --   interval = 100
  -- },
  -- sign_priority = 5,
  -- status_formatter = nil, -- Use default
  keymaps = {},
}
-- }}}

-- Vista {{{
g.vista_echo_cursor_strategy = 'floating_win'
g.vista_default_executive = 'ctags'
g.vista_ctags_executable = 'uctags'
g.vista_executive_for = {
    cpp = 'nvim_lsp',
    python = 'nvim_lsp',
    markdown = 'nvim_lsp',
    lua = 'nvim_lsp'
    }
-- }}}

-- syntax and folds {{{
g.python_highlight_all = 1
g.python_highlight_file_headers_as_comments = 1
g.python_highlight_space_errors = 0
g.tex_flavor = 'latex'

-- }}}

-- Ale {{{
g.ale_floating_preview = 1
g.ale_set_highlights = 1
g.ale_sign_error = '' --  ⤫
g.ale_sign_warning = '' -- ﯧ  ﯦ   ⚠   
g.ale_lint_on_text_changed = 'always'
g.ale_fixers = {python = 'autopep8', sh = 'shfmt'}
g.ale_linters = {python = {'flake8', 'pylint', 'mypy'}}
g.ale_python_mypy_options = '--ignore-missing-imports'
g.ale_python_pylint_options = '--disable=C'
g.ale_python_flake8_options = '--ignore=E221,E241,E201'
g.ale_virtualenv_dir_names = {'.env', '.venv', 'env', 've-py3', 've', 'virtualenv', 'venv', '.ve', 'venvs'}
vim.cmd [[ let g:ale_pattern_options = {'\.py$': {'ale_enabled': 0}, '\.c[p]*$': {'ale_enabled': 0}} ]]
-- }}}

-- misc {{{
g.windowswap_map_keys = 0

g.peekaboo_compact = 0
g.peekaboo_window = 'vert bo 30 new'

g.matchup_override_vimtex = 1
g.matchup_matchparen_deferred = 1
g.matchup_matchparen_offscreen = {method= 'popup'}

g.virtualenv_directory = '~/venvs/'

g.delimitMate_expand_inside_quotes = 0
g.delimitMate_jump_expansion = 1
g.delimitMate_expand_cr = 2
g.delimitMate_expand_space = 1
g.delimitMate_nesting_quotes = {'"','`'}


-- g.UltiSnipsExpandTrigger = '<c-j>'
g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
g.UltiSnipsJumpForwardTrigger = '<c-j>'
g.UltiSnipsJumpBackwardTrigger = '<c-k>'
g.UltiSnipsListSnippets = '<c-x><c-s>'
g.UltiSnipsRemoveSelectModeMappings = 0

-- }}}

-- Startify {{{
vim.cmd("let g:startify_commands = [ ':PackerUpdate', ':checkhealth', ]")
vim.cmd("let g:startify_bookmarks = [ '~/.config/nvim/init.lua', '~/.zshrc' ]")
vim.cmd("let g:startify_myheader = ['(Neo)Vim']")
vim.cmd("let g:startify_custom_header = 'startify#pad(g:startify_myheader)'")
-- }}}

-- Debugger {{{
vim.fn.sign_define('DapBreakpoint', {text='⬤ ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='▶', texthl='debugBreakpoint', linehl='debugPC', numhl=''})
require('dap-python').setup('~/venvs/debugpy/bin/python')
require('dap.ext.vscode').load_launchjs()
g.dap_virtual_text = true
-- }}}

-- }}}

-- general configurations
vim.cmd "source ~/.config/nvim/viml/options.vim"

-- Tree Sitter
require "treesitter-config"

-- Telescope
require "telescope-config"

-- nvim-tree
require "nvim-tree-config"

-- LSP
require "lsp-config"

-- Completion
-- require "cmp-config"
require "cmp-config"

-- statuslines/bufferline
require "lualine_bufferline-config"

-- Colors
require "colors"

-- Functions, Commands, Autocommands
vim.cmd "source ~/.config/nvim/viml/commands.vim"
vim.cmd "source ~/.config/nvim/viml/autocommands.vim"

-- Mappings
vim.cmd "source ~/.config/nvim/viml/mappings.vim"

-- vim: sw=2 ts=2 fdm=marker:

