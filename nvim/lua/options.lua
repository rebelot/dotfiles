vim.g.python3_host_prog = "/Users/laurenzi/venvs/base/bin/python"
vim.g.python_host_prog = "/Users/laurenzi/venvs/base27/bin/python"
-- vim.g.netrw_browsex_viewer  = 'open'

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.o.termguicolors = true -- enable gui colors for terminal
vim.g.vimsyn_embed = "lPr"
vim.g.tex_flavor = "latex"
vim.o.encoding = "utf-8"
vim.o.modeline = true
vim.o.mouse = "a" -- enable mouse for all modes
vim.o.errorbells = false -- remove all errors
vim.o.visualbell = false
vim.o.history = 1000 -- remember more commands and search history
vim.o.undolevels = 1000 -- use many muchos levels of undo
vim.o.title = true -- change the terminal's title
vim.o.backup = false -- no backup file
vim.o.swapfile = false -- don't write .swp files
vim.o.undofile = true -- default `undodir = ~/.local/share/nvim/undo/`
vim.o.wrap = false -- don't wrap lines
vim.o.tabstop = 4 -- a tab is four spaces
vim.o.shiftwidth = vim.o.tabstop -- number of spaces to use for autoindenting
vim.o.shiftround = true -- use multiple of shiftwidth when indenting with '<' and '>'
vim.o.expandtab = true -- expand tab to count tabstop n° of spaces
vim.o.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
vim.o.autoindent = true
vim.o.copyindent = true -- copy the previous indentation on autoindenting
vim.o.number = true -- always show line numbers
-- vim.o.relativenumber = true
vim.o.showmatch = true -- show matching parenthesis with a quick jump
vim.o.ignorecase = true -- ignore case when searching with / or ?
vim.o.smartcase = true -- ignore case if search pattern is all lowercase, case-sensitive otherwise
vim.o.smarttab = true -- insert tabs on the start of a line according to shiftwidth, not tabstop
vim.o.hlsearch = true -- highlight search terms
vim.o.incsearch = true -- show search matches as you type
vim.o.hidden = true -- allow modified buffers to be hidden
vim.o.wildignore = "*.swp,*.bak,*.pyc,*.class"
vim.o.wildmode = "longest,full" -- set the behavior of the completion menu
vim.o.wildmenu = true -- diplay command completion listing and choice menu
vim.opt.wildoptions:append({ "pum" })
vim.o.wildcharm = 26 -- trigger completion in macros
vim.o.wildignorecase = true -- ignore case command completion menu
-- vim.o.clipboard            = "unnamed"         -- send yanks to system clipboard (buggy with v-block)
vim.o.showcmd = true -- show key spressed in lower-right corner
vim.o.sidescroll = 1 -- smooth side scrolling
-- vim.o.scrolloff = 16 -- minimal number of lines above/below cursor (see autocommands)
vim.o.conceallevel = 2 -- conceal marked text
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.pumheight = 15 -- set menu max height

vim.opt.fillchars:append({
    fold = " ",
    horiz = "━", -- '▃',--'═', --'─',
    horizup = "┻", --'╩',-- '┴',
    horizdown = "┳", --'╦', --'┬',
    vert = "┃", --'▐', --'║', --'┃',
    vertleft = "┨", --'╣', --'┤',
    vertright = "┣", --'╠', --'├',
    verthoriz = "╋", --'╬',--'┼','
})

vim.opt.fillchars:append({ foldopen = "▾", foldsep = "│", foldclose = "▸" })

vim.o.inccommand = "nosplit" -- real time preview of substitution commands
vim.o.showmode = false -- Do not show -- MODE -- in cmdline--
vim.o.cmdheight = 1 -- Height of the command line
vim.o.updatetime = 250 -- time required to update CursorHold hook
vim.opt.shortmess:append({ c = true })
-- -- vim.o.printdevice       = "OLIVETTI_d_COPIA4500MF_plus__2_"
vim.o.showbreak = "↪ "
vim.o.listchars = "tab:|.,trail:_,extends:>,precedes:<,nbsp:~,eol:¬"
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.dictionary = "/usr/share/dict/words"

function _G.CustomFoldText()
    return vim.fn.getline(vim.v.foldstart) .. " ... " .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end

vim.opt.foldtext = "v:lua.CustomFoldText()"

