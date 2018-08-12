set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'flazz/vim-colorschemes'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kovetskiy/ycm-sh'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
Plugin 'vim-utils/vim-man'
Plugin 'majutsushi/tagbar'
Plugin 'moll/vim-bbye'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'lambdalisue/suda.vim'
Plugin 'godlygeek/tabular'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/nerdtree'
Plugin 'ivalkeen/nerdtree-execute.git'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'lervag/vimtex.git'
" Plugin 'joonty/vdebug'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'benmills/vimux'
Plugin 'w0rp/ale'
Plugin 'raimondi/delimitmate'
Plugin 'vim-scripts/Gundo'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'metakirby5/codi.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'chrisbra/csv.vim'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'chrisbra/NrrwRgn'
Plugin 'wesQ3/vim-windowswap'
Plugin 'mileszs/ack.vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'vim-scripts/Vim-Gromacs'
Plugin 'chrisbra/vim-zsh'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'guns/xterm-color-table.vim'
Plugin 'itchyny/calendar.vim'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'reedes/vim-pencil'
Plugin 'junegunn/limelight.vim'
Plugin 'Konfekt/FastFold'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Plugin Options

let g:sparkupMaps = 0

let g:ranger_map_keys = 0

let g:ycm_python_binary_path = '/opt/anaconda3/bin/python'
let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
" let g:ycm_key_list_stop_completion = ['<C-y>', '<Enter>']
let g:ycm_filetype_blacklist = {}

let g:UltiSnipsExpandTrigger = '<c-j>'

let g:bufferline_echo = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#csv#column_display = 'Name'
let g:airline_powerline_fonts = 1
let g:airline_theme = "molokai"

let g:bufExplorerFindActive=1

let g:suda#prefix = 'sudo:'
call suda#init('sudo:*,sudo:*/*')

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:ale_set_highlights = 1
let g:ale_lint_on_text_changed = "normal"
let g:ale_fixers = { 'python': 'autopep8'}
let g:ale_python_mypy_options = "--ignore-missing-imports"

let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
let g:yankring_paste_using_g = 0

" let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_key='<F2>'
let g:multi_cursor_start_word_key='g<F2>'

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
augroup DelimitMe
    autocmd!
    au FileType python let b:delimitMate_nesting_quotes = ['"']
    au FileType markdown let b:delimitMate_nesting_quotes = ['`']
augroup END

" { dirty workaround to make DelimitMate and YouCompleteMe work together
imap <silent> <BS> <C-R>=pumvisible() ? "\<C-y>" : ""<CR><Plug>delimitMateBS
imap <expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
" }

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

augroup ScienceBitch
    autocmd!
    autocmd BufNewFile,BufRead *.pdb        set filetype=PDB
    autocmd BufNewFile,BufRead *.aln        set filetype=clustal
    autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=asta
augroup END

augroup DistractionFree
    autocmd!
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
augroup END

" Settings
syntax on                       " enable syntax highlighting
set termguicolors               " enable gui colors for terminal TODO: set only if terminal supports it
colorscheme chance-of-storm     " awesome colorscheme
" colorscheme molokai
highlight SignColumn guibg=#181c20
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " True Colors
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set encoding=utf-8              " enconding
set guifont=Menlo\ Regular\ Nerd\ Font\ Complete:h12      " select font for gui
set modeline             " enable vim modelines
set ttymouse=xterm2
set mouse=a              " enable mouse for all modes
set noeb vb t_vb=		 " remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set nobackup             " don't write .swp files
set noswapfile
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
" set shell=bash\ -l    " select shell as login bash
set shell=zsh\ -l
set shellcmdflag=-c
set clipboard=unnamed " copy to system clipboard
set ttyfast
set showcmd
set sidescroll=1
"set completeopt+="menuone,preview,noinsert,noselect"

" set spellceck
augroup MySpellFileTypes
    autocmd!
    autocmd FileType latex,tex,markdown,txt setlocal spell
augroup END

let &t_Us = "\e[4m"
let &t_Ue = "\e[0m"
hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad   cterm=underline ctermbg=red        ctermfg=white gui=undercurl   guisp=red 
hi SpellLocal cterm=underline ctermbg=208        ctermfg=white gui=undercurl   guisp=#ff8700
hi SpellCap   cterm=underline ctermbg=magenta    ctermfg=white gui=undercurl   guisp=lightblue
hi SpellRare  cterm=underline ctermbg=darkyellow ctermfg=white gui=undercurl   guisp=darkyellow

" set highlight groups for ALE
highlight ALEError        guibg=#890303 " dark red
highlight ALEWarning      guibg=#8e4c02 " dark orange/yellow
highlight ALEInfo         guibg=#444444 " dark gray
highlight ALEStyleError   guibg=#890375 " dark purple
highlight ALEStyleWarning guibg=#033e89 " dark blue

highlight ALEErrorSign        guifg=#890303 " dark red
highlight ALEWarningSign      guifg=#8e4c02 " dark orange/yellow
highlight ALEInfoSign         guifg=#444444 " dark gray
highlight ALEStyleErrorSign   guifg=#890375 " dark purple
highlight ALEStyleWarningSign guifg=#033e89 " dark blue

" make comments italic 
let &t_ZH="\e[3m"   
let &t_ZR="\e[23m"
highlight Comment cterm=italic, gui=italic

" change cursor shape in Insert, Replace, Normal
if exists('$ITERM_PROFILE')
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_SR = "\<Esc>]50;CursorShape=2\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
endif

" LineNumbers colour
" 29465f 566878 688197 907d01
hi LineNr ctermfg=11 guifg=#325472

" fix screen arrowkeys
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" mappings
let mapleader = ","

" fast edit and sourcing .vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

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

" toggle line numbers
" nnoremap <C-N><C-N> :set invnumber<cr>

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

" YCM Docs
" nnoremap K :YcmCompleter GetDoc<CR>

" undisplay highlighting
nnoremap <leader>h :noh<CR>

" create vertical split editing a new buffer
nnoremap <leader>vn :rightbelow :vnew<CR><C-W>L

" toggle tagbar
nnoremap <F8> :TagbarToggle<CR>

" Netrwd 
" nnoremap <leader>le :topleft :30Lex<CR>
" nnoremap <leader>e :Explore<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Folds
nnoremap <leader>zi :setlocal foldmethod=indent<CR>
nnoremap <leader>zm :setlocal foldmethod=manual<CR>

" Toggle Gundo
nnoremap <leader>gu :GundoToggle<CR>

" Toggle YankRing
nnoremap <leader>yr :YRShow<CR>

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
