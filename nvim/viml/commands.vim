command! CD lcd %:p:h

command! FollowSymLink execute "file " . resolve(expand('%')) | edit

command! Reload source $MYVIMRC | noh

command! -range=% Wc <line1>,<line2>w ! wc

function! WinZoomToggle() abort
    if !exists('t:winrestcmd') || !t:winrestcmd
        let t:winrestcmd = winrestcmd()
        wincmd _
        wincmd |
    else
        execute t:winrestcmd
        let t:winrestcmd = 0
    endif
endfunction

