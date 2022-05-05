require("nvim-autopairs").setup({
    fast_wrap = {
        chars = { "{", "[", "(", '"', "'", "`" },
        map = "<M-l>",
        keys = "asdfghjklqwertyuiop",
        pattern = string.gsub([[ [%'%"%)%,>%]%)%}%,%:] ]], "%s+", ""),
        check_comma = true,
        end_key = "L",
        highlight = "HopNextKey",
        hightlight_grey = "HopUnmatched",
    },
    check_ts = true,
    enable_check_bracket_line = false,
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({
        map_char = {
            tex = "",
        },
    })
)
