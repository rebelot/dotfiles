
"   ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
"   ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
"   ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
"   ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
"   ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
"   ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                
set nocompatible              " be iMproved, required

call plug#begin('~/.vim/bundle')
Plug 'junegunn/vim-plug'

" Code completion & Syntax
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-zsh'
Plug 'zchee/deoplete-jedi'
Plug 'wellle/tmux-complete.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'plasticboy/vim-markdown'
Plug 'lervag/vimtex'
Plug 'lionawurscht/deoplete-biblatex'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'chrisbra/vim-zsh'
Plug 'w0rp/ale'
Plug 'KeitaNakamura/highlighter.nvim', { 'do': ':UpdateRemotePlugins', 'on': 'HighlighterUpdate' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'joonty/vdebug', {'on': 'VdebugStart'}

" File, Buffer Browsers
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTReeFind'] }
Plug 'ivalkeen/nerdtree-execute'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'francoiscabrol/ranger.vim', {'on': 'Ranger'}
Plug 'mileszs/ack.vim'
Plug 'bling/vim-bufferline'
Plug 'jlanzarotta/bufexplorer'

" Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'morhetz/gruvbox'
" Plug 'lifepillar/vim-solarized8'
" Plug 'ajmwagar/vim-deus'
" Plug 'flazz/vim-colorschemes'
" Plug 'romainl/flattened'
" Plug 'nightsense/stellarized'
" Plug 'guns/xterm-color-table.vim'
" Plug 'nightsense/vrunchbang'
" Plug 'nightsense/seagrey'

" Utils
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'moll/vim-bbye'
Plug 'lambdalisue/suda.vim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'wesQ3/vim-windowswap'
Plug 'kassio/neoterm'
Plug 'vim-utils/vim-man', {'on': 'Man'}
Plug 'itchyny/calendar.vim', {'on': 'Calendar'}
Plug 'skywind3000/vim-preview', {'on': 'Preview'}
Plug 'chrisbra/csv.vim', { 'on': 'CSVInit' }
Plug 'justinmk/vim-sneak'

" Editing Tools
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'dhruvasagar/vim-table-mode', {'on': 'TableModeToggle'}
Plug 'simnalamburt/vim-mundo'
Plug 'raimondi/delimitmate'
Plug 'chrisbra/NrrwRgn'
Plug 'reedes/vim-pencil'
Plug 'Konfekt/FastFold'
Plug 'tommasolaurenzi/nvim-historian', {'branch': 'devel'}
Plug 'tpope/vim-commentary'

" Tmux
Plug 'benmills/vimux'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()

" Plugin Options

let g:python3_host_prog = "/opt/anaconda3/bin/python"

" Deoplete Syntax Completion configurations
" TODO: still need some twaking with languageserver
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('max_list', 100000)
call deoplete#custom#option('min_pattern_length', 2)
if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
let g:deoplete#sources#jedi#server_timeout = 120
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#python_path = "/opt/anaconda3/bin/python"
" let g:deoplete#sources#jedi#extra_path = ""
let g:deoplete#sources#clang#libclang_path = "/opt/local/libexec/llvm-6.0/lib/libclang.dylib"
let g:deoplete#sources#clang#clang_header = "/opt/local/libexec/llvm-6.0/lib/c++/v1"
" let g:deoplete#ignore_sources = {}
" let g:deoplete#ignore_sources.python = ['jedi']
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_autoStart = 0
let g:LanguageClient_waitOutputTimeout = 120
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
        \ 'sh': ['bash-language-server','start'],
        \ 'r': ['R', '--quiet', '--slave', '-e', 'languageserver::run()'],
        \}
"        \ 'python': ['pyls','--log-file', '/tmp/pyls.log'],
"        \ 'c': ['~/.local/share/cquery/build/release/bin/cquery', '--language-server'],
"        \ 'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
"                    \       using LanguageServer;
"                    \       server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);
"                    \       server.runlinter = true;
"                    \       run(server);
"                    \   '],
"        \}

