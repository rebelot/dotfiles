"           le vimrc
                                                
                            " be iMproved, required

" Plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/bundle')
Plug 'junegunn/vim-plug'

" Syntax and Folds {{{
Plug 'chrisbra/vim-zsh'
Plug 'vim-python/python-syntax'
Plug 'Konfekt/FastFold'
" }}}

" File, Buffer Browsers {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
" }}}

" Colors {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
" }}}

" Utils {{{  
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'vim-utils/vim-man', {'on': 'Man'}
Plug 'moll/vim-bbye'
Plug 'lambdalisue/suda.vim'
" }}}

" Editing Tools {{{
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'junegunn/vim-easy-align'
Plug 'dhruvasagar/vim-table-mode', {'on': 'TableModeToggle'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'raimondi/delimitmate'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
" }}}

" Tmux {{{
Plug 'benmills/vimux'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
" }}}

call plug#end()
" }}}

" Plugin Options {{{

" Syntax and Folds {{{
let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1
let g:python_highlight_space_errors = 0

let g:fastfold_fold_command_suffixes = ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C', 'r', 'R', 'm', 'M', 'i', 'n', 'N']
" }}}

" File, Buffer, Browsers {{{

let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlPMixed'

let g:fzf_tags_command = '/opt/bin/ctags -R'

let g:ranger_map_keys = 0
" }}}

" Colors {{{
let g:gruvbox_italic = 1
let g:gruvbox_sign_column = 'bg0'

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#csv#column_display = 'Name'
let g:airline_powerline_fonts = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_theme = 'gruvbox'
" onedark molokai

" }}}

" Utils {{{
let g:gutentags_ctags_exclude = ['.mypy_cache']
let g:gutentags_project_root = ['__init__.py']

let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0

let g:ale_set_highlights = 1
let g:ale_sign_error = '' "  ⤫
let g:ale_sign_warning = '' " ⚠    
let g:ale_lint_on_text_changed = 'always'
let g:ale_fixers = { 'python': 'autopep8', 'sh': 'shfmt'}
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_python_pylint_options = '--disable=C'
let g:ale_python_flake8_options = '--ignore=E221,E241,E201'

let g:suda#prefix = 'sudo:'
call suda#init('sudo:*,sudo:*/*')


" Tagbar {{{
let g:tagbar_ctags_bin = '/opt/bin/ctags'
let g:tagbar_type_markdown= {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/Users/laurenzi/.vim/mystuff/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
let g:tagbar_type_PDB= {
    \ 'ctagstype': 'PDB',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 'a:atom',
    \ ],
\ }
" }}}
" }}}

" Editing Tools {{{
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_jump_expansion = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:delimitMate_nesting_quotes = ['"','`']
" }}}

" }}}

" Functions {{{

function! VimuxSlime() abort
  let l:text = @v
  let l:text = substitute(l:text, '\n$', '', '')
  call VimuxSendText(l:text)
  call VimuxSendKeys('Enter')
endfunction

function! WinZoomToggle() abort
    if ! exists('w:WinZoomIsZoomed') 
      let w:WinZoomIsZoomed = 0
    endif
    if w:WinZoomIsZoomed == 0
      let w:WinZoomOldWidth = winwidth(0)
      let w:WinZoomOldHeight = winheight(0)
      wincmd _
      wincmd |
      let w:WinZoomIsZoomed = 1
    elseif w:WinZoomIsZoomed == 1
      execute 'resize ' . w:WinZoomOldHeight
      execute 'vertical resize ' . w:WinZoomOldWidth
      let w:WinZoomIsZoomed = 0
   endif
endfunction

" }}}

" Commands {{{

command! -nargs=1 -complete=file   SudoEdit  edit  sudo:<args>
command! -nargs=1 -complete=buffer SudoWrite write sudo:<args>

command! CD lcd %:p:h

command! LCMenu call LanguageClient_contextMenu()

command! FollowSymLink execute "file " . resolve(expand('%')) | edit

augroup MyAutoCommands
    autocmd!
    
    " Science
    autocmd BufNewFile,BufRead *.pdb set filetype=PDB
    autocmd BufNewFile,BufRead *.aln set filetype=clustal
    autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=fasta

    " Distraction Free
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
    
    " Set SpellCheck
    " autocmd FileType latex,tex,markdown,txt setlocal spell

    " Line Wrapping
    " autocmd FileType latex,tex,markdown,txt,text setlocal wrap 

    " DelimitMate
    autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
    autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']

    " syntax filetype
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee


augroup END

" }}}

" Settings {{{
let g:python3_host_prog = '/Users/laurenzi/venv/bin/python'

syntax on                " enable syntax highlighting
set termguicolors        " enable gui colors for terminal
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" 
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
                         " Failsafe to enable True Colors in tmux; is it really required?
set encoding=utf-8       " enconding
set guifont=Menlo\ Regular\ Nerd\ Font\ Complete:h12 " select font for gui
set modeline             " enable vim modelines
set mouse=a              " enable mouse for all modes
set noerrorbells vb t_vb=	" remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set nobackup             " no backup file 
set noswapfile           " don't write .swp files
set undofile             " set permanent undo (default `undodir = ~/.local/share/nvim/undo/` 
set undodir=/Users/laurenzi/.local/share/nvim/undo
set nowrap               " don't wrap lines
set tabstop=4            " a tab is four spaces
let &shiftwidth=&tabstop " number of spaces to use for autoindenting
set shiftround           " use multiple of shiftwidth when indenting with '<' and '>'
set expandtab            " expand tab to count tabstop n° of spaces
set backspace=indent,eol,start
                         " allow backspacing over everything in insert mode
set autoindent           " always set autoindenting on
set copyindent           " copy the previous indentation on autoindenting
set number               " always show line numbers
set showmatch            " show matching parenthesis with a quick jump
set ignorecase           " ignore case when searching with / or ?
set smartcase            " ignore case if search pattern is all lowercase,
                         "    case-sensitive otherwise
set smarttab             " insert tabs on the start of a line according to
                         "    shiftwidth, not tabstop
set hlsearch             " highlight search terms
set incsearch            " show search matches as you type
set hidden               " allow modified buffers to be hidden 
set wildmode=longest,list:longest,full
set wildmenu             " diplay command completion listing and choice menu
set wildignorecase       " ignore case command completion menu 
set shell=zsh\ --login   " default shell (iteractive)
set shellcmdflag=-c      " default shell command for non interactive invocations
"set clipboard=unnamed   " send yanks to system clipboard (buggy with v-block)
set showcmd              " show key spressed in lower-right corner
set sidescroll=1         " smooth side scrolling
set conceallevel=2       " conceal marked text
set completeopt=menuone,noinsert,noselect,preview
                         " set the behavior of the completion menu 
set fillchars=vert:┃,fold:\ 
                         " set various fillchars; in this case removes clobbering signs from folds ('\ ')
set noshowmode           " Do not show -- MODE -- in cmdline"
set cmdheight=1          " Height of the command line
set updatetime=250       " time required to update CursorHold hook
set shortmess+=c         " remove 'match x of y' echoing line
set ttyfast
" }}}

" Colors {{{
colorscheme gruvbox 
set background=dark

" Colorscheme Overrides {{{
hi! link SpecialKey GruvboxBlue
hi! link pythonDot GruvboxRed
"}}}

" Highlights {{{

" Spell {{{
hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
" Works well with iTerm2 underline color
hi SpellBad   gui=underline     " guifg=red 
hi SpellLocal gui=underline     " guifg=yellow
hi SpellCap   gui=underline     " guifg=orange
hi SpellRare  gui=underline     " guifg=darkyellow
" }}}

" ALE {{{
hi ALEInfo                  gui=underline
hi ALEError                 gui=underline
hi ALEWarning               gui=underline
hi ALEStyleError            gui=underline
hi ALEStyleWarning          gui=underline
hi link ALEInfoSign         GruvboxYellow
hi link ALEErrorSign        GruvboxRed
hi link ALEWarningSign      GruvboxOrange
hi link ALEStyleErrorSign   GruvboxAqua
hi link ALEStyleWarningSign GruvboxBlue
" }}}

" }}}
" }}}

" Mappings {{{
let mapleader = ','
noremap <Space> :

" fast [e]dit and [s]ourcing .[v]imrc
nnoremap <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <silent><leader>sv :source $MYVIMRC<CR>:noh<CR>

inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>" 
imap <C-l> <Plug>delimitMateS-Tab

" remap <Esc> to jk in insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" toggle [r]elative line [n]umbers
nnoremap <silent><leader>rn :set invrelativenumber<CR>

" move around and resize windows
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <m->> <C-W>>
nnoremap <m-<> <C-W><
nnoremap <m-+> <C-W>+
nnoremap <m--> <C-W>-
nnoremap <m-z> :call WinZoomToggle()<CR>

" Vertical/Horizontal Scrolling
nnoremap <m-l> zl
nnoremap <m-h> zh
nnoremap <m-j> <C-E>
nnoremap <m-k> <C-Y>

" close window/buffer
nnoremap <leader>q :close<CR>
nnoremap <leader>Q :bdelete<CR>
nnoremap <leader>bd :Bdelete<CR>
nnoremap <leader>bo :%bd \| e# \| bd #<CR>

" switch/open buffers
nnoremap <silent><m-n> :bnext<CR>
nnoremap <silent><m-p> :bprev<CR>
nnoremap gbb :ls<CR>:b 
nnoremap gbs :ls<CR>:sb 
nnoremap gbv :ls<CR>:vertical sb 
nnoremap gbt :ls<CR>:tab sb 
nnoremap gbd :ls<CR>:bdelete 

" [s]ave buffer (normal or insert)
nnoremap <leader>s :w<cr>
" inoremap <leader>s <C-c>:w<cr>

" copy to system clipboard
" vnoremap <C-c> :w !pbcopy<CR><CR>
" noremap <C-v> :r !pbpaste<CR><CR>

" redraw screen and c[l]ear highlights
nnoremap <silent><leader>l :noh<CR>:redraw!<CR>

" [re]load buffer
nnoremap <leader>re :e%<CR>

" [e]dit, [v]ertical, horizontal [s]plit or [t]ab a [n]ew buffer
nnoremap <leader>en :enew<CR>
nnoremap <leader>vn :rightbelow vnew<CR>
nnoremap <leader>sn :belowright new<CR>
nnoremap <leader>tn :tabnew<cr>

" Edit or select [R/r]egister
nnoremap <silent><leader>" :reg<CR>:execute 'norm! "' . input("Select [register][action]: ")<CR>
nnoremap <leader>R :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><left>

" Easier increase/decrease indents
xnoremap > >gv
xnoremap < <gv

" select [a]ll
nnoremap <leader>a ggVG

" [y]ank to clipnoard
nnoremap <leader>y "+y
xnoremap <leader>y "+y

" [p]aste from clipboard
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" Qui[c]kFix [O]pen, [N]ext, [P]revious, [C]lose
nnoremap <leader>co :copen<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cNext<CR>
nnoremap <leader>cc :cclose<CR>

" Location[L]ist [O]pen, [N]ext, [P]revious, [C]lose
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lNext<CR>
nnoremap <leader>lc :lclose<CR>

" toggle tagbar
nnoremap <silent><F8> :TagbarToggle<CR>

" Toggle [Mu]ndo
nnoremap <silent><leader>mu :MundoToggle<CR>

" [F]uzzy [m]ost recent, [b]uffers, [l]ines, [h]elptags
nnoremap <leader>fm :CtrlPMRUFiles<CR>
nnoremap <leader>fb :CtrlPBuffer<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fh :Helptags<CR>

" Marks
nnoremap <leader>m :Marks<CR>

"Vimux
xnoremap <leader>vs "vy :call VimuxSlime()<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" EasyAlign
xmap ga <Plug>(EasyAlign)

" }}}

" vim: ts=2 sw=2 fdm=marker
