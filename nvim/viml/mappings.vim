xnoremap <Space> :
nnoremap <Space> :
nnoremap <C-space> q:
xnoremap <C-space> q:
nnoremap L $
xnoremap L $
onoremap L $
nnoremap H ^
xnoremap H ^
onoremap H ^
nnoremap <S-CR> -
xnoremap <S-CR> -
onoremap <S-CR> -
nnoremap <leader>. @:
xnoremap <leader>. @:

" noremap <M-S-H> H
" noremap <M-S-L> L
" noremap <M-S-M> M

"nnore fast [e]dit and [s]ourcing .[v]imrc
" nnoremap <leader>ev :edit $MYVIMRC<CR>
" nnoremap <silent><leader>sv :source $MYVIMRC<CR>:noh<CR>

" clear search highlighting
nnoremap <silent> <esc> :noh<CR>

" remap <Esc> to jk in insert mode
" inoremap jk <Esc>
" inoremap kj <Esc>

" j/k in wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Better <C-r>
" Surround a word witht text: ciwTEXT<C-'>TEXT
inoremap <C-'> <C-r><C-o>"
inoremap <C-r> <C-r><C-o>
inoremap <C-r><C-o> <C-r>

" toggle [r]elative line [n]umbers
nnoremap <silent><leader>rn :set invrelativenumber<CR>

" move around and resize windows
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-p> <C-w>p
nnoremap <C-n> <C-w>w
nnoremap <m-s-l> <C-W>>
nnoremap <m-s-h> <C-W><
nnoremap <m-s-j> <C-W>+
nnoremap <m-s-k> <C-W>-
nnoremap <m-z> :call WinZoomToggle()<CR>
nnoremap <c-w>S :bo split<cr>
nnoremap <c-w>V :bo vert split<cr>

tnoremap <c-\><c-\> <c-\><c-n>
" tnoremap <c-h> <c-\><c-n><c-w>h
" tnoremap <c-j> <c-\><c-n><c-w>j
" tnoremap <c-k> <c-\><c-n><c-w>k
" tnoremap <c-l> <c-\><c-n><c-w>l

" Vertical/Horizontal Scrolling
noremap <m-l> zl
noremap <m-h> zh
noremap <m-j> <C-E>
noremap <m-k> <C-Y>
" noremap <ScrollWheelUp> <C-Y>
" noremap <ScrollWheelDown> <C-E>
" noremap <S-ScrollWheelUp> <C-U>
" noremap <S-ScrollWheelDown> <C-D>


" close window/buffer
nnoremap <leader>q :close<CR>
nnoremap <leader>Q :bdelete<CR>
nnoremap <leader>bd :Bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>
nnoremap <leader>bo :%bd <bar> e# <bar> bd #<CR>

" Go to [b]uffer, [s]plit, [v]ertical, [t]ab or [d]elete
nnoremap <silent><m-n> :bnext<CR>
nnoremap <silent><m-p> :bprev<CR>
nnoremap gbb :ls<CR>:b <C-z>
nnoremap gbs :ls<CR>:sb <C-z>
nnoremap gbv :ls<CR>:vertical sb <C-z>
nnoremap gbt :ls<CR>:tab sb <C-z>
nnoremap gbd :ls<CR>:bdelete <C-z>
nnoremap gbh :browse oldfiles<CR>

" [w]rite buffer 
nnoremap <leader>w :w<cr>

" redraw screen and c[l]ear highlights
" nnoremap <silent><leader>l :noh<CR>:redraw!<CR>
nnoremap <silent><M-/> :noh<bar>diffupdate<CR><C-L>

" [re]load buffer
" nnoremap <leader>re :e%<CR>
nnoremap <silent><leader>re :e%<CR>

" [e]dit, [v]ertical, horizontal [s]plit or [t]ab a [n]ew buffer
nnoremap <leader>en :enew<CR>
nnoremap <leader>vn :rightbelow vnew<CR>
nnoremap <leader>sn :belowright new<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>st :split <bar> terminal <cr>
nnoremap <leader>vt :vertical split <bar> terminal <cr>

" Edit or select [R/r]egister
" nnoremap <silent><leader>" :reg<CR>:execute 'norm! "' . input("Select [register][action]: ")<CR>
nnoremap <leader>e" :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><left>

" Easier increase/decrease indents
xnoremap > >gv
xnoremap < <gv

" select [a]ll
nnoremap <M-a> ggVG

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
nnoremap <silent><leader>cC :cexpr []<CR>
nnoremap <leader>c/ :cexpr []\|copen<CR><C-w>p:%g//caddexpr expand("%") .. ":" .. line(".") .. ":" .. getline(".")<CR>
"
" Location[L]ist [O]pen, [N]ext, [P]revious, [c]lose, [C]lear
" nnoremap <leader>lo :botright lopen<CR>
" nnoremap <leader>ln :lnext<CR>
" nnoremap <leader>lp :lNext<CR>
" nnoremap <leader>lc :lclose<CR>
nnoremap <silent><leader>lC :lexpr []<CR>

" Tab / S-Tab as <C-I> / <C-O>
nnoremap <S-Tab> <C-o>

" Text Formatting
nnoremap <leader>gq vipgq

