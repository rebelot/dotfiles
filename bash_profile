[ -f ~/.bashrc ] && source ~/.bashrc

# PATH {{{
export PATH=/opt/local/bin:/opt/local/sbin:$PATH # <-- MacPorts
export PATH=$HOME/code/bin:$PATH
export PATH=/opt/bin:$PATH
# }}}

#XCODE CTL SOURCES
#/Applications/Xcode.app/Contents/Developer
#Apple LLVM version 8.1.0 (clang-802.0.38)
#xcode-select --switch /Library/Developer/CommandLineTools

# >>> conda init >>> {{{
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/opt/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<< }}}

# General Settings {{{
export HISTSIZE=50000
export HISTFILESIZE=-1
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\$(scutil --get ComputerName):\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1

#   1.   directory											a     black
#   2.   symbolic link									    b     red
#   3.   socket												c     green
#   4.   pipe												d     brown
#   5.   executable										    e     blue
#   6.   block special									    f     magenta
#   7.   character special									g     cyan
#   8.   executable with setuid bit set						h     light grey
#   9.   executable with setgid bit set						A     bold black, usually shows up as dark grey
#   10.  directory writable to others, with sticky bit		B     bold red
#   11.  directory writable to others, without sticky bit	C     bold green
#														    D     bold brown, usually shows up as yellow
#														    E     bold blue
#														    F     bold magenta
#														    G     bold cyan
#														    H     bold light grey; looks like bright white
#														    x     default foreground or background

#		    fb:	1 2 3 4 5 6 7 8 9 1011
export LSCOLORS=ExFxBxDxCxegedabagEgGx
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export SCHRODINGER="/opt/schrodinger/suites2019-1"

bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind 'set completion-ignore-case on'
# }}}

# Functions {{{

function cdw {
	cd "$(dirname "$(which "$1")")"
}

# }}}

# Aliases {{{
alias tc="tree -C"
alias ll="ls -l"
alias la="ls -a"
alias ccat='pygmentize -O style=monokai -f console256 -g'
alias reload="source $HOME/.bash_profile"
# }}}

# vim:set et sw=4 ts=4 fdm=marker:
