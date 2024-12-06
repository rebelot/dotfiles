 " be iMproved, required

command! CD lcd %:p:h

command! FollowSymLink execute "file " . resolve(expand('%')) | edit

command! -range=% Wc <line1>,<line2>w ! wc

augroup MyAutoCommands
  autocmd!

  autocmd FileType qf set nobuflisted  
  autocmd FileType latex,tex,markdown,txt setlocal spell
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType python nnoremap <buffer> <F5> :exe 'sp <bar> ter python ' . shellescape(expand("%")) . ''<left>
  autocmd FileType markdown,pandoc setlocal makeprg=pandoc\ -f\ gfm\ --pdf-engine=xelatex\ %\ -o\ %:r.pdf
    
  " Science
  autocmd BufNewFile,BufRead *.pdb set filetype=PDB
  autocmd BufNewFile,BufRead *.aln set filetype=clustal
  autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=fasta
  autocmd BufNewFile,BufRead *.msj set filetype=config
  autocmd BufNewFile,BufRead *.cms,*.mae setlocal foldmarker={,} | setlocal fdm=marker
augroup END

" }}}

set laststatus=2
set statusline=%-(%f%h%w%q%m%r%)%=%(%y\ %l/%L\ (%p%%)\ :\ %c%)

" Settings {{{

syntax on                " enable syntax highlighting
set termguicolors        " enable gui colors for terminal
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" 
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
                         " Failsafe to enable True Colors in tmux; is it really required?
set encoding=utf-8       " enconding
let g:vimsyn_embed = 'lPr'
let g:tex_flavor = 'latex'
set encoding=utf-8
set modeline             " enable vim modelines
set mouse=a              " enable mouse for all modes
set noerrorbells vb t_vb=	" remove all errors; 'set visualbell noeb' to revert
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set title                " change the terminal's title
set nobackup             " no backup file 
set noswapfile           " don't write .swp files
set hidden               " allow modified buffers to be hidden 
set undofile             " set permanent undo (default `undodir = ~/.local/share/nvim/undo/` 
set undodir=/Users/laurenzi/.local/share/vim/undo
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
set wildignore=*.swp,*.bak,*.pyc,*.class
set wildmode=longest,full
set wildoptions+=tagfile
set wildmenu             " diplay command completion listing and choice menu
set wildignorecase       " ignore case command completion menu 
"set shell=zsh\ --login   " default shell (iteractive)
"set shellcmdflag=-c      " default shell command for non interactive invocations
"set clipboard=unnamed   " send yanks to system clipboard (buggy with v-block)
set showcmd              " show key spressed in lower-right corner
set sidescroll=1         " smooth side scrolling
set conceallevel=2       " conceal marked text
set completeopt=menuone,noinsert,noselect
                         " set the behavior of the completion menu 
set fillchars=vert:┃,fold:\ 
                         " set various fillchars; in this case removes clobbering signs from folds ('\ ')
set showmode           " Do not show -- MODE -- in cmdline"
set cmdheight=1          " Height of the command line
set updatetime=250       " time required to update CursorHold hook
set shortmess+=c         " remove 'match x of y' echoing line
set ttyfast
set splitbelow
set splitright
set dictionary=/usr/share/dict/words
" }}}

" Colors {{{
set background=dark
" colorscheme default

" Mappings {{{
let mapleader = ','
noremap <Space> :
xnoremap <Space> :
noremap L $
noremap H ^

inoremap <C-l> <Right>
nnoremap <silent><esc> :noh<bar>diffupdate<CR><C-L>

cnoremap <expr><C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr><C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

nnoremap <leader>ev :tabedit $MYVIMRC<CR>

inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>" 
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>" 
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"

" toggle [r]elative line [n]umbers
nnoremap <silent><leader>rn :set invrelativenumber<CR>

" move around and resize windows
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <m-s-l> <C-W>>
nnoremap <m-s-h> <C-W><
nnoremap <m-s-j> <C-W>+
nnoremap <m-s-k> <C-W>-

" Vertical/Horizontal Scrolling
nnoremap <m-l> zl
nnoremap <m-h> zh
nnoremap <m-j> <C-E>
nnoremap <m-k> <C-Y>

" j/k in wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" close window/buffer
nnoremap <leader>q :close<CR>
nnoremap <leader>Q :bdelete<CR>
nnoremap <leader>bo :%bd <bar> e# <bar> bd #<CR>

" switch/open buffers
nnoremap <silent><m-n> :bnext<CR>
nnoremap <silent><m-p> :bprev<CR>
nnoremap gbb :ls<CR>:b 
nnoremap gbs :ls<CR>:sb 
nnoremap gbv :ls<CR>:vertical sb 
nnoremap gbt :ls<CR>:tab sb 
nnoremap gbd :ls<CR>:bdelete 
nnoremap gbh :browse oldfiles<CR>

" [s]ave buffer (normal or insert)
nnoremap <leader>w :w<cr>
" inoremap <leader>s <C-c>:w<cr>

" copy to system clipboard
" vnoremap <C-c> :w !pbcopy<CR><CR>
" noremap <C-v> :r !pbpaste<CR><CR>

" redraw screen and c[l]ear highlights
nnoremap <silent><leader>l :noh<CR>:redraw!<CR>

" [re]load buffer
nnoremap <leader>re :bd%<bar>e#<CR>

" [e]dit, [v]ertical, horizontal [s]plit or [t]ab a [n]ew buffer
nnoremap <leader>en :enew<CR>
nnoremap <leader>vn :rightbelow vnew<CR>
nnoremap <leader>sn :belowright new<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>st :split <bar> terminal <cr>

" Edit or select [R/r]egister
nnoremap <silent><leader>" :reg<CR>:execute 'norm! "' . input("Select [register][action]: ")<CR>
nnoremap <leader>e" :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><left>

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
nnoremap <leader>cC :cexpr []<CR>

" Location[L]ist [O]pen, [N]ext, [P]revious, [C]lose
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lNext<CR>
nnoremap <leader>lc :lclose<CR>
nnoremap <leader>lC :lexpr []<CR>

" Text Formatting
nnoremap <leader>gq vipgq

" Search visual selection
xnoremap g/ "sy/\V<C-r>=escape(@s,'/\')<CR><CR>``

" Set @/ to word under cursor
nnoremap <silent><leader>/ :call setreg('/', expand('<cword>'))<CR>

" Poor men refactoring
nnoremap cr *``cgn

" Add blank lines above/below cursor
nnoremap ]<CR> :call append(line('.'), '')<CR>
nnoremap [<CR> :call append(line('.')-1, '')<CR>

" Move selection up/down
xnoremap <C-D> :m'>+1<CR>gv=gv
xnoremap <C-U> :m'<-2<CR>gv=gv

"Folds
nnoremap zR zRz.
nnoremap zM zMz.

" }}}

" vim: ts=2 sw=2 fdm=marker

set undofile
set undodir=~/.vim/undo

