# Dotfiles

My configuration files for various stuff.

Please read the [Important Notes](README.md#important-notes)

![my setup](screenshot.png)

## Vim/Neovim

Some functionalities may require specific settings or external applications.
_NOTE_ that graphical enchancements such as truecolors and italicized text require compliant terminals.
**iTerm2** would be a great choice since already supports many features, such as easy clipboard access, italics and bold text, and dynamic cursor shapes

* **True Colors**: enable True Colors with `set termguicolors`, also in tmux by adding:
    ```vim
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    ```
* **_italics_ comments**: this is easy in Vim, requires a properly set terminal to work when in tmux (see below)
    ```vim
    let &t_ZH="\e[3m"   
    let &t_ZR="\e[23m"
    highlight Comment cterm=italic, gui=italic
    ```
* **cursor shape**: change cursor shape when in `INSERT`, `NORMAL` or `REPLACE` modes (this is a default in neovim). Send the right escapes when in tmux
_NOTE_, there is currently no way to detect when in operator-pending mode (e.g.: after `y` or `d`), although hacky functions exist
**NOTE**: `t_XX` options no longer exist in neovim, if the appropriate escape sequences are defined for your terminal then all _shouls_ work.
* **arrow keys in screen tmux**: correctly interpret arrow keys when running in tmux. requires tmux option: `set-window-option -g xterm-keys on`
    ```vim
    if &term =~ '^screen'
        " tmux will send xterm-style keys when its xterm-keys option is on
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    endif
    ```
    **NOTE**: This is not a problem in neovim, also in vim, you may not experience this issue, but if you see your arrow keys acting funny when in tmux, consider trying this solution.
* **custom mappings and special settings** are all documented within the vimrc

## Tmux

### hacks

* **reattach-to-user-namespace**: wrapper for accessing the OS X pasteboard in tmux sessions
may be installed with MacPorts, run `sudo port install tmux-pasteboard`.
The following settings grant clipboard accessibility to copy commands
    ```tmux
    set-option -g default-command "reattach-to-user-namespace -l $SHELL"
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy" \; display-message "highlighted selection copied to system clipboard"
    ```

* **True colors** If your terminal emulator supports truecolors then you may set `set termguicolors` in your vimrc. To enable truecolors in tmux, you will have to set `set-option -ga terminal-overrides   ",xterm-256color:Tc"` in your tmux.conf. **NOTE** that there is a lot of confusion about this: _regardless_ of the terminal that tmux sets for itself (which should be `screen-256color` of `tmux-256color` depending on your version of tmux), you have to override the terminal info of the terminal that is set when you launch tmux. I.e. if your terminal emulator (iTerm2 or Terminal.app) sets up `xterm-256color`, then you need to override the tmux internal representation of that terminal with the above mentioned command.
* **_italics_ for screen terminal**: tmux terminal has to be set to screen* (i.e.: `set -g default-terminal "screen-256color"`)
but screen terminal really plays bad with Vim graphical customizations, therefore special settings are needed:
    * **override screen-256 color properties**:
        1. create a file named `screen-256color.terminfo` with the following contents:
            ```terminfo
            # A screen-256color based TERMINFO that adds the escape sequences for italic.
            #
            # Install:
            #
            #   tic screen-256color.terminfo
            #
            # Usage:
            #
            #   export TERM=screen-256color
            #
            screen-256color|screen with 256 colors and italic,
                    sitm=\E[3m, ritm=\E[23m,
                    use=screen-256color,
            ```
        2. compile the new terminal configurations with the following bash command:
            ```bash
            tic screen-256color.terminfo
            ```
        3. If you have a recent enough version of tmux, and you should, you can use `tmux-256color` terminal instead of screen. This is recommended since it handles highlighted text and italics properly. Check in `/usr/share/terminfo` if `tmux-256color` is present, if you have **macoprts**, `/opt/local/share/terminfo` will have it, but be careful to have `/opt/local/bin/infocmp` also in your login startup `$PATH`. Otherwise, you may compile the `tmux-256color.terminfo` file in this repo with `/usr/bin/tic`.
    * Set the tmux option `set -gs default-terminal "screen-256color"` (or tmux-256color)
    * make sure $TERM is not set within your bash configuration file (`.profile`, `.bash_profile` or `.bashrc`)
    * if things don't work, try forcing tmux startup with:
        ```bash
        env TERM=screen-256color tmux
        ```
        this issue may be related to other applications overriding system terminal settings. The compiled product of the terminfo file is stored within a terminfo database, usually in `$HOME/.terminfo`, you have to make sure that the `tic` command you used to compile the terminfo file comes from the same distribution of the command `infocmp` and that they are accessible by tmux startup `$PATH`, which is the `$PATH` of login shells. Usually `tic` and `infocmp` are located in `/usr/bin/`, but other package managers may override these commands.I.e., **macports** and **Anaconda** have their versions in their relative bin folders (usually `/opt/local/bin` and `/opt/anaconda3/bin`). Be sure that whatever command you use to compile the terminal specs is visible by tmux startup environment or you are likely to see weird things in your terminal.

## Important Notes:
* This extensive configuration does not make a paradigm of portability and is suited for users who want to customize Vim and tmux on their local machines.

* Users are discouraged from blindly clone this repo and override their ~/.vimrc and ~/.tmux.conf files for three reasons:
    1. Some features **won't** work straight _out of the box_ and may need trimming depending on your system.
    2. I've configured functionalities and mappings to my taste, you might not **need** (_probable_) or **like** (_highly improbable_) many of those.
    3. New users should learn _vanilla_ functionalities before embarking in the _non-returning_ trip to dotfiles customization.

    **_The purpose of this repo is to give interested users hints about vim and tmux configuration that may be difficult to come by._**

* Vim Airline plugin may require _Powerline Fonts_ to work at its best, although they are not essential for Airline, I make use of these fonts for tmux statusline configuration. Best choiche would be to install patched fonts from https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy
On OSX, just download *.ttf files and double click to install.
