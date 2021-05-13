function zle-line-init() {
echoti smkx
}

function zle-line-finish() {
echoti rmkx
}

zle -N zle-line-init
zle -N zle-line-finish

bindkey -e                                        # Use emacs key bindings

bindkey '\ew' kill-region                         # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                           # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward  # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey "${terminfo[kpp]}" up-line-or-history     # [PageUp] - Up a line of history
bindkey "${terminfo[knp]}" down-line-or-history   # [PageDown] - Down a line of history

# start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search

bindkey "${terminfo[khome]}" beginning-of-line    # [Home] - Go to beginning of line
bindkey "${terminfo[kend]}"  end-of-line          # [End] - Go to end of line

bindkey ' ' magic-space                           # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                    # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                   # [Ctrl-LeftArrow] - move backward one word

bindkey "${terminfo[kcbt]}" reverse-menu-complete # [Shift-Tab] - move through the completion menu backwards

bindkey '^?' backward-delete-char                 # [Backspace] - delete backward
bindkey "${terminfo[kdch1]}" delete-char          # [Delete] - delete forward

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

function buffer2clipboard { echo $BUFFER | pbcopy }
zle -N buffer2clipboard
bindkey '^Xy' buffer2clipboard

