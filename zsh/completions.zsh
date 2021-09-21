zmodload -i zsh/complist
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select

# case and hyphen insensitive
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# case insensitvie, hyphen sensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
# ... unless we really want to.
zstyle '*' single-ignored show

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

# (( $+commands[dircolors] )) && eval "$(dircolors -b $HOME/.LS_COLORS)" # coreutils tool, exports LS_COLORS
(( $+commands[vivid] )) && export LS_COLORS="$(vivid generate tokyonight)" # coreutils tool, exports LS_COLORS
zstyle ':completion:*:default' list-colors '=(#b)*(-- *)=0=94' ${(s.:.)LS_COLORS}

# expand-or-complete-with-dots
expand-or-complete-with-dots() {
# toggle line-wrapping off and back on again
[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
print -Pn "%{%F{red}......%f%}"
[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

zle expand-or-complete
zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

