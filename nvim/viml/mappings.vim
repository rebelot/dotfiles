let mapleader = ','
xnoremap <Space> :
nnoremap <Space> :
noremap L $
noremap H ^
" noremap <M-S-H> H
" noremap <M-S-L> L
" noremap <M-S-M> M

"nnore fast [e]dit and [s]ourcing .[v]imrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
" nnoremap <silent><leader>sv :source $MYVIMRC<CR>:noh<CR>


" Tab S-Tab prev/next candidate, CR confirm, BS delete completion,
" C-l escape delimiters, C-Space invoke completion,
" C-U C-D scroll Up/Down

" let g:ulti_expand_res = 0
" function! Ulti_Expand_and_getRes() abort
"   call UltiSnips#ExpandSnippet()
"   return g:ulti_expand_res
" endfunction
"
" imap <silent><CR> <C-R>=pumvisible() ? Ulti_Expand_and_getRes() ? "" : "\<C-y>" : delimitMate#ExpandReturn()<CR>
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>" 
" imap <expr><S-Tab> pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"
" inoremap <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>" 
" inoremap <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"
inoremap <C-l> <Right>

" remap <Esc> to jk in insert mode
" inoremap jk <Esc>
" inoremap kj <Esc>

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
nnoremap <leader>bD :bdelete!<CR>
nnoremap <leader>bo :%bd <bar> e# <bar> bd #<CR>

" Go to [b]uffer, [s]plit, [v]ertical, [t]ab or [d]elete
nnoremap <silent><m-n> :bnext<CR>
nnoremap <silent><m-p> :bprev<CR>
nnoremap gbb :ls<CR>:b 
nnoremap gbs :ls<CR>:sb 
nnoremap gbv :ls<CR>:vertical sb 
nnoremap gbt :ls<CR>:tab sb 
nnoremap gbd :ls<CR>:bdelete 
nnoremap gbp :BufferLinePick<CR>

" [w]rite buffer 
nnoremap <leader>w :w<cr>

" redraw screen and c[l]ear highlights
" nnoremap <silent><leader>l :noh<CR>:redraw!<CR>
nnoremap <silent><M-/> :noh<bar>diffupdate<CR><C-L>

" [re]load buffer
" nnoremap <leader>re :e%<CR>
nnoremap <leader>re :Bdelete<CR><C-O>zRzz

" [e]dit, [v]ertical, horizontal [s]plit or [t]ab a [n]ew buffer
nnoremap <leader>en :enew<CR>
nnoremap <leader>vn :rightbelow vnew<CR>
nnoremap <leader>sn :belowright new<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>st :split <bar> terminal <cr>

" Edit or select [R/r]egister
" nnoremap <silent><leader>" :reg<CR>:execute 'norm! "' . input("Select [register][action]: ")<CR>
nnoremap <leader>" :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><left>

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

" Qui[c]kFix [O]pen, [N]ext, [P]revious, [c]lose, [C]lear
" nnoremap <leader>co :botright copen<CR>
" nnoremap <leader>cn :cnext<CR>
" nnoremap <leader>cp :cNext<CR>
" nnoremap <leader>cc :cclose<CR>
nnoremap <leader>cC :cexpr []<CR>
"
" Location[L]ist [O]pen, [N]ext, [P]revious, [c]lose, [C]lear
" nnoremap <leader>lo :botright lopen<CR>
" nnoremap <leader>ln :lnext<CR>
" nnoremap <leader>lp :lNext<CR>
" nnoremap <leader>lc :lclose<CR>
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

" WindowSwap
" nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<CR>
 
" toggle tagbar
nnoremap <silent><F8> :TagbarToggle<CR>

" Toggle [Mu]ndo
nnoremap <silent><leader>mu :MundoToggle<CR>

"Folds
nnoremap zR zRz.
nnoremap zM zMz.

" Vimux
xnoremap <leader>vs "vy :call VimuxSlime()<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" EasyAlign
xmap ga <Plug>(EasyAlign)

" Vista
nnoremap <leader>vv :Vista!!<CR>
nnoremap <leader>vf :Vista finder<CR>

" gitgutter
" nnoremap <leader>sd :SignifyHunkDiff<CR>
nnoremap <leader>hd :Gitsigns preview_hunk<CR>
nnoremap ]h :Gitsigns next_hunk<CR>
nnoremap [h :Gitsigns next_hunk<CR>

" Menu
nnoremap <F2> :emenu <C-Z>
xnoremap <F2> :emenu <C-Z>

" c-n/c-p previous command or match history
" cnoremap <expr><C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
" cnoremap <expr><C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
" cnoremap <expr><CR> v:lua.require'cmp'.visible() ? v:lua.require'cmp'.confirm() : '\\<CR>' 
                " \ wildmenumode() ? \
                " \ "\<C-y>" : "\<CR>"

" Sintax stuff
nnoremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Debugger
" see dap-config.lua

" netrw_gx fix
" nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>
