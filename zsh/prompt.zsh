prompt_short='%B%F{$(my_vim_cmd_mode)}❯%f%b '
prompt_2short='%B%F{73}%~%f%b'$'\n'"$prompt_short"

ps1_split_state=1

function prompt_split_toggle {
    if [ $ps1_split_state -eq 0 ]; then
        ps1_split_state=1
        export PS1=$prompt_2short
    elif [ $ps1_split_state -eq 1 ]; then
        ps1_split_state=0
        export PS1=$prompt_short
    fi
    zle reset-prompt
}

function my_vim_cmd_mode {
    case $KEYMAP in
        vicmd) echo "red" ;;
        main|viins) echo "magenta" ;;
        *) echo "magenta" ;;
    esac
}

function zle-keymap-select {
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N prompt_split_toggle

bindkey "p" prompt_split_toggle
bindkey "" vi-cmd-mode