" Add blank lines above/below cursor
nnoremap ]<CR> :call append(line('.'), '')<CR>
nnoremap [<CR> :call append(line('.')-1, '')<CR>

" Move selection up/down
" xnoremap <C-D> :m'>+1<CR>gv=gv
" xnoremap <C-U> :m'<-2<CR>gv=gv
xnoremap <C-D> :m'>+1<CR>gv
xnoremap <C-U> :m'<-2<CR>gv

" Set @/ to word under cursor
nnoremap g/ :call setreg('/', expand('<cword>'))<CR>//<CR>``

" Search visual selection
xnoremap g/ "sy/\V<C-r>=escape(@s,'/\')<CR><CR>``

"fast macro
nnoremap @ <cmd>set lazyredraw <bar> execute "noautocmd norm! " . v:count1 . "@" . getcharstr()<bar>set nolazyredraw<cr>
xnoremap @ :<C-U>set lazyredraw <bar> execute "noautocmd '<,'>norm! " . v:count1 . "@" . getcharstr()<bar>set nolazyredraw<cr>
nnoremap Q <cmd>set lazyredraw <bar> execute "noautocmd norm! Q"<bar>set nolazyredraw<cr>
xnoremap Q :<C-U>set lazyredraw <bar> execute "noautocmd '<,'>norm! Q"<bar>set nolazyredraw<cr>

" http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
" Poor men refactoring
nnoremap cr *``cgn
xnoremap <leader>r y/\V<C-R>=escape(@", '/')<CR><CR>``cgn

nnoremap cq *``qz
xnoremap <leader>q y/\V<C-R>=escape(@", '/')<CR><CR>``qz

"Folds
nnoremap zR zRz.
nnoremap zM zMz.

" Menu
nnoremap <F2> :emenu <C-Z>
xnoremap <F2> :emenu <C-Z>

" Jump to delimiter
" inoremap <silent> <C-l> <esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>a
inoremap <silent> <C-l> <Left><cmd>call search("[)\\]}>,`'\"]", 'eW')<CR><Right>

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

cnoreabbrev Gdiffsplit rightbelow vertical Gdiffsplit
" cnoremap ( ()<Left>
" cnoremap [ []<Left>
" cnoremap { {}<Left>

anoremenu LSP.Back        <cmd>popup PopUp<cr>
vnoremenu LSP.Back        <cmd>popup PopUp<cr>gv
anoremenu LSP.-1-         <Nop>
nnoremenu LSP.Hover       <cmd>lua vim.lsp.buf.hover()<CR>
nnoremenu LSP.Definition  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremenu LSP.References  <cmd>lua vim.lsp.buf.references()<CR>
nnoremenu LSP.Rename      <cmd>lua vim.lsp.buf.rename()<CR>
nnoremenu LSP.Format      <cmd>lua vim.lsp.buf.format()<CR>
xnoremenu LSP.Format      <cmd>lua vim.lsp.buf.format()<CR>
nnoremenu LSP.Actions     <cmd>lua vim.lsp.buf.code_action()<CR>
xnoremenu LSP.Actions     <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremenu LSP.Diagnostics <cmd>lua vim.diagnostic.open_float({scope = 'line'})<CR>

anoremenu DAP.Back               <cmd>popup PopUp<cr>
vnoremenu DAP.Back               <cmd>popup PopUp<cr>gv
anoremenu DAP.-1-                <Nop>
nnoremenu DAP.Toggle\ Breakpoint <cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremenu DAP.Condition\ Breakpoint <cmd>lua require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremenu DAP.Exception\ Breakpoint <cmd>lua require'dap'.set_exception_breakpoints()<CR>
nnoremenu DAP.Run\ to\ cursor <cmd>lua require'dap'.run_to_cursor()<CR>
nnoremenu DAP.Eval <cmd>lua require'dapui'.eval()<CR>
vnoremenu DAP.Eval <cmd>lua require'dapui'.eval()<CR>

aunmenu PopUp
vnoremenu PopUp.Cut           "+x
vnoremenu PopUp.Copy          "+y
anoremenu PopUp.Paste         "+gP
vnoremenu PopUp.Paste         "+P
vnoremenu PopUp.Search        "sy/\V<C-r>=escape(@s,'/\')<CR><CR>``
vnoremenu PopUp.Replace       y/\V<C-r>=escape(@",'/\')<CR><CR>``cgn
vnoremenu PopUp.Delete        "_x
nnoremenu PopUp.Select\ All>  ggVG
vnoremenu PopUp.Select\ All>  gg0oG$
inoremenu PopUp.Select\ All   <C-Home><C-O>VG
nnoremenu PopUp.Inspect       :Inspect<CR>
inoremenu PopUp.Expression    <c-r>=
anoremenu PopUp.-1-           <Nop>
nnoremenu PopUp.LSP          <cmd>popup LSP<cr>
vnoremenu PopUp.LSP          <cmd>popup LSP<cr>gv
nnoremenu PopUp.DAP          <cmd>popup DAP<cr>
" nnoremenu PopUp.LSP.&GoToDefinition          lua vim.lsp.buf.definition()
" nnoremenu PopUp.LSP.&References              lua vim.lsp.buf.references()
