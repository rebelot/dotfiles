let mapleader = ','
xnoremap <Space> :
nnoremap <Space> :
noremap L $
noremap H ^
noremap <M-S-H> H
noremap <M-S-L> L
noremap <M-S-M> M

"nnore fast [e]dit and [s]ourcing .[v]imrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
" nnoremap <silent><leader>sv :source $MYVIMRC<CR>:noh<CR>


" Tab S-Tab prev/next candidate, CR confirm, BS delete completion,
" C-l escape delimiters, C-Space invoke completion,
" C-U C-D scroll Up/Down

let g:ulti_expand_res = 0
function! Ulti_Expand_and_getRes() abort
  call UltiSnips#ExpandSnippet()
  return g:ulti_expand_res
endfunction

" imap <silent><CR> <C-R>=pumvisible() ? Ulti_Expand_and_getRes() ? "" : "\<C-y>" : delimitMate#ExpandReturn()<CR>
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>" 
" imap <expr><S-Tab> pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"
" inoremap <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>" 
" inoremap <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

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
nnoremap <silent><leader>l :noh<bar>diffupdate<CR><C-L>

" [re]load buffer
nnoremap <leader>re :e%<CR>

" [e]dit, [v]ertical, horizontal [s]plit or [t]ab a [n]ew buffer
nnoremap <leader>en :enew<CR>
nnoremap <leader>vn :rightbelow vnew<CR>
nnoremap <leader>sn :belowright new<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>st :split <bar> terminal <cr>

" Edit or select [R/r]egister
" nnoremap <silent><leader>" :reg<CR>:execute 'norm! "' . input("Select [register][action]: ")<CR>
nnoremap <leader>" :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><left>
nnoremap <leader>t" :Telescope registers<CR>


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
nnoremap <leader>co :botright copen<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cNext<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>cC :cexpr []<CR>

" Location[L]ist [O]pen, [N]ext, [P]revious, [c]lose, [C]lear
nnoremap <leader>lo :botright lopen<CR>
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

" WindowSwap
" nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<CR>
 
" toggle tagbar
nnoremap <silent><F8> :TagbarToggle<CR>

" [N]vim[T]ree
nnoremap <silent><leader>nt :NvimTreeToggle<CR>
nnoremap <silent><leader>nf :NvimTreeFindFile<CR>

" Toggle [Mu]ndo
nnoremap <silent><leader>mu :MundoToggle<CR>

" FZF [f]files, [h]istory, [b]uffers, [l]lines
" nnoremap <leader>ff :FZF<CR>
" nnoremap <leader>fh :History<CR>
" nnoremap <leader>fb :Buffer<CR>
" nnoremap <leader>fl :Lines<CR>
" nnoremap <leader>h  :History:<CR>
" nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>f. :Telescope file_browser<CR>
nnoremap <leader>fl :Telescope current_buffer_fuzzy_find<CR>
nnoremap <leader>fq :Telescope quickfix<CR>
nnoremap <leader>fh :Telescope oldfiles<CR>
nnoremap <leader>fr :Telescope frecency<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader><space> :Telescope commands<CR>
nnoremap <leader>ft :Telescope treesitter<CR>
nnoremap <leader>fj :Telescope jumplist<CR>
" nnoremap <leader>tr :Telescope lsp_references<CR>
" nnoremap <leader>ts :Telescope lsp_document_symbols<CR>
nnoremap <leader>T :Telescope<CR>

"Spell
nnoremap <leader>z :Telescope spell_suggest<CR>

"Folds
nnoremap zR zRz.
nnoremap zM zMz.

" Marks
" nnoremap <leader>m :Marks<CR>
nnoremap <leader>fm :Telescope marks<CR>

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
cnoremap <expr><C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr><C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

" Sintax stuff
nnoremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Debugger
" see dap-config.lua

" netrw_gx fix
" nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>
