local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local version = vim.version()
dashboard.section.header.val = {
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
    "                          N E O V I M - v " .. version.major .. "." .. version.minor,
}

dashboard.section.header.opts = {
    hl = "DashboardHeader",
    position = "center",
}

dashboard.section.buttons.val = {
    dashboard.button("<leader>ff", "  Find File", ":Telescope find_files<CR>"),
    dashboard.button("<leader>fh", "  Recents", ":Telescope oldfiles<CR>"),
    -- dashboard.button("<leader>fr", "  Favourite",         ":Telescope frecency<CR>"),
    -- dashboard.button("<leader>fg", "  Find Word",          ":Telescope live_grep<CR>"),
    dashboard.button("<leader>en", "  New File", ":enew<CR>"),
    -- dashboard.button("<leader>fm", "  Bookmark",          ":Telescope marks<CR>"),
    -- dashboard.button("l",          "  Load Last Session", ":SessionLoad<CR>"),
    dashboard.button("u", "  Update Plugins", ":PackerUpdate<CR>"),
    dashboard.button("s", "  Setting", ":edit $MYVIMRC<CR>"),
    dashboard.button("q", "  Exit", ":exit<CR>"),
}

-- dashboard.section.buttons.type = 'group'
-- dashboard.section.buttons.opts = {
--     hl = 'yellow', --"DashboardCenter",
--     hl_shortcut = 'DashboardShortcut',
--     position = "center",
--     spacing = 1
-- }

dashboard.section.footer.val =  "type  :help<Enter>  or  <F1>  for on-line help"
dashboard.section.footer.opts = {
    hl = "DashboardFooter",
    position = "center"
}
-- vim.cmd [[
-- augroup dashboard_au
--      autocmd! * <buffer>
--      autocmd FileType alpha setlocal buftype=nofile
--      autocmd FileType alpha nnoremap <buffer> <leader>q <cmd>exit<CR>
--      autocmd FileType alpha nnoremap <buffer> <leader>u <cmd>PackerUpdate<CR>
--      autocmd FileType alpha nnoremap <buffer> <leader>l <cmd>SessionLoad<CR>
--      autocmd FileType alpha nnoremap <buffer> <leader>, <cmd>edit $MYVIMRC<CR>
-- augroup END
-- ]]

alpha.setup(dashboard.config)

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
