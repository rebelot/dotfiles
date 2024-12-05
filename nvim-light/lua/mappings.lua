vim.api.nvim_create_user_command("Oldfiles",
    function(args) vim.cmd("e " .. args.args) end, {
    nargs = 1,
    complete = function(arglead)
        local files = vim.tbl_filter(function(f)
            return vim.fn.filereadable(f) > 0
        end, vim.v.oldfiles)
        local list = vim.fn.matchfuzzy(files, arglead)
        return #list > 0 and list or files
    end
})

vim.api.nvim_create_user_command("CD", "cd %:p:h", {})

vim.g.mapleader = ","
local map = vim.keymap.set
map("n", "gbh", ":Oldfiles <C-Z>")
map({"x", "n"}, "<space>", ":")
map({"x", "n", "o"}, "L", "g_")
map({"x", "n", "o"}, "H", "^")
map({"x", "n", "o"}, "<M-CR>", "-")
map("n", "<esc>", ":noh<CR>")
map("n", "<leader>rn", ":let &rnu=!&rnu<CR,")
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")
map("n", "<C-q>", "<C-W>c")
map("n", "<C-W>V", ":bo vert split<CR>")
map("n", "<C-W>S", ":bo split<CR>")
map("n", "<M-n>", ":bn<CR>")
map("n", "<M-p>", ":bp<CR>")
map("n", "<leader>w", ":write<CR>")
map("x", ">", ">gv")
map("x", "<", "<gv")
map("n", "gbb", ":b <C-Z>")
map("n", "gbs", ":sb <C-Z>")
map("n", "gbv", ":vert sb <C-Z>")
map("n", "gbt", ":tab b <C-Z>")
map("n", "gbd", ":bd <C-Z>")
map("n", "<leader>bd", ":bd<CR>")
map("n", "<leader>bO", ":%bd | e #<CR>")
map("n", "<leader>en", ":enew<CR>")
map("n", "<leader>tn", ":tabnew<CR>")
map("n", "cr", "*``cgn")
map("x", "R", "*``cgn", { remap = true })
map({"n", "x"}, "<leader>y", '"+y')
map({"n", "x"}, "<leader>p", '"+p')
map("x", "<C-U>", ":m '< -<C-R>=v:count1 + 1<CR><CR>gv=gv")
map("x", "<C-D>", ":m '> +<C-R>=v:count1<CR><CR>gv=gv")
map("i", "<C-l>", [[<C-o>:call search("[])}>'\"]", "zec")<CR><Right>]])
map("i", "<C-]>", '<C-R><C-O>"')

local t = function(keys)
    return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

_G.surround_operator = vim.schedule_wrap(
    function(mode, visual)
        local esc = t('<esc>')
        local paste = t('<C-R><C-O>"')
        local pairs = { ['('] = ')', ['['] = ']', ['{'] = '}', ['<'] = '>' }
        if not visual then vim.cmd('execute "normal! q"') end

        local ch1 = vim.fn.getcharstr()
        if ch1 == esc then return "" end
        local ch2 = pairs[ch1] or ch1

        local change_motion = 'c' .. (visual and "" or vim.fn.getreg("s"))
        local keys
        mode = mode == 'v' and 'char' or (mode == 'V' and 'line') or mode
        if mode == 'char' then
            keys = change_motion .. ch1 .. paste .. ch2 .. esc
        elseif mode == 'line' then
            keys = change_motion .. ch1 .. t('<cr>') .. ch2 .. paste .. esc .. "'[=']"
        else
            keys = change_motion .. ch1 ..  ch2 .. esc .. "P"
        end
        local rec = vim.fn.getreg("r")
        if rec ~= '' and not visual then
            vim.cmd(('exe "norm! q%s"'):format(rec:upper()))
            vim.fn.setreg(rec, keys)
        end
        vim.api.nvim_feedkeys(keys, "m", false)
    end
)

map({"n", "x"}, "s", function()
    vim.fn.setreg("r", "")
    local rec = vim.fn.reg_recording()
    vim.fn.setreg("r", rec)

    if vim.fn.mode():match('%^?[vV]') then
        _G.surround_operator(vim.fn.mode(), true)
        return ""
    end
    vim.o.operatorfunc = "v:lua.surround_operator"
    if rec ~= "" then 
        return "qqsg@"
    end
    return "qsg@"

end,{ expr = true } )

local ia = function(char)
    vim.keymap.set({"x", "o"}, "i" .. char, ":<C-U>norm! T" .. char .. "v,<CR>")
    vim.keymap.set({"x", "o"}, "a" .. char, ":<C-U>norm! F" .. char .. "v,<CR>")
end

ia(",")
ia("_")
ia("/")
ia("-")
ia(":")

--  aaaa cc ,asd f,aaaa , asdfasdf, ccc,

map("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
map("i", "<S-Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })
map("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true })

map("c", "<Tab>", function()
    return vim.fn.wildmenumode() == 1 and "<C-n>" or "<C-Z>"
end, { expr = true })
map("c", "<C-n>", function()
    return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
map("c", "<C-p>", function()
    return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true })