call deoplete#custom#source('omni',          'mark', '')
call deoplete#custom#source('LanguageClient','mark', '')
call deoplete#custom#source('zsh',           'mark', '')
call deoplete#custom#source('clang',         'mark', '')
call deoplete#custom#source('julia',         'mark', '')
call deoplete#custom#source('jedi',          'mark', '')
call deoplete#custom#source('vim',           'mark', '')
call deoplete#custom#source('ultisnips',     'mark', '')
call deoplete#custom#source('tag',           'mark', '炙')
call deoplete#custom#source('around',        'mark', '↻')
call deoplete#custom#source('buffer',        'mark', 'ℬ')
call deoplete#custom#source('tmux-complete', 'mark', '侀')
call deoplete#custom#source('syntax',        'mark', '')
call deoplete#custom#source('member',        'mark', '.')
call deoplete#custom#source('file',          'mark', '')
call deoplete#custom#source('dictionary',    'mark', '')
call deoplete#custom#source('biblatex',      'mark', '"..."')
call deoplete#custom#source('include',       'mark', '#')
"                  舘侀炙    ⌾

call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

let g:tmuxcomplete#trigger = ''
let g:default_julia_version = '0.6.2'

let g:gutentags_ctags_exclude = [".mypy_cache"]

let g:ranger_map_keys = 0

let g:UltiSnipsExpandTrigger = '<c-j>'

let g:bufferline_echo = 1

let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#csv#column_display = 'Name'
let g:airline_powerline_fonts = 1
" onedark molokai
let g:airline_theme = "gruvbox"

let g:suda#prefix = 'sudo:'
call suda#init('sudo:*,sudo:*/*')

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:ale_set_highlights = 1
let g:ale_sign_error = '' "  ⤫
let g:ale_sign_warning = '' " ⚠    
let g:ale_lint_on_text_changed = "always"
let g:ale_fixers = { 'python': 'autopep8', 'sh': 'shfmt'}
let g:ale_python_mypy_options = "--ignore-missing-imports"
let g:ale_python_pylint_options = "--disable=C"
let g:ale_python_flake8_options = "--ignore=E221"

let g:ackprg = 'ag --vimgrep'

let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlPMixed'

let g:limelight_default_coefficient = 0.7
let g:limelight_priority = -1

let g:delimitMate_expand_inside_quotes = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:delimitMate_nesting_quotes = ['"','`']

let g:fastfold_fold_command_suffixes = ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C', 'r', 'R', 'm', 'M', 'i', 'n', 'N']
" let g:tex_fold_enabled = 1
" let g:vimsyn_folding ='af'
" let g:sh_fold_enabled = 7
" let g:markdown_folding = 0

let g:historian_registers = ['+', '"']

let g:tagbar_ctags_bin = "/opt/bin/ctags"
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

function! VimuxSlime()
  let l:text = @v
  let l:text = substitute(l:text, "\n$", "", "")
  call VimuxSendText(l:text)
  call VimuxSendKeys("Enter")
endfunction

" MyCommands
command! -nargs=1 -complete=file   SudoEdit  edit  sudo:<args>
command! -nargs=1 -complete=buffer SudoWrite write sudo:<args>

command! CD lcd %:p:h

augroup MyAutoCommands
    autocmd!
    
    " Science
    autocmd BufNewFile,BufRead *.pdb        set filetype=PDB
    autocmd BufNewFile,BufRead *.aln        set filetype=clustal
    autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=fasta

    " Distraction Free
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
    
    " Competions
    autocmd CompleteDone * silent! pclose!

    " Set SpellCheck
    autocmd FileType latex,tex,markdown,txt setlocal spell

    " DelimitMate
    autocmd FileType python   let b:delimitMate_nesting_quotes = ['"']
    autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']

    " syntax filetype
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
augroup END


" Settings
syntax on                " enable syntax highlighting
set termguicolors        " enable gui colors for terminal
set encoding=utf-8       " enconding
set guifont=Menlo\ Regular\ Nerd\ Font\ Complete:h12  " select font for gui
set modeline             " enable vim modelines
set mouse=a              " enable mouse for all modes
set noeb vb t_vb=		 " remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set nobackup             
set noswapfile           " don't write .swp files
set undofile             " set permanent undo (default `undodir = ~/.local/share/nvim/undo/` 
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
" set completeopt="menuone,preview,noinsert,noselect"
set fillchars=vert:┃,fold:\  " set various fillchars; in this case removes clobbering signs from folds
set inccommand=split     " real time preview of substitution commands

