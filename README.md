# Dotfiles

My configuration files for vim and tmux

Please read the [Important Notes](README.md#important-notes)

![my setup](screenshot.png)

## Plugin managers:

follow specific pluign manager instrucions for installation

* **Vim**: [Vundle](http://github.com/VundleVim/Vundle.Vim)
* **tmux**: [tpm](https://github.com/tmux-plugins/tpm)

## Vim

### Vim Plugins

* **'tpope/vim-fugitive'**: a tmux wrapper so awesome it should be illegal
* **'ctrlpvim/ctrlp.vim'**: fuzzy finder for files, mru and buffers 
* **'rstacruz/sparkup'**: html syntax
* **'flazz/vim-colorschemes'**: one colorscheme package to rule them all
* **'JuliaEditorSupport/julia-vim'**: julia language support (syntax and latex completions)
* **'Valloric/YouCompleteMe'**: an awesome syntax completer
* **'vim-airline/vim-airline'**: lightweight statusline, integrated with most plugins (better with powerline font)
* **'vim-airline/vim-airline-themes'**: themes for airline statusline
* **'bling/vim-bufferline'**: show buffer names within statusline or command line
* **'vim-utils/vim-man'**: open Man pages in vim
* **'majutsushi/tagbar'**: navigate tags (requires Exuberant Ctags)
* **'moll/vim-bbye'**: useful functions to close buffers without disrupting splits layout
* **'jlanzarotta/bufexplorer'**: buffer navigator
* **'lambdalisue/suda.vim'**: edit files with piviledges
* **'plasticboy/vim-markdown'**: add markdown syntax
* **'scrooloose/nerdtree'**: file explorer and filesystem operations
* **'ivalkeen/nerdtree-execute.git'**: NERDTree plugin to open files with systems default programs
* **'lervag/vimtex.git'**: LaTex support and useful functions (continuous compile, preview, etc)
* **'tmux-plugins/vim-tmux'**: vim and tmux happy together
* **'tmux-plugins/vim-tmux-focus-events'**: better event handling when running in tmux
* **'vim-syntastic/syntastic'**: powerful syntax checker
* **'vim-scripts/Gundo'**: Undo Tree done right, easily explore and restore file changes 
* **'vim-scripts/YankRing.vim'**: emacs-like kill-ring to cycle across pasted text
* **'Shougo/unite.vim'**: fuzzy finder, buffer, mru, yank history and much more
* **'junegunn/goyo.vim'**: distraction free mode for vim
* **'metakirby5/codi.vim'**: real time REPL evaluation of code lines
* **'terryma/vim-multiple-cursors'**: sublime-like multiple cursors
* **'chrisbra/csv.vim'**: awesome support to easily view and navigate .csv files
* **'chrisbra/vim-diff-enhanced'**: customize diff checkers
* **'chrisbra/NrrwRgn'**: focus mode, edit selected text in a new buffer
* **'wesQ3/vim-windowswap'**: easily swap windows without affecting splits layout
* **'mileszs/ack.vim'**: awesome super fast file contents searcher
* **'lifepillar/vim-solarized8'**: true color solarized colorscheme
* **'vim-scripts/Vim-Gromacs'**: filetypes for Gromacs

### Other functionalities
Other functionalities that may require specific settings or external applications.
_NOTE_ that graphical enchancements such as truecolors and italicized text require compliant terminals.
**iTerm2** would be a great choice since already supports many features, such as easy clipboard access, italics and bold text, and dynamic cursor shapes

* **fzy**: fzy finder integration, see `FzyCommand` function, **requires fzy**
* **True Colors**: enable True Colors with `set termguicolors`, also in tmux by adding:
    ```vim
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    ```
* **_italics_ comments**: this is easy in Vim, requires a hack to work in tmux 
    ```vim
    let &t_ZH="\e[3m"   
    let &t_ZR="\e[23m"
    highlight Comment cterm=italic, gui=italic
    ```
* **cursor shape**: change cursor shape when in `INSERT`, `NORMAL` or `REPLACE` modes. Send the right escapes when in tmux
_NOTE_, there is currently no way to detect when in operator-pending mode (e.g.: after `y` or `d`), although hacky functions exist
* **fancy highlights**: highlight line numbers in active window, underline current line for special windows
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
* **custom mappings and special settings** are all documented within the vimrc

## Tmux

### Tmux plugins

* **'tmux-plugins/tpm'**: tmux plugin manager
* **'tmux-plugins/tmux-sensible'**: standar configuration anyone can agree upon
* **'tmux-plugins/tmux-pain-control'**: easily move around panes
* **'tmux-plugins/tmux-open'**: open stuff with external apps
* **'tmux-plugins/tmux-sessionist'**: easily manage and switch sessions
* **'tmux-plugins/tmux-sidebar'**: show cwd tree contents in a side pane
* **'tmux-plugins/tmux-yank'**: system clipboard integration, may not be needed in iTerm2 (be sure to set "terminal may access clipboard" iterm option)
* **'soyuka/tmux-current-pane-hostname'**: ssh aware user and host names
* **'nhdaly/tmux-better-mouse-mode'**: perfect mouse mode, works well with man and less pages.
* **'tmux-plugins/tmux-cpu'**: retrieve cpu status (statusline)
* **'jbnicolai/tmux-fpp'**: wrapper for fpp (requires fpp)
* **'tmux-plugins/tmux-online-status'**: retrieve online status (statusline)
* **'tmux-plugins/tmux-prefix-highlight'**: signal when in copy or pending command mode (statusline)

### hacks

* **reattach-to-user-namespace**: wrapper for accessing the OS X pasteboard in tmux sessions
may be installed with MacPorts, run `sudo port install tmux-pasteboard`.
The following settings grant clipboard accessibility to copy commands
    ```tmux
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy" \; display-message "highlighted selection copied to system clipboard"
    ```
* **_italics_ for screen terminal**: tmux terminal has to be set to screen* (i.e.: `set -g default-terminal "screen-256color"`)
but screen terminal really plays bad with Vim graphical customizations, therefore special settings are needed:
    * **override screen-256 color properties**:
        1. create a file named `screen-256color.terminfo` with the following contents:
            ```
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
        2. compile the new terminal configuartions with the following bash command:
            ```
            tic screen-256color.terminfo
            ```
    * set the tmux option `set -g default-terminal "screen-256color"`
    * make sure $TERM is not set within your bash configuration file (`.profile`, `.bash_profile` or `.bashrc`)
    * if things don't work, try forcing tmux startup with:
        ```
        env TERM=screen-256color tmux
        ```
        this issue may be related to other applications overriding system terminal settings, run `which tic` to be sure.

## Important Notes:
* This extensive configuration does not make a paradigm of portability and is suited for users who want to customize Vim and tmux on their local machines.

* Users are discouraged from blindly clone this repo and override their ~/.vimrc and ~/.tmux.conf files for three reasons:
    1. Some features **won't** work straight _out of the box_ and may need trimming depending on your system.
    2. I've configured functionalities and mappings to my taste, you might not **need** (_probable_) or **like** (_highly unprobable_) many of those.
    3. New users should learn _vanilla_ functionalities before embarking in the _non-returning_ trip to dotfiles customization.

    **_The purpose of this repo is to give interested users hints about vim and tmux configuration that may be difficult to come by._**

* Vim Airline plugin may require _Powerline Fonts_ to work at its best, although they are not essential for Airline, I make use of these fonts for tmux statusline configuration. Best choiche would be to install patched fonts from https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy
On OSX, just download *.ttf files and double click to install.

* Vim YouCompleteMe plugin needs to be compiled on your system. Follow the instructions on http://valloric.github.io/YouCompleteMe/#full-installation-guide
oh, and requires **MacVim**!

* When in Tmux, you may notice the following bugs:
    * Vim current cursor shape affects the cursor shape in other tmux windows (easily solved by going back to NORMAL mode before switching panes)
    * Less and Man pages will badly interpret the customized italics escape sequences (see hacks above) and will show highlighted text with italics font. This is annoying when searching text.

    _NOTE_ that there may be fixes for abovementioned bugs, I just didn't find them ;)


