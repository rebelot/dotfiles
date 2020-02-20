# Advanced Aliases.

# ls 
alias ls='ls --color=auto --group-directories-first'
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -lh'      #long list
alias lld='ls -lhd .*'
alias lsd='ls -dh .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias pls="pwd && ls"

autoload -Uz run-help
autoload -Uz run-help-git
alias help=run-help

# zshrc
alias zshrc='$EDITOR ~/.zshrc' # Quick access to the ~/.zshrc file
alias reload='source $HOME/.zshrc'

# Changing/making/removing directory
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# grep
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

# sudo
alias _='sudo'
alias please='sudo $(fc -ln -1)'

# misc
alias dud='du -d 1 -h'
alias duf='du -sh *'

# unless fd exists!
# alias fd='find . -type d -name'
# alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"

alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'
alias rsync="rsync --progress -th"
alias ccat='pygmentize -O style=gruvbox -f terminal16m -g'
alias tc="tree -C"
alias exa="exa --group-directories-first"
alias el="exa -l --icons --colour-scale"
alias ela="el -a"
alias t='tail -f'
# alias vim=nvim
alias edit=nvim # Vim Only!
alias watch="env TERM=xterm-256color watch"
alias pipupdate="pip list --local --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias q=exit

# git
(( $+commands[hub] )) && command -v hub > /dev/null && alias git=hub
alias gr='cd $(git rev-parse --show-toplevel)'
# alias whereami=display_info

# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
# alias -g P="2>&1| pygmentize -l pytb"

#list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar tf"
alias -s tar.gz="echo "
alias -s ace="unace l"

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OPENER=xdg-open
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OPENER=open
fi

_browser_fts=(htm html de org net com at cx nl se dk)
for ft in $_browser_fts; do alias -s $ft=$OPENER; done

_editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
for ft in $_editor_fts; do alias -s $ft=$EDITOR; done

_image_fts=(jpg jpeg png gif mng tiff tif xpm)
for ft in $_image_fts; do alias -s $ft=$OPENER; done

_media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
for ft in $_media_fts; do alias -s $ft=$OPENER; done

#read documents
alias -s pdf=$OPENER
alias -s ps=gv
alias -s dvi=xdvi
alias -s chm=xchm
alias -s djvu=djview