" Colorscheme
let g:gruvbox_italic = 1
let g:gruvbox_sign_column = "bg0"
colorscheme gruvbox "chance-of-storm
set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " True Colors
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Highlights
hi! link SpecialKey GruvboxBlue

hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad   gui=underline guifg=red 
hi SpellLocal gui=underline guifg=yellow
hi SpellCap   gui=underline guifg=orange
hi SpellRare  gui=underline guifg=darkyellow

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

" mappings
let mapleader = ","

" completion workarounds
imap <silent> <BS> <C-R>=pumvisible() ? deoplete#smart_close_popup() : ""<CR><Plug>delimitMateBS
imap <expr>   <CR>       pumvisible() ? deoplete#close_popup() : "<Plug>delimitMateCR"
imap <expr>   <Tab>      pumvisible() ? "\<C-n>"  : "<Tab>" 
imap <expr>   <S-Tab>    pumvisible() ? "\<C-p>"  : "<Plug>delimitMateS-Tab"
imap <expr>   <C-Space>  deoplete#manual_complete()
imap <expr>   <C-d>      pumvisible() ? "<PageDown>"  : "\<C-d>" 
imap <expr>   <C-u>      pumvisible() ? "<PageUp>"    : "\<C-u>"
imap <expr>   <C-l>      deoplete#refresh()

" fast [e]dit and [s]ourcing .[v]imrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>:noh<CR>

" `"'({[<surrounds>]})'"`
vnoremap s( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap s[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap s{ <Esc>`>a}<Esc>`<i{<Esc>
vnoremap s" <Esc>`>a"<Esc>`<i"<Esc>
vnoremap s' <Esc>`>a'<Esc>`<i'<Esc>
vnoremap s< <Esc>`>a><Esc>`<i<<Esc>
vnoremap s` <Esc>`>a`<Esc>`<i`<Esc>
vnoremap s_ <Esc>`>a_<Esc>`<i_<Esc>
vnoremap s* <Esc>`>a*<Esc>`<i*<Esc>

" remap <Esc> to jk in insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" open [n]ew [t]ab with nt
nnoremap <leader>tn :tabnew<cr>

" toggle [r]elative line [n]umbers
nnoremap <silent><leader>rn :set invrelativenumber<CR>

" move around windows
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <m->> <C-W>>
nnoremap <m-<> <C-W><
nnoremap <m-+> <C-W>+
nnoremap <m--> <C-W>-

" close window/buffer
nnoremap <leader>Q :bdelete<CR>
nnoremap <leader>bd :Bdelete<CR>
nnoremap <leader>q :q<CR>

" switch between buffers
nnoremap <silent><m-n> :bnext<CR>
nnoremap <silent><m-p> :bprev<CR>
nnoremap gb :ls!<CR>:b 

" [s]ave buffer (normal or insert)
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>

" copy to system clipboard
" vnoremap <C-c> :w !pbcopy<CR><CR>
" noremap <C-v> :r !pbpaste<CR><CR>

" redraw screen and c[l]ear highlights
nnoremap <silent><leader>l :noh<CR>:redraw!<CR>

" [re]load buffer
nnoremap <leader>re :e%<CR>

" [e]dit [n]ew buffer
nnoremap <leader>en :enew<CR>

" create [v]ertical split editing a [n]ew buffer
nnoremap <leader>vn :rightbelow :vnew<CR><C-W>L

" toggle tagbar
nnoremap <F8> :TagbarToggle<CR>

" [N]ERDTree
nnoremap <leader>N :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Toggle [Mu]ndo
nnoremap <leader>mu :MundoToggle<CR>

" FuzzyFinder
nnoremap <leader>fm :CtrlPMRUFiles<CR>
nnoremap <leader>fb :CtrlPBuffer<CR>
nnoremap <leader>fr :CtrlPRegister<CR>

"Vimux
vnoremap <leader>vs "vy :call VimuxSlime()<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" Edit [R]egister
nnoremap <leader>R  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" Easier increase/decrease indents
vnoremap > >gv
vnoremap < <gv
