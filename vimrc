 " be iMproved, required

command! CD lcd %:p:h

command! FollowSymLink execute "file " . resolve(expand('%')) | edit

augroup MyAutoCommands
    autocmd!
    
    " Science
    autocmd BufNewFile,BufRead *.pdb set filetype=PDB
    autocmd BufNewFile,BufRead *.aln set filetype=clustal
    autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=fasta
augroup END

" }}}

" Settings {{{

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
set background=dark

" Mappings {{{
let mapleader = ','
noremap <Space> :
xnoremap <Space> :

" fast [e]dit and [s]ourcing .[v]imrc
nnoremap <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <silent><leader>sv :source $MYVIMRC<CR>:noh<CR>

inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>" 
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>" 

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

" Vertical/Horizontal Scrolling
nnoremap <m-l> zl
nnoremap <m-h> zh
nnoremap <m-j> <C-E>
nnoremap <m-k> <C-Y>

" close window/buffer
nnoremap <leader>q :close<CR>
nnoremap <leader>Q :bdelete<CR>
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
" }}}

" vim: ts=2 sw=2 fdm=marker
