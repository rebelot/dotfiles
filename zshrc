#
# ███████╗███████╗██╗  ██╗██████╗  ██████╗
# ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#   ███╔╝ ███████╗███████║██████╔╝██║     
#  ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
# ███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# zmodload zsh/zprof

# $PATH {{{
export PATH="$HOME/bin:/usr/local/bin:$PATH"                  # <-- ~/bin:/usr/lolbin
export PATH="/opt/CHARMM/c38b2/exec/osx/:$PATH"               # <-- CHARMM
export PATH="/Developer/NVIDIA/CUDA-9.1/bin${PATH:+:${PATH}}" # <-- CUDA
export PATH="${PATH}:/Applications/moe2018/bin"               # <-- Moe2018
export PATH="/opt/bin:$PATH"                                  # <-- personal stuff
export PATH="$HOME/.iterm2:$PATH"                             # <-- iterm2
export PATH="$HOME/code/bin:$PATH"                            # <-- personal stuff
export PATH="$HOME/.nvm/versions/node/v10.4.0/bin:$PATH"      # <-- nvm
export PATH="$HOME/.cargo/bin:$PATH"                          # <-- cargo
export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"                 # <-- ruby gem
source /opt/anaconda3/etc/profile.d/conda.sh                  # <-- Anaconda + TMUX fix
[[ -z $TMUX ]] || conda deactivate; conda activate base       #
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"            # <-- MacPorts
export PATH="/opt/local/libexec/gnubin:$PATH"                 # <-- Coreutils
source "$HOME/venv/bin/activate"                              # <-- Activate the Python
# }}}

# $MANPATH {{{
export MANPATH="/usr/local/man:/usr/share/man:$MANPATH"
export MANPATH="/opt/share/man:/opt/local/share/man:/opt/local/libexec/gnubin/man:$MANPATH"
export MANPATH="$HOME/.fzf/man:$MANPATH"
export MANPATH="$MANPATH:/opt/anaconda3/man:/opt/anaconda3/share/man"
export ZSH="$HOME/.zsh"
# }}}

# ZSH init {{{
ZSH_CACHE_DIR="$ZSH/cache"
fpath=($ZSH/functions $ZSH/completions $fpath)

source $ZSH/options.zsh
source $ZSH/keybindings.zsh
source $ZSH/completions.zsh
source $ZSH/aliases.zsh
source $ZSH/functions.zsh
source $ZSH/prompt.zsh
# }}}

# Plugins {{{
source "$HOME/.zplugin/bin/zplugin.zsh"

zplugin load common-aliases
zplugin load schrun-completion
zplugin load exa-completion
zplugin ice svn; zplugin snippet OMZ::plugins/pip
zplugin ice svn; zplugin snippet OMZ::plugins/catimg
zplugin ice as"completion" mv"hub* -> _hub"; zplugin snippet '/opt/local/share/zsh/site-functions/hub.zsh_completion'
zplugin load bric3/oh-my-zsh-git
zplugin load srijanshetty/zsh-pandoc-completion
zplugin load zdharma/fast-syntax-highlighting
zplugin ice blockf; zplugin load zsh-users/zsh-completions

# }}}

# plugin Opts {{{
# ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
# ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')
print_unactive_flags_space=false
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
# export FZF_CTRL_T_OPTS=""
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS="
--no-height
--preview '[[ \$(file --mime {}) =~ directory ]] && tree -C {} || { [[ \$(file --mime {}) =~ image ]] && zsh /Users/laurenzi/.oh-my-zsh/plugins/catimg/catimg.sh {}; } || { [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file; } || (pygmentize -O style=monokai -f console256 -g {} || cat {}) 2> /dev/null | head -500'
--preview-window wrap:hidden
--bind 'ctrl-o:toggle-preview'
--bind 'tab':down
--bind 'btab:up'
--bind 'ctrl-z':toggle" 
# }}}

# User configuration {{{

# prompt
export PS1="$prompt_2short"
export RPROMPT='$(oh_my_git_info)'

# ls colors
export CLICOLOR=1
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LSCOLORS=ExFxBxDxCxegedabagEgGx
eval "$(dircolors -b)" # coreutils tool, exports LS_COLORS

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000
export HISTFILESIZE=-1

# programs env opts
export SCHRODINGER="/opt/schrodinger/suites2018-3"
export ILOG_CPLEX_PATH="/Applications/IBM/ILOG/CPLEX_Studio128"
export JULIA_PKGDIR="/Users/laurenzi/.julia"
export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm   # aliased down there
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export PAGER=less
export VISUAL=nvim
export LESS=-R
# export MANPAGER=most

# Compilation flags
# export CPPFLAGS="-I/opt/local/include"
# export LDFLAGS="-L/opt/local/lib"
# export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:$DYLD_LIBRARY_PATH"
# export QT_API="pyqt5"
# export CXX="/opt/local/bin/clang++"
# export CC="/opt/local/bin/clang"

#XCODE CTL SOURCES
# /Applications/Xcode.app/Contents/Developer
# /Library/Developer/CommandLineTools
# e.g.: xcode-select --switch /Library/Developer/CommandLineTools

# ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export elenuar="159.149.32.81"
export nero="159.149.32.106"
export jessicah="159.149.32.103"

# }}}

# Functions {{{
function cdw {
	cd "$(dirname "$(which "$1")")"
}

