# ZSH Git Prompt Plugin from:
# http://github.com/olivierverdier/zsh-git-prompt

__GIT_PROMPT_DIR="${0:A:h}"

## Hook function definitions

function is_git_repo() {
    local current_commit_hash="$(git rev-parse HEAD 2> /dev/null)"
    if [[ -n $current_commit_hash ]]; then 
        _is_a_git_repo=true
    else
        _is_a_git_repo=false
    fi
}

function chpwd_update_git_vars() {
    is_git_repo
    if [ $_is_a_git_repo ]; then
        update_current_git_vars
    fi
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    is_git_repo
    if $_is_a_git_repo; then
        if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
            update_current_git_vars
            unset __EXECUTED_GIT_COMMAND
        fi
    fi
}

chpwd_functions+=(chpwd_update_git_vars)
precmd_functions+=(precmd_update_git_vars)
preexec_functions+=(preexec_update_git_vars)


## Function definitions
function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=$(python ${gitstatus} 2>/dev/null)
     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
    GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
    GIT_STAGED=$__CURRENT_GIT_STATUS[4]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
}

git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      fi
      STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo "$STATUS"
    fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{238}  " #     ﯙ               
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
ZSH_THEME_GIT_PROMPT_BRANCH="%F{222} %{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED=" %{%F{179}%}%{%G%} " #   
ZSH_THEME_GIT_PROMPT_CONFLICTS=" %{$fg[red]%}%{%G%} " # 
ZSH_THEME_GIT_PROMPT_CHANGED=" %{%F{208}%}%{%G%} " # 
ZSH_THEME_GIT_PROMPT_BEHIND=" %{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD=" %{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{%F{196}%G%}" # 
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}%{%G%}" # 

# Set the prompt.
RPROMPT='$(git_super_status)'
