vim.keymap.set('ia', [[\red\]], [[\e[31m]], { buffer = true })
vim.keymap.set('ia', [[\green\]], [[\e[32m]], { buffer = true })
vim.keymap.set('ia', [[\orange\]], [[\e[33m]], { buffer = true })
vim.keymap.set('ia', [[\blue\]], [[\e[33m]], { buffer = true })
vim.keymap.set('ia', [[\magenta\]], [[\e[34m]], { buffer = true })
vim.keymap.set('ia', [[\cyan\]], [[\e[35m]], { buffer = true })
vim.keymap.set('ia', [[\gray\]], [[\e[36m]], { buffer = true })
vim.keymap.set('ia', [[\white\]], [[\e[37m]], { buffer = true })

vim.keymap.set('ia', [[\bgred\]], [[\e[41m]], { buffer = true })
vim.keymap.set('ia', [[\bggreen\]], [[\e[42m]], { buffer = true })
vim.keymap.set('ia', [[\bgorange\]], [[\e[43m]], { buffer = true })
vim.keymap.set('ia', [[\bgblue\]], [[\e[43m]], { buffer = true })
vim.keymap.set('ia', [[\bgmagenta\]], [[\e[44m]], { buffer = true })
vim.keymap.set('ia', [[\bgcyan\]], [[\e[45m]], { buffer = true })
vim.keymap.set('ia', [[\bggray\]], [[\e[46m]], { buffer = true })
vim.keymap.set('ia', [[\bgwhite\]], [[\e[47m]], { buffer = true })

vim.keymap.set('ia', [[\brightred\]], [[\e[91m]], { buffer = true })
vim.keymap.set('ia', [[\brightgreen\]], [[\e[92m]], { buffer = true })
vim.keymap.set('ia', [[\brightorange\]], [[\e[93m]], { buffer = true })
vim.keymap.set('ia', [[\brightblue\]], [[\e[93m]], { buffer = true })
vim.keymap.set('ia', [[\brightmagenta\]], [[\e[94m]], { buffer = true })
vim.keymap.set('ia', [[\brightcyan\]], [[\e[95m]], { buffer = true })
vim.keymap.set('ia', [[\brightgray\]], [[\e[96m]], { buffer = true })
vim.keymap.set('ia', [[\brightwhite\]], [[\e[97m]], { buffer = true })

vim.keymap.set('ia', [[\bgbrightred\]], [[\e[101m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightgreen\]], [[\e[102m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightorange\]], [[\e[103m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightblue\]], [[\e[103m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightmagenta\]], [[\e[104m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightcyan\]], [[\e[105m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightgray\]], [[\e[106m]], { buffer = true })
vim.keymap.set('ia', [[\bgbrightwhite\]], [[\e[107m]], { buffer = true })

vim.keymap.set('ia', [[\end\]], [[\e[0m]], { buffer = true })
vim.keymap.set('ia', [[\bold\]], [[\e[1m]], { buffer = true })
vim.keymap.set('ia', [[\italic\]], [[\e[3m]], { buffer = true })
vim.keymap.set('ia', [[\underline\]], [[\e[4m]], { buffer = true })
vim.keymap.set('ia', [[\blink\]], [[\e[5m]], { buffer = true })
vim.keymap.set('ia', [[\strike\]], [[\e[9m]], { buffer = true })

vim.opt_local.formatprg = "shfmt"
vim.lsp.start({
    name = "bashls",
    cmd = {"bash-language-server", "start"},
    root_dir = vim.fs.root(0, {".git"}),
    single_file_support = true,
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)"
        }
    },
})
