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
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-scripts/Gundo'
Plugin 'vim-scripts/YankRing.vim'
" Plugin 'Shougo/unite.vim'
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
if has('nvim')
    Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plugin 'Shougo/denite.nvim'
endif

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

let g:ycm_python_binary_path = '/opt/anaconda3/bin/python'
let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:UltiSnipsExpandTrigger = '<c-j>'

let g:bufferline_echo = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#bufferline#overwrite_variables = 0
let g:airline#extensions#ycm#enabled = 1
let g:airline#extensions#ycm#error_symbol = 'E:'
let g:airline#extensions#ycm#warning_symbol = 'W:'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#vimtex#enabled = 1
let g:airline#extensions#windowswap#enabled = 1
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#csv#column_display = 'Name'
let g:airline_powerline_fonts = 1
let g:airline_theme = "molokai"

let g:bufExplorerFindActive=1

let g:suda#prefix = 'sudo:'
call suda#init('sudo:*,sudo:*/*')

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:syntastic_python_checkers = ["flake8"]
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
let g:yankring_paste_using_g = 0

" let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_key='<F2>'
let g:multi_cursor_start_word_key='g<F2>'

let g:ackprg = 'ag --vimgrep'

let g:ctrlp_map = '<leader>F'
let g:ctrlp_cmd = 'CtrlPMixed'

" let g:vdebug_options= {
"     \    "port" : 9000,
"     \    "server" : '',
"     \    "timeout" : 20,
"     \    "on_close" : 'stop',
"     \    "break_on_open" : 1,
"     \    "ide_key" : '',
"     \    "path_maps" : {},
"     \    "debug_window_level" : 0,
"     \    "debug_file_level" : 0,
"     \    "debug_file" : "",
"     \    "watch_window_style" : 'expanded',
"     \    "marker_default" : '⬦',
"     \    "marker_closed_tree" : '▸',
"     \    "marker_open_tree" : '▾'
"     \}

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
vnoremap <leader>vs "vy :call VimuxSlime()<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" MyCommands
command! -nargs=1 SudoEdit edit sudo:<args>
command! -nargs=1 SudoWrite write sudo:<args>

command! CD lcd %:p:h

autocmd BufNewFile,BufRead *.pdb setfiletype PDB
autocmd BufNewFile,BufRead *.aln setfiletype clustal
autocmd BufNewFile,BufRead *.fasta,*.fa setfiletype fasta

if exists('$ITERM_PROFILE')
    if exists('$TMUX')
        autocmd BufEnter *.png,*.jpg,*.gif exec "! ~/code/bin/imgcat_4tmux " . expand("%:p") | :bw
    else 
        autocmd BufEnter *.png,*.jpg,*.gif exec "! ~/.iterm2/imgcat " . expand("%:p") | :bw
    endif
end

" Settings
syntax on                       " enable syntax highlighting
set termguicolors               " enable gui colors for terminal TODO: set only if terminal supports it
colorscheme chance-of-storm     " awesome colorscheme
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " True Colors
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set encoding=utf-8              " enconding
set guifont=Fira\ code:h14      " select font for gui
set modeline             " enable vim modelines
if !has('nvim')          " set ttymouse (mouse works while in tmux) if not in neovim
    set ttymouse=xterm2
endif
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
set shell=/opt/local/bin/zsh
set clipboard=unnamed " copy to system clipboard
set ttyfast

" make comments italic 
let &t_ZH="\e[3m"   
let &t_ZR="\e[23m"
" set t_ZH=[3m   
" set t_ZR=[23m
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
end

" highlight line numbers in active window, underline current line for special windows
" hi CursorLine term=underline cterm=underline guibg=#2a2e31
hi CursorLineNr term=bold cterm=italic ctermfg=11 gui=bold guifg=Yellow
hi clear CursorLine
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd WinLeave * setlocal nocursorline
    autocmd BufWinEnter,WinEnter * call ToggleCursorLineEnter()
augroup END   
function! ToggleCursorLineEnter()
    setlocal cursorline
    hi clear CursorLine    " highlight line-number only
    for i in ["NERD_Tree_","__Tagbar","unite","YankRing"]
        if (bufname("%") =~ i)       
            highlight CursorLine term=underline cterm=underline guibg=#2a2e31
            break
        endif
    endfor
endfunction

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
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i

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
nnoremap <leader>zi :set foldmethod=indent<CR>
nnoremap <leader>zm :set foldmethod=manual<CR>

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
