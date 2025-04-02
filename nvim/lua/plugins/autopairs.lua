require("nvim-autopairs").setup({
    fast_wrap = {
        chars = { "{", "[", "(", '"', "'", "`" },
        map = "<M-l>",
        keys = "asdfghjklqwertyuiop",
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        check_comma = true,
        end_key = "L",
        highlight = "PmenuSel",
        hightlight_grey = "NonText",
    },
    check_ts = true,
    enable_check_bracket_line = true,
})