function melakappa {
    if [ $# -eq 0 ]; then
        echo "usage: melakappa Folder_Name"
    else
        mkdir -p ~/Jessicah/"$1" && mount_afp -i afp://$jessicah/"$1" ~/Jessicah/"$1"
    fi
}

function ts {
    local opts cmd cwd pane
    opts=$1
    cmd=${@:2}
    cwd=""
    pane=${opts//[A-Za-z]}

    if   [[ "$opts" =~ "L"  ]]; then pane="{left}"
    elif [[ "$opts" =~ "R"  ]]; then pane="{right}"
    elif [[ "$opts" =~ "tl" ]]; then pane="{top-left}"
    elif [[ "$opts" =~ "tr" ]]; then pane="{top-right}"
    elif [[ "$opts" =~ "bl" ]]; then pane="{bottom-left}"
    elif [[ "$opts" =~ "br" ]]; then pane="{bottom-right}"
    elif [[ "$opts" =~ "t"  ]]; then pane="{top}"
    elif [[ "$opts" =~ "b"  ]]; then pane="{bottom}"
    elif [[ "$opts" =~ "l"  ]]; then pane="{left-of}"
    elif [[ "$opts" =~ "r"  ]]; then pane="{right-of}"
    elif [[ "$opts" =~ "u"  ]]; then pane="{up-of}"
    elif [[ "$opts" =~ "d"  ]]; then pane="{down-of}"
    elif [[ "$opts" =~ "m"  ]]; then pane="{marked}"
    fi 
    [[ "$opts" =~ "c" ]] && cwd="cd $(pwd); "
    [[ "$opts" =~ "v" ]] && cmd=":e $(pwd)/$cmd"
    tmux send-keys -t "$pane" "$cwd$cmd" C-m
}

function tmx {
    [ -f /Users/laurenzi/.tmux/MySessions/"$1" ] || echo Session Layout does not exist!
    [ -f /Users/laurenzi/.tmux/MySessions/"$1" ] && /Users/laurenzi/.tmux/MySessions/"$1"
}

function licmae {
    if [[ $HOST =~ elenuar ]]; then
         /opt/schrodinger2018-2/licadmin STAT -c 27008@149.132.157.125:/opt/schrodinger/licenses/
    else 
        ssh $elenuar "/opt/schrodinger2018-2/licadmin STAT -c 27008@149.132.157.125:/opt/schrodinger/licenses/"
    fi
}

function truecolors {
    awk 'BEGIN{
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s s s s s s s s s s s s s s s s;
        for (colnum = 0; colnum<256; colnum++) {
            r = 255-(colnum*255/255);
            g = (colnum*510/255);
            b = (colnum*255/255);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}

function chunk {
    khd &
    chunkwm &
}

function toggle_desktop_icons {
    local state
    state=$(defaults read com.apple.finder CreateDesktop)
    if $state; then
        defaults write com.apple.finder CreateDesktop false; killall Finder
    else
        defaults write com.apple.finder CreateDesktop true; killall Finder
    fi
}

function neovim_remote {
    local serverlist
    serverlist="$(nvr --serverlist)"
    if [[ -z "$serverlist" ]]; then
        NVIM_LISTEN_ADDRESS=/tmp/nvimsocket /opt/bin/nvim "$@"
    else
        /opt/bin/nvim "$@"
    fi
}

function google {
    open "https://www.google.com/search?q=$*"
}


# }}}

# Zle, Zstyle {{{
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' menu true=long select=long
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[33;1m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[31;1m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[31;1m -- No matches found --\e[0m'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:default' list-colors '=(#b)*(-- *)=0=94' ${(s.:.)LS_COLORS}
# }}}

# Aliases {{{
# see ~/.zplugin/plugins/_local---common-aliases/common-aliases.plugin.zsh

alias juliapro=/Applications/JuliaPro-0.6.1.1.app/Contents/Resources/julia/Contents/Resources/julia/bin/julia
alias julia=/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia
alias licmoe="lmutil lmstat -c /Applications/moe2018/license.dat -a"
alias licdes="licmae | grep -A 3 DESMOND_GPGPU"
alias valve.py=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/valve.py
alias catdcd="/Applications/VMD\ 1.9.4.app/Contents/vmd/plugins/MACOSXX86/bin/catdcd5.2/catdcd"
alias vmd="/Applications/VMD\ 1.9.4.app/Contents/Resources/VMD.app/Contents/MacOS/VMD"
alias spritz="~/Desktop/tommy/nsfw/spritz.py"
alias nvm_init="source $NVM_DIR/nvm.sh"
alias fz="cd \$(z | awk '{print \$2}' | fzf)"
alias nvim=neovim_remote
alias tflip='echo "(╯°□°)╯︵ ┻━┻"'
alias schrenv=". ~/Documents/Schrodinger/schrodinger.ve/bin/activate.zsh"
alias rsync="rsync --progress -th"
# }}}

# compinit / compdef {{{
autoload -Uz compinit
compinit -i
compdef neovim_remote=nvim
zplugin cdreplay -q
# }}}

# other sources  {{{
source /opt/gromacs-2018/bin/GMXRC.zsh
source /opt/local/share/tldr-cpp-client/autocomplete/complete.zsh
source /opt/local/etc/profile.d/z.sh
source ~/.fzf.zsh
#test -e "$HOME/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# }}}

# zprof

# vim:set et sw=2 ts=2 fdm=marker:
