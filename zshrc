#
# ███████╗███████╗██╗  ██╗██████╗  ██████╗
# ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#   ███╔╝ ███████╗███████║██████╔╝██║
#  ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# zmodload zsh/zprof

# $PATH {{{
# /etc/paths: /usr/local/bin /usr/bin /bin /usr/sbin /sbin
export PATH="$HOME/usr/bin:$PATH"                             # <-- personal stuff
export PATH="$HOME/.cargo/bin:$PATH"                          # <-- cargo
export PATH="$HOME/.luarocks/bin:$PATH"                       # <-- LuaRocks
# export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"                 # <-- ruby gem
export PATH="$HOME/.npm-packages/bin:$PATH"                   # (node installer) npm config set prefix "${HOME}/.npm-packages"
# export PATH="$HOME/.yarn/bin:$PATH"                           # <-- yarn (node)
export PATH="$HOME/go/bin:$PATH"                              # <-- go
source "$HOME/anaconda3/etc/profile.d/conda.sh"
[[ -z $TMUX ]] || conda deactivate; conda activate py13      #   + TMUX fix
source "$HOME/venvs/base/bin/activate"                        # <-- Activate the Python
# }}}

# $MANPATH {{{
# export MANPATH="/usr/local/man:/usr/share/man:$MANPATH"
# export MANPATH="/opt/share/man:/opt/local/share/man:/opt/local/libexec/gnubin/man:$MANPATH"
# export MANPATH="$HOME/.fzf/man:$MANPATH"
# export MANPATH="$MANPATH:/opt/anaconda3/man:/opt/anaconda3/share/man"
# }}} no need, man smart, man good, if set, man breaks in tmux

# LS_COLORS
# (( $+commands[dircolors] )) && eval "$(dircolors -b $HOME/.LS_COLORS)" # coreutils tool, exports LS_COLORS
# (( $+commands[dircolors] )) && eval "$(dircolors -b)" # coreutils tool, exports LS_COLORS
(( $+commands[vivid] )) && export LS_COLORS="$(vivid generate tokyonight)" # coreutils tool, exports LS_COLORS

# ZSH init {{{
export ZSH="$HOME/.zsh"
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
# TODO: overhaul:
# check zplug for plugin management
# macports can install syntax highlighting and zsh-completions
# check https://starship.rs/guide/#%F0%9F%9A%80-installation
# check git prompt at https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# or use vcs_info zsh builtin module
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

# zinit load srijanshetty/zsh-pandoc-completion

zinit light bric3/oh-my-zsh-git
zinit light esc/conda-zsh-completion
zinit ice lucid wait blockf atpull'zinit creinstall -q .' atload"zicdreplay"; zinit light zsh-users/zsh-completions
zinit ice lucid wait; zinit light hlissner/zsh-autopair
zinit ice lucid wait atload"_zsh_autosuggest_start"; zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait; zinit light zdharma-continuum/fast-syntax-highlighting
# }}}


# compinit / compdef {{{
autoload -Uz compinit
compinit -i
# zinit cdreplay -q # zicdreplay
# }}}

# other sources  {{{
source /usr/local/etc/profile.d/z.sh
source <(fzf --zsh)
# eval "$(pip completion --zsh)"
# }}}

# plugin Opts {{{
# omg_prefix=" %{%B%F{white}%}%{%f%k%b%}"
omg_suffix=" %{%B%F{white}%}  %{%f%k%b%}"
is_a_git_repo_symbol=" "
has_modifications_symbol=
has_modifications_color="%F{yellow}"
has_untracked_files_symbol=
ready_to_commit_symbol=
should_push_symbol=
detached_symbol=
print_unactive_flags_space=false
#                  
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
# export FZF_CTRL_T_OPTS=""
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_COMMAND="fd --follow --hidden --color=always" #--ignore-file=$HOME/.gitignore"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="$(echo \
"--ansi \
--no-height \
--preview '[[ \$(file --mime {}) =~ directory ]] && tree -C {} || { [[ \$(file --mime {}) =~ image ]] && catimg {}; } || { [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file; } || bat --color=always --style=numbers,changes,snip {}' \
--preview-window wrap:hidden \
--border --margin=0,2 \
--bind 'ctrl-o:toggle-preview' \
--bind 'tab:down' \
--bind 'btab:up' \
--bind 'ctrl-z:toggle' ")"
# }}}

# User configuration {{{

# prompt
export PS1="$prompt_2short" # Set in $ZSH/prompt.zsh
export RPROMPT='$(oh_my_git_info)'

# ls colors
export CLICOLOR=1
autoload -U colors && colors
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LSCOLORS=ExFxBxDxCxegedabagEgGx
# eval "$(dircolors -b)" # coreutils tool, exports LS_COLORS moved in $ZSH/completions.zsh

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000
export HISTFILESIZE=-1

# programs env opts
export SCHRODINGER="/opt/schrodinger/suites2024-2"
export SCHRODINGER_ALLOW_UNSAFE_MULTIPROCESSING=1 #FUCK OFF
export PYMOL4MAESTRO="/opt/anaconda3/envs/pymol/bin/"
# export ILOG_CPLEX_PATH="/Applications/IBM/ILOG/CPLEX_Studio128"
# export JULIA_PKGDIR="/Users/laurenzi/.julia"
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export SCHRODINGER_SCRIPTS="$HOME/usr/src/schrodinger_utils/scripts"
export XLSCRIPTS="$HOME/usr/src/xlence_scripts"
export BIOTOOLS="$HOME/usr/src/BioTools"
export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython"

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

# XDG
export XDG_CONFIG_HOME="$HOME/.config/"

# }}}

# Functions {{{

function deskhide {
    local state
    state=$(defaults read com.apple.finder CreateDesktop)
    if $state; then
        defaults write com.apple.finder CreateDesktop false; killall Finder
    else
        defaults write com.apple.finder CreateDesktop true; killall Finder
    fi
}

function google {
    open "https://www.google.com/search?q=$*"
}

function lessc {
    pygmentize -O style=monokai -f terminal16m -g $1 | less
}

function tedit {
    tmux splitw "nvim $@"
}

function cythonsetup {
    local exts=("$@")
    cat << EOF > setup.py
from setuptools import setup
from Cython.Build import cythonize

extensions = "${exts[@]}".split()
setup(
    ext_modules = cythonize(extensions, language_level = "3")
)
EOF
    bash -c 'read -p "Build? [y/n] " input
    if [[ $input = "y" ]]; then python setup.py build_ext --inplace fi'
}

function pman {
    tmux display-popup -E "man $@"
}

function remote_notebook {
    # 8080
    jupyter notebook --no-browser --port=$1
}

function ssh_forward {
    # 8080 xlence
    ssh -L $1:localhost:$1 $2
}

# function neovim_remote {
#     args=("$@")
#     real_args=()
#     for arg in "${args[@]}"; do
#         real_args+=("$(realpath $arg)")
#     done
#     nvim --server $NVIM_LISTEN_ADDRESS --remote ${real_args[@]}
# }
# }}}

# Aliases {{{
# see $ZSH/aliases.zsh

alias licdes="licmae | grep -A 3 DESMOND_GPGPU"
alias vmd='/Applications/VMD\ 1.9.4a57-x86_64-Rev12.app/Contents/MacOS/startup.command'
alias fz="cd \$(z | awk '{print \$2}' | fzf)"
alias tflip='echo "(╯°□°)╯︵ ┻━┻"'
alias schrenv=". ~/venvs/schrodinger.ve/bin/activate"
alias clock='tty-clock -c -f %d-%m-%Y'
alias vim=nvim
# alias debugpy="python $HOME/venvs/debugpy/lib/python3.9/site-packages/debugpy --listen localhost:5678 --wait-for-client"
alias pudb='python -m pudb'
alias ptpy='ptipython'
alias vxl='/opt/VirtualGL/bin/vglconnect -s xlenceVPN'
alias pymol='/Applications/PyMOL.app/Contents/bin/pymol -q -X 400 -Y 20 -W 800 -H 800 -d "cd $(pwd)"'
# alias codelldb="while sleep 1; do $HOME/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/adapter/codelldb --port 13000 --liblldb $HOME/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/lldb/lib/liblldb.dylib; done"
alias schrdoc="open $SCHRODINGER/docs/Documentation.htm"
alias fuck='killall -9'
alias mdclean='rm -ri *_trj *out* *cpt* *log *.ene *checkpoint* *-in.cms'
alias pipupdate='pip list -lo --format json |  python -c "import json, sys; print(\"\n\".join([x[\"name\"] for x in json.load(sys.stdin)]))" | xargs -n1 pip install -U'
alias icat='kitty +kitten icat'
alias kitty_make_conf='kitty +runpy "from kitty.config import commented_out_default_config as conf; print(conf());"'
# alias nvr=neovim_remote
# alias nvrs="nvim --server $NVIM_LISTEN_ADDRESS --remote-send"
# alias nvre="nvim --server $NVIM_LISTEN_ADDRESS --remote-expr"

# }}}

# Remove duplicates from PATH (Unique)
typeset -U path

# MANPATH Guard
unset MANPATH

# zprof

# vim:set et sw=4 ts=4 fdm=marker:
