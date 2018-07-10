# ███████╗███████╗██╗  ██╗██████╗  ██████╗
# ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#   ███╔╝ ███████╗███████║██████╔╝██║     
#  ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
# ███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"                  # <-- ~/bin:/usr/lolbin
export PATH="/opt/CHARMM/c38b2/exec/osx/:$PATH"               # <-- CHARMM
export PATH="/opt/dssp/bin:$PATH"                             # <-- dssp
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
source $HOME/venv/bin/activate
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"            # <-- MacPorts
export PATH="/opt/local/libexec/gnubin:$PATH"                 # <-- Coreutils

# Path to oh-my-zsh installation.
export ZSH=/Users/laurenzi/.oh-my-zsh

# ZSH Options
# ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=()

source $ZSH/oh-my-zsh.sh

# sources that have to appear before plugins
source /opt/gromacs-2018/bin/GMXRC.zsh # breaks fast-syntax-hl
source /opt/local/share/tldr-cpp-client/autocomplete/complete.zsh
source /opt/local/etc/profile.d/z.sh
source ~/.fzf.zsh

# init Antigen
source "$HOME/.antigen/antigen.zsh"
antigen init "$HOME/.antigenrc"

# plugin Opts

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern) 
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='default'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='default'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='default'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='default'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
# export FZF_CTRL_T_OPTS=""
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS="
--no-height
--preview '[[ \$(file --mime {}) =~ directory ]] && tree -C {} || { [[ \$(file --mime {}) =~ image ]] && zsh /Users/laurenzi/.oh-my-zsh/plugins/catimg/catimg.sh {}; } || { [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file; } || (pygmentize -O style=monokai -f console256 -g {} || cat {}) 2> /dev/null | head -500'
--bind 'ctrl-o:toggle-preview'
--bind 'tab':down
--bind 'btab:up'
--bind 'ctrl-z':toggle" 

# User configuration

# prompt
prompt_long='%B%F{37}%n%b%f@%B%F{168}%m%b%f:%B%F{222}%~%b%f$ '
prompt_short='%F{magenta}❯%f '
prompt_2long="┌$prompt_long"$'\n'"└$prompt_short"
prompt_2short='%B%F{73}%~%f%b'$'\n'"$prompt_short"

export PS1="$prompt_2short"
ps1_split_state=1
ps1_short_state=1
#export RPROMPT=""

# ls colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagEgGx
# eval $( dircolors -b $HOME/code/src/LS_COLORS/LS_COLORS )

# history
export HISTSIZE=50000
export HISTFILESIZE=-1

# Man
export MANPATH="/usr/local/man:/usr/share/man:$MANPATH"
export MANPATH="/opt/share/man:/opt/local/share/man:/opt/local/libexec/gnubin/man:$MANPATH"
export MANPATH="$HOME/.fzf/man:$MANPATH"
export MANPATH="$MANPATH:/opt/anaconda3/man:/opt/anaconda3/share/man"
# export MANPAGER=most

# programs env opts
export SCHRODINGER="/opt/schrodinger/suites2018-2"
export ILOG_CPLEX_PATH="/Applications/IBM/ILOG/CPLEX_Studio128"
export JULIA_PKGDIR="/Users/laurenzi/.julia"
export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm   # aliased down there
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export PAGER=most

# Compilation flags
export CPPFLAGS="-I/opt/local/include"
export LDFLAGS="-L/opt/local/lib"
export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:$DYLD_LIBRARY_PATH"
export QT_API='pyqt5'
export CXX="/opt/local/bin/clang++"
export CC="/opt/local/bin/clang"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"
export elenuar="159.149.32.81"
export nero="159.149.32.106"
export jessicah="159.149.32.103"

# functions
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
         /opt/schrodinger2018-1/licadmin STAT -c 27008@149.132.157.125:/opt/schrodinger/licenses/
    else 
        ssh $elenuar "/opt/schrodinger2018-1/licadmin STAT -c 27008@149.132.157.125:/opt/schrodinger/licenses/"
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

function prompt_size_toggle {
    if [ $ps1_short_state -eq 0 ]; then
        ps1_short_state=1
        [ $ps1_split_state -eq 0 ] && export PS1=$prompt_short
        [ $ps1_split_state -eq 1 ] && export PS1=$prompt_2short
    elif [ $ps1_short_state -eq 1 ]; then
        ps1_short_state=0
        [ $ps1_split_state -eq 0 ] && export PS1=$prompt_long
        [ $ps1_split_state -eq 1 ] && export PS1=$prompt_2long 
    fi
    zle reset-prompt
}

function prompt_split_toggle {
    if [ $ps1_split_state -eq 0 ]; then
        ps1_split_state=1
        [ $ps1_short_state -eq 0 ] && export PS1=$prompt_2long
        [ $ps1_short_state -eq 1 ] && export PS1=$prompt_2short
    elif [ $ps1_split_state -eq 1 ]; then
        ps1_split_state=0
        [ $ps1_short_state -eq 0 ] && export PS1=$prompt_long
        [ $ps1_short_state -eq 1 ] && export PS1=$prompt_short
    fi
    zle reset-prompt
}

zle -N prompt_size_toggle
zle -N prompt_split_toggle

bindkey "P" prompt_size_toggle
bindkey "p" prompt_split_toggle

# Z-styles
zstyle ':completion:*:descriptions' format 'Select: %d'
zstyle ':completion:*' list-colors ''

# Aliases
# see .oh-my-zsh/custom/plugins/common-aliases/common-aliases.plugin.zsh

alias juliapro=/Applications/JuliaPro-0.6.1.1.app/Contents/Resources/julia/Contents/Resources/julia/bin/julia
alias licmoe="lmutil lmstat -c /Applications/moe2018/license.dat -a"
alias licdes="licmae | grep -A 3 DESMOND_GPGPU"
alias valve.py=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/valve.py
alias catdcd="/Applications/VMD\ 1.9.4.app/Contents/vmd/plugins/MACOSXX86/bin/catdcd5.2/catdcd"
alias vmd="/Applications/VMD\ 1.9.4.app/Contents/Resources/VMD.app/Contents/MacOS/VMD"
#alias X11=xquartz
alias em="/Applications/MacPorts/Emacs.app/Contents/MacOS/emacs"
alias port-switch='sudo "/Users/laurenzi/code/src/port-switch_command"'
alias spritz="~/Desktop/tommy/nsfw/spritz.py"
# alias schrun="$SCHRODINGER/run"
alias nvm_init="source $NVM_DIR/nvm.sh"
alias fz="cd \$(z | awk '{print \$2}' | fzf)"

#test -e "$HOME/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

compinit
