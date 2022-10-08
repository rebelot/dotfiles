local db = require("dashboard")
local version = vim.version()
db.custom_header = {
    "            :h-                                  Nhy`               ",
    "           -mh.                           h.    `Ndho               ",
    "           hmh+                          oNm.   oNdhh               ",
    "          `Nmhd`                        /NNmd  /NNhhd               ",
    "          -NNhhy                      `hMNmmm`+NNdhhh               ",
    "          .NNmhhs              ```....`..-:/./mNdhhh+               ",
    "           mNNdhhh-     `.-::///+++////++//:--.`-/sd`               ",
    "           oNNNdhhdo..://++//++++++/+++//++///++/-.`                ",
    "      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:       ",
    " .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+        ",
    " h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`         ",
    " hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`        ",
    " /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.       ",
    "  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.      ",
    "   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.     ",
    "     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`    ",
    "       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:    ",
    "       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`   ",
    "       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:   ",
    "       //+++//++++++////+++///::--                 .::::-------::   ",
    "       :/++++///////////++++//////.                -:/:----::../-   ",
    "       -/++++//++///+//////////////               .::::---:::-.+`   ",
    "       `////////////////////////////:.            --::-----...-/    ",
    "        -///://////////////////////::::-..      :-:-:-..-::.`.+`    ",
    "         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -   ",
    "           ::::://::://::::::::::::::----------..-:....`.../- -+oo/ ",
    "            -/:::-:::::---://:-::-::::----::---.-.......`-/.      ``",
    "           s-`::--:::------:////----:---.-:::...-.....`./:          ",
    "          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`           ",
    "         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-              ",
    "        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                ",
    "                        .-:mNdhh:.......--::::-`                    ",
    "                           yNh/..------..`                          ",
    "                                                                    ",
    "N E O V I M - v " .. version.major .. "." .. version.minor,
}

db.custom_center = {
    {
        desc = "Find File                     ",
        shortcut = "<leader>ff",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "Telescope find_files",
    },
    {
        desc = "Recents                       ",
        shortcut = "<leader>fh",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "Telescope oldfiles",
    },

    -- { shortcut = "<leader>fr", icon = " ", desc = "Favourite", action = "Telescope frecency" },
    -- { shortcut = "<leader>fg", icon = " ", desc = "Find Word", action = "Telescope live_grep" },

    {
        desc = "New File                      ",
        shortcut = "<leader>en",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "enew",
    },

    -- { shortcut = "<leader>fm", icon = " ", desc = "Bookmark", action = "Telescope marks" },
    -- { shortcut = "l", icon = " ", desc = "Load Last Session", action = "SessionLoad" },

    {
        desc = "Update Plugins                ",
        shortcut = "         u",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "PackerUpdate",
    },
    {
        desc = "Setting                       ",
        shortcut = "         s",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "edit $MYVIMRC",
    },
    {
        desc = "Exit                          ",
        shortcut = "         q",
        icon = " ",
        icon_hl = { link = "Function" },
        action = "exit",
    },
}

db.custom_footer = { "type  :help<Enter>  or  <F1>  for on-line help" }

vim.cmd([[
augroup dashboard_au
     autocmd! * <buffer>
     autocmd FileType dashboard setlocal buftype=nofile
     autocmd FileType dashboard setlocal nonumber norelativenumber nocursorline noruler
     autocmd FileType dashboard nnoremap <buffer> q <cmd>exit<CR>
     autocmd FileType dashboard nnoremap <buffer> u <cmd>PackerUpdate<CR>
     " autocmd FileType dashboard nnoremap <buffer> <leader>l <cmd>SessionLoad<CR>
     autocmd FileType dashboard nnoremap <buffer> s <cmd>edit $MYVIMRC<CR>
augroup END
]])

-- " =================     ===============     ===============   ========  ========
-- " \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
-- " ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
-- " || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
-- " ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
-- " || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
-- " ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
-- " || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
-- " ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
-- " ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
-- " ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
-- " ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
-- " ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
-- " ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
-- " ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
-- " ||.=='    _-'                                                     `' |  /==.||
-- " =='    _-'                        N E O V I M                         \/   `==
-- " \   _-'                                                                `-_   /
-- " }
-- "  `''                                                                      ``'
