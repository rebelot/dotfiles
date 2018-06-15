
"   ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
"   ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
"   ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
"   ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
"   ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
"   ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Code completion & Syntax
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'autozimu/LanguageClient-neovim', { 'branch': 'next' }
Plugin 'Shougo/neco-vim'
Plugin 'Shougo/neco-syntax'
Plugin 'zchee/deoplete-clang'
Plugin 'zchee/deoplete-zsh'
Plugin 'zchee/deoplete-jedi'
Plugin 'wellle/tmux-complete.vim'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'lervag/vimtex.git'
Plugin 'lionawurscht/deoplete-biblatex'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'chrisbra/csv.vim'
Plugin 'chrisbra/vim-zsh'
Plugin 'w0rp/ale'
Plugin 'KeitaNakamura/highlighter.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'ludovicchabant/vim-gutentags'

" File, Buffer Browsers
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'scrooloose/nerdtree'
Plugin 'ivalkeen/nerdtree-execute.git'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'mileszs/ack.vim'
Plugin 'bling/vim-bufferline'
Plugin 'jlanzarotta/bufexplorer'

" Colors
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'ajmwagar/vim-deus'
Plugin 'romainl/flattened'
Plugin 'nightsense/stellarized'
Plugin 'guns/xterm-color-table.vim'
Plugin 'nightsense/vrunchbang'
Plugin 'nightsense/seagrey'
Plugin 'morhetz/gruvbox'

" Utils
Plugin 'vim-utils/vim-man'
Plugin 'moll/vim-bbye'
Plugin 'lambdalisue/suda.vim'
Plugin 'joonty/vdebug'
Plugin 'majutsushi/tagbar'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'wesQ3/vim-windowswap'
Plugin 'itchyny/calendar.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'skywind3000/vim-preview'
Plugin 'kassio/neoterm'

" Editing Tools
Plugin 'godlygeek/tabular'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'simnalamburt/vim-mundo'
Plugin 'raimondi/delimitmate'
Plugin 'chrisbra/NrrwRgn'
Plugin 'reedes/vim-pencil'
Plugin 'Konfekt/FastFold'

" Tmux
Plugin 'benmills/vimux'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tmux-plugins/vim-tmux-focus-events'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Plugin Options

let g:python3_host_prog = "/opt/anaconda3/bin/python"

" Deoplete Syntax Completion configurations
" TODO: still need some twaking with languageserver
let g:deoplete#enable_at_startup = 1

call deoplete#custom#option('max_list', 10000)
call deoplete#custom#option('min_pattern_length', 2)

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif

let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#python_path = "/opt/anaconda3/bin/python"
" let g:deoplete#sources#jedi#extra_path = ""
let g:deoplete#sources#clang#libclang_path = "/opt/local/libexec/llvm-6.0/lib/libclang.dylib"
let g:deoplete#sources#clang#clang_header = "/opt/local/libexec/llvm-6.0/lib/c++/v1"

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

" let g:deoplete#ignore_sources = {}
" let g:deoplete#ignore_sources.python = ['jedi']

" let g:deoplete#sources = {}
" let g:deoplete#sources.sh = ['LanguageClient']
" let g:deoplete#sources.python = ['LanguageClient','omni']

let g:LanguageClient_loggingLevel = 'DEBUG'
" let g:LanguageClient_autoStart = 0
let g:LanguageClient_diagnosticsEnable = 0
" let g:LanguageClient_hoverPreview = "Always"
let g:default_julia_version = '0.6.2'
let g:LanguageClient_serverCommands = {
        \ 'sh': ['bash-language-server','start'],
        \ 'r': ['R', '--quiet', '--slave', '-e', 'languageserver::run()'],
        \}
"        \ 'python': ['pyls','--log-file', '/tmp/pyls.log'],
"        \ 'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
"                    \       using LanguageServer;
"                    \       server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);
"                    \       server.runlinter = true;
"                    \       run(server);
"                    \   '],
"        \ 'r': ['R', '--quiet', '--slave', '-e', 'languageserver::run()'],
"        \ 'c': ['~/.local/share/cquery/build/release/bin/cquery', '--language-server'],
"        \}

call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

let g:gutentags_ctags_exclude = [".mypy_cache"]

let g:ranger_map_keys = 0

let g:UltiSnipsExpandTrigger = '<c-j>'

let g:bufferline_echo = 1

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
let g:ale_sign_error = '' " ⤫
let g:ale_sign_warning = '' "☠ ⚠        
let g:ale_lint_on_text_changed = "always"
let g:ale_fixers = { 'python': 'autopep8', 'sh': 'shfmt'}
let g:ale_python_mypy_options = "--ignore-missing-imports"
let g:ale_python_pylint_options = "--disable=C"

let g:ackprg = 'ag --vimgrep'

let g:ctrlp_map = '<leader>F'
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

let g:tagbar_ctags_bin = "/opt/bin/ctags"
" Add support for markdown files in tagbar.
" https://github.com/jszakmeister/markdown2ctags
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

" PDB tags
let g:tagbar_type_PDB= {
    \ 'ctagstype': 'PDB',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 'a:atom',
    \ ],
