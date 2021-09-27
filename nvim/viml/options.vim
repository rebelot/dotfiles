" Settings {{{
let g:python3_host_prog = '/Users/laurenzi/venvs/base/bin/python'
let g:python_host_prog = '/Users/laurenzi/venvs/base27/bin/python'
" let g:netrw_browsex_viewer = 'open'

syntax on                " enable syntax highlighting
set termguicolors        " enable gui colors for terminal
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" 
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let g:vimsyn_embed = 'lPr'
                         " Failsafe to enable True Colors in tmux; is it really required?
set encoding=utf-8       " enconding
set modeline             " enable vim modelines
set mouse=a              " enable mouse for all modes
set noerrorbells novb	" remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set nobackup             " no backup file 
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
" set wildmode=longest,list:longest,full
" set wildmenu             " diplay command completion listing and choice menu
set wildoptions+=pum
set wildignorecase       " ignore case command completion menu 
" set shell=/opt/local/bin/zsh\ --login   " default shell (interactive)
" set shellcmdflag=-c      " default shell command for non interactive invocations
"set clipboard=unnamed   " send yanks to system clipboard (buggy with v-block)
set showcmd              " show key spressed in lower-right corner
set sidescroll=1         " smooth side scrolling
set conceallevel=2       " conceal marked text
set completeopt=menuone,noinsert,noselect,longest
set pumheight=15         " set completion menu max height
                         " set the behavior of the completion menu 
set fillchars+=vert:┃,fold:\ 
set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
                         " set various fillchars; in this case removes clobbering signs from folds ('\ ')
set inccommand=split     " real time preview of substitution commands
set noshowmode           " Do not show -- MODE -- in cmdline"
set cmdheight=1          " Height of the command line
set updatetime=250       " time required to update CursorHold hook
set shortmess+=c         " remove 'match x of y' echoing line
" set printdevice=OLIVETTI_d_COPIA4500MF_plus__2_
set showbreak=↪\ 
set listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:~,eol:¬
set wildcharm=<C-Z>      " trigger completion in macros
set signcolumn=yes
set splitbelow
set splitright

set dictionary=/usr/share/dict/words
" }}}
