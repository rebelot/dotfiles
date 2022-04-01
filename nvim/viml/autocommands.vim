augroup MyAutoCommands
  autocmd!

  " zsh!
  " autocmd vimenter * let &shell='"/opt/local/bin/zsh" -i'
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=500}

  "QfL
  autocmd FileType qf set nobuflisted  

  " Science
  autocmd BufNewFile,BufRead *.pdb set filetype=PDB
  autocmd BufNewFile,BufRead *.aln set filetype=clustal
  autocmd BufNewFile,BufRead *.fasta,*.fa set filetype=fasta
  autocmd BufNewFile,BufRead *.msj set filetype=config
  autocmd BufNewFile,BufRead *.cms,*.mae setlocal foldmarker={,} | setlocal fdm=marker

  " Distraction Free
  " autocmd User GoyoEnter Limelight
  " autocmd User GoyoLeave Limelight!
  
  " Competions Preview
  " autocmd CompleteDone * silent if pumvisible() == 0 && bufname("%") != "[Command Line]" | pclose | endif
  
  " Set SpellCheck
  autocmd FileType latex,tex,markdown,txt setlocal spell

  " Line Wrapping
  " autocmd FileType latex,tex,markdown,txt,text setlocal wrap 

  " Syntax
  autocmd BufNewFile,BufRead *.coffee set filetype=coffee
  autocmd FileType json syntax match Comment +\/\/.\+$+
    
  " Send to Repl
  autocmd FileType python xnoremap <buffer> <leader>vs "+y :call VimuxRunCommand('%paste')<CR>

  " run in terminal
  autocmd FileType python nnoremap <buffer> <F5> :exe 'sp <bar> ter python ' . shellescape(expand("%")) . ''<left>

  " make
  autocmd FileType markdown,pandoc setlocal makeprg=pandoc\ -f\ gfm\ --pdf-engine=xelatex\ %\ -o\ %:r.pdf

  "markdown html preview
  " autocmd BufWrite *.md :! pandoc -f gfm -t html -o /tmp/%:t.html %

  " Surround
  autocmd FileType tex let g:surround_92 = "\\\1\\\1{\r}"

  " Terminal
  autocmd TermOpen * setlocal nonumber norelativenumber
  " autocmd TermOpen * setlocal filetype=terminal

  " Diagnostics
  " autocmd User DiagnosticsChanged lua vim.diagnostic.setqflist({open = false })

augroup END