\ }

function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    exec a:vim_command . ' ' . output
  endif
endfunction

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
    " Science
    autocmd!
    autocmd BufNewFile,BufRead *.pdb        set filetype=PDB
    autocmd BufNewFile,BufRead *.aln        set filetype=clustal
    autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=asta

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
augroup END


" Settings
syntax on                " enable syntax highlighting
set termguicolors        " enable gui colors for terminal TODO: set only if terminal supports it
set encoding=utf-8       " enconding
set guifont=Menlo\ Regular\ Nerd\ Font\ Complete:h12      " select font for gui
set modeline             " enable vim modelines
set mouse=a              " enable mouse for all modes
set noeb vb t_vb=		 " remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title         " change the terminal's title
set nobackup      
set noswapfile    " don't write .swp files
set undofile      " set permanent undo (default `undodir = ~/.local/share/nvim/undo/` 
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set expandtab     " expand tab to count tabstop n° of spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set hidden        " allow modified buffers to be hidden 
set wildmode=longest,list:longest,full
set wildmenu      " diplay command completion listing and choice menu
set shell=zsh\ --login
set shellcmdflag=-c
"set clipboard=unnamed " copy to system clipboard
set ttyfast
set showcmd
set sidescroll=1
set conceallevel=2
" set completeopt="menuone,preview,noinsert,noselect"
set fillchars-=fold:-

" Colorscheme
let g:gruvbox_italic = 1
colorscheme gruvbox "chance-of-storm
set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " True Colors
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Highlights
" hi LineNr ctermfg=11 guifg=#325472
hi SignColumn guibg=#282828
let &t_ZH="\e[3m"   
let &t_ZR="\e[23m"
hi Comment cterm=italic gui=italic

let &t_Us = "\e[4m"
let &t_Ue = "\e[0m"
hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad   cterm=underline ctermbg=red        ctermfg=white  gui=undercurl   guifg=red 
hi SpellLocal cterm=underline ctermbg=208        ctermfg=white  gui=undercurl   guifg=#ff8700
hi SpellCap   cterm=underline ctermbg=magenta    ctermfg=white  gui=undercurl   guifg=orange
hi SpellRare  cterm=underline ctermbg=darkyellow ctermfg=white  gui=undercurl   guifg=darkyellow

hi ALEError            guibg=#890303 " dark red
hi ALEWarning          guibg=#8e4c02 " dark orange/yellow
hi ALEInfo             guibg=#444444 " dark gray
hi ALEStyleError       guibg=#890375 " dark purple
hi ALEStyleWarning     guibg=#033e89 " dark blue
hi ALEErrorSign        guifg=#890303 " dark red
hi ALEWarningSign      guifg=#8e4c02 " dark orange/yellow
hi ALEInfoSign         guifg=#444444 " dark gray
hi ALEStyleErrorSign   guifg=#890375 " dark purple
hi ALEStyleWarningSign guifg=#033e89 " dark blue

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

" fast edit and sourcing .vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>:noh<CR>

" surround word with "
noremap <leader>" viw<Esc>a"<Esc>bi"<Esc>lel

" remap <Esc> to jk in insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" open new tab with nt
nnoremap <leader>tn :tabnew<cr>

" move between tabs (next / previous)
" nnoremap <tab> :tabnext<CR> 
" nnoremap <s-tab> :tabprev<CR>

" toggle relative line numbers
nnoremap <leader>rn :set invrelativenumber<CR>

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

" save buffer (normal or insert)
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>

" copy to system clipboard
" vnoremap <C-c> :w !pbcopy<CR><CR>
" noremap <C-v> :r !pbpaste<CR><CR>

" switch between buffers
nnoremap gb :bnext<CR>
nnoremap gB :bprev<CR>

"misc
nnoremap <leader>l :noh<CR>:redraw!<CR>

" create vertical split editing a new buffer
nnoremap <leader>vn :rightbelow :vnew<CR><C-W>L

" toggle tagbar
nnoremap <F8> :TagbarToggle<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Folds
" nnoremap <leader>zi :setlocal foldmethod=indent<CR>
" nnoremap <leader>zm :setlocal foldmethod=manual<CR>

" Toggle Mundo
nnoremap <leader>mu :MundoToggle<CR>

" Toggle YankRing
nnoremap <leader>yr :Denite register<CR>

" reload buffer
nnoremap <leader>re :e%<CR>

" edit new buffer
nnoremap <leader>en :enew<CR>

" FuzzyFinder
nnoremap <leader>f :call FzyCommand("find . -type f", ":e")<cr>
nnoremap <leader>fv :call FzyCommand("find . -type f", ":vs")<cr>
nnoremap <leader>fs :call FzyCommand("find . -type f", ":sp")<cr>
nnoremap <leader>fm :CtrlPMRUFiles<CR>
nnoremap <leader>fb :CtrlPBuffer<CR>

"Vimux
vnoremap <leader>vs "vy :call VimuxSlime()<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" Edit Register
nnoremap <leader>R  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

