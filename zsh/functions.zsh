function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
	  echoti tsl
	  print -Pn "$1"
	  echoti fsl
	fi
      fi
      ;;
  esac
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

function cdw {
	cd "$(dirname "$(which "$1")")"
}
