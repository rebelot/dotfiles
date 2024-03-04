local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local icons = require("plugins.heirline.common").icons
local separators = require("plugins.heirline.common").separators
local dim = require("plugins.heirline.common").dim

local ViMode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
    },
    provider = function(self)
        return icons.vim .. "%2(" .. self.mode_names[self.mode] .. "%)"
    end,
    --    
    hl = function(self)
        local color = self:mode_color()
        return { fg = color, bold = true }
    end,
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local FileName = {
    init = function(self)
        self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
        if self.lfilename == "" then
            self.lfilename = "[No Name]"
        end
        if not conditions.width_percent_below(#self.lfilename, 0.27) then
            self.lfilename = vim.fn.pathshorten(self.lfilename)
        end
    end,
    hl = function()
        if vim.bo.modified then
            return { fg = utils.get_highlight("Directory").fg, bold = true, italic = true }
        end
        return "Directory"
    end,
    flexible = 2,
    {
        provider = function(self)
            return self.lfilename
        end,
    },
    {
        provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
        end,
    },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = " ● ", --[+]",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
    FileIcon,
    FileName,
    unpack(FileFlags),
}

local FileType = {
    provider = function()
        return string.upper(vim.bo.filetype)
    end,
    hl = "Type",
}

local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc ~= "utf-8" and enc:upper()
    end,
}

local FileFormat = {
    provider = function()
        local fmt = vim.bo.fileformat
        return fmt ~= "unix" and fmt:upper()
    end,
}

local FileSize = {
    provider = function()
        -- stackoverflow, compute human readable file size
        local suffix = { "b", "k", "M", "G", "T", "P", "E" }
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize
        if fsize <= 0 then
            return "0" .. suffix[1]
        end
        local i = math.floor((math.log(fsize) / math.log(1024)))
        return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
    end,
}

local FileLastModified = {
    provider = function()
        local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
        return (ftime > 0) and os.date("%c", ftime)
    end,
}

local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
}

local ScrollBar = {
    static = {
        -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
        return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "blue", bg = "bright_bg" },
}

local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach", "WinEnter" },
    provider = icons.lsp .. "LSP",
    -- provider  = function(self)
    --     local names = {}
    --     for i, server in pairs(vim.lsp.buf_get_active_clients({ bufnr = 0 })) do
    --         table.insert(names, server.name)
    --     end
    --     return " [" .. table.concat(names, " ") .. "]"
    -- end,
    hl = { fg = "green", bold = true },
    on_click = {
        name = "heirline_LSP",
        callback = function()
            vim.schedule(function()
                vim.cmd("LspInfo")
            end)
        end,
    },
}

local Navic = {
    condition = function()
        return require("nvim-navic").is_available()
    end,
    static = {
        type_hl = {
            File = dim(utils.get_highlight("Directory").fg, 0.75),
            Module = dim(utils.get_highlight("@module").fg, 0.75),
            Namespace = dim(utils.get_highlight("@module").fg, 0.75),
            Package = dim(utils.get_highlight("@module").fg, 0.75),
            Class = dim(utils.get_highlight("@type").fg, 0.75),
            Method = dim(utils.get_highlight("@function.method").fg, 0.75),
            Property = dim(utils.get_highlight("@property").fg, 0.75),
            Field = dim(utils.get_highlight("@variable.member").fg, 0.75),
            Constructor = dim(utils.get_highlight("@constructor").fg, 0.75),
            Enum = dim(utils.get_highlight("@type").fg, 0.75),
            Interface = dim(utils.get_highlight("@type").fg, 0.75),
            Function = dim(utils.get_highlight("@function").fg, 0.75),
            Variable = dim(utils.get_highlight("@variable").fg, 0.75),
            Constant = dim(utils.get_highlight("@constant").fg, 0.75),
            String = dim(utils.get_highlight("@string").fg, 0.75),
            Number = dim(utils.get_highlight("@number").fg, 0.75),
            Boolean = dim(utils.get_highlight("@boolean").fg, 0.75),
            Array = dim(utils.get_highlight("@variable.member").fg, 0.75),
            Object = dim(utils.get_highlight("@type").fg, 0.75),
            Key = dim(utils.get_highlight("@keyword").fg, 0.75),
            Null = dim(utils.get_highlight("@comment").fg, 0.75),
            EnumMember = dim(utils.get_highlight("@constant").fg, 0.75),
            Struct = dim(utils.get_highlight("@type").fg, 0.75),
            Event = dim(utils.get_highlight("@type").fg, 0.75),
            Operator = dim(utils.get_highlight("@operator").fg, 0.75),
            TypeParameter = dim(utils.get_highlight("@type").fg, 0.75),
        },
        -- line: 16 bit (65536); col: 10 bit (1024); winnr: 6 bit (64)
        -- local encdec = function(a,b,c) return dec(enc(a,b,c)) end; vim.pretty_print(encdec(2^16 - 1, 2^10 - 1, 2^6 - 1))
        enc = function(line, col, winnr)
            return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        dec = function(c)
            local line = bit.rshift(c, 16)
            local col = bit.band(bit.rshift(c, 6), 1023)
            local winnr = bit.band(c, 63)
            return line, col, winnr
        end,
    },
    init = function(self)
        local data = require("nvim-navic").get_data() or {}
        local children = {}
        for i, d in ipairs(data) do
            local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
            local child = {
                {
                    provider = d.icon,
                    hl = { fg = self.type_hl[d.type] },
                },
                {
                    provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                    hl = { fg = self.type_hl[d.type] },
                    -- hl = self.type_hl[d.type],
                    on_click = {
                        callback = function(_, minwid)
                            local line, col, winnr = self.dec(minwid)
                            vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                        end,
                        minwid = pos,
                        name = "heirline_navic",
                    },
                },
            }
            if i < #data then
                table.insert(child, {
                    provider = " → ",
                    hl = { fg = "bright_fg" },
                })
            end
            table.insert(children, child)
        end
        self[1] = self:new(children, 1)
    end,
    update = "CursorMoved",
    hl = { fg = "gray" },
}

local Diagnostics = {
    condition = conditions.has_diagnostics,
    update = { "DiagnosticChanged", "BufEnter" },
    on_click = {
        callback = function()
            require("trouble").toggle({ mode = "document_diagnostics" })
        end,
        name = "heirline_diagnostics",
    },
    init = function(self)
        self.diagnostics = vim.diagnostic.count()
    end,
    {
        provider = function(self)
            return self.diagnostics[1] and (icons.err .. self.diagnostics[1] .. " ")
        end,
        hl = "DiagnosticError",
    },
    {
        provider = function(self)
            return self.diagnostics[2] and (icons.warn .. self.diagnostics[2] .. " ")
        end,
        hl = "DiagnosticWarn",
    },
    {
        provider = function(self)
            return self.diagnostics[3] and (icons.info .. self.diagnostics[3] .. " ")
        end,
        hl = "DiagnosticInfo",
    },
    {
        provider = function(self)
            return self.diagnostics[4] and (icons.hint .. self.diagnostics[4] .. " ")
        end,
        hl = "DiagnosticHint",
    },
}

local Git = {
    condition = conditions.is_git_repo,
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    on_click = {
        callback = function(self, minwid, nclicks, button)
            vim.defer_fn(function()
                vim.cmd("Lazygit %:p:h")
            end, 100)
        end,
        name = "heirline_git",
        update = false,
    },
    hl = { fg = "orange" },
    {
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "(",
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        hl = "diffAdded",
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        hl = "diffDeleted",
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = "diffChanged",
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local Snippets = {
    condition = function()
        return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
    end,
    provider = function()
        local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and " " or ""
        local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
        return backward .. forward
    end,
    hl = { fg = "red", bold = true },
}

local DAPMessages = {
    condition = function()
        local session = require("dap").session()
        return session ~= nil
    end,
    provider = function()
        return icons.debug .. require("dap").status() .. " "
    end,
    hl = "Debug",
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_into()
            end,
            name = "heirline_dap_step_into",
        },
    },
    { provider = " " },
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_out()
            end,
            name = "heirline_dap_step_out",
        },
    },
    { provider = " " },
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_over()
            end,
            name = "heirline_dap_step_over",
        },
    },
    { provider = " " },
    {
        provider = " ",
        hl = { fg = "green" },
        on_click = {
            callback = function()
                require("dap").run_last()
            end,
            name = "heirline_dap_run_last",
        },
    },
    { provider = " " },
    {
        provider = " ",
        hl = { fg = "red" },
        on_click = {
            callback = function()
                require("dap").terminate()
                require("dapui").close({})
            end,
            name = "heirline_dap_close",
        },
    },
    { provider = " " },
    --       ﰇ  
}

local WorkDir = {
    init = function(self)
        self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. icons.dir
        local cwd = vim.fn.getcwd(0)
        self.cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#self.cwd, 0.27) then
            self.cwd = vim.fn.pathshorten(self.cwd)
        end
    end,
    hl = { fg = "blue", bold = true },
    on_click = {
        callback = function()
            vim.cmd("Neotree toggle")
        end,
        name = "heirline_workdir",
    },
    flexible = 1,
    {
        provider = function(self)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. self.cwd .. trail .. " "
        end,
    },
    {
        provider = function(self)
            local cwd = vim.fn.pathshorten(self.cwd)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. cwd .. trail .. " "
        end,
    },
    {
        provider = "",
    },
}

local HelpFilename = {
    condition = function()
        return vim.bo.filetype == "help"
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = "Directory",
}

local TerminalName = {
    -- icon = ' ', -- 
    {
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return " " .. tname
        end,
        hl = { fg = "blue", bold = true },
    },
    { provider = " - " },
    {
        provider = function()
            return vim.b.term_title
        end,
    },
    {
        provider = function()
            local id = require("terminal"):current_term_index()
            return " " .. (id or "Exited")
        end,
        hl = { bold = true, fg = "blue" },
    },
}

local Spell = {
    condition = function()
        return vim.wo.spell
    end,
    provider = function()
        return "󰓆 " .. vim.o.spelllang .. " "
    end,
    hl = { bold = true, fg = "green" },
}

local SearchCount = {
    condition = function()
        return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    provider = function(self)
        local search = self.search
        return string.format(" %d/%d", search.current, math.min(search.total, search.maxcount))
    end,
    hl = { fg = "purple", bold = true },
}

local MacroRec = {
    condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
    end,
    provider = " ",
    hl = { fg = "orange", bold = true },
    utils.surround({ "[", "]" }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
        hl = { fg = "green", bold = true },
    }),
    update = {
        "RecordingEnter",
        "RecordingLeave",
    },
    { provider = " " },
}

-- WIP
local VisualRange = {
    condition = function()
        return vim.tbl_containsvim({ "V", "v" }, vim.fn.mode())
    end,
    provider = function()
        local start = vim.fn.getpos("'<")
        local stop = vim.fn.getpos("'>")
    end,
}

local ShowCmd = {
    condition = function()
        return vim.o.cmdheight == 0
    end,
    provider = ":%3.5(%S%)",
    hl = function(self)
        return { bold = true, fg = self:mode_color() }
    end,
}

-- local VirtualEnv = {
--     init = function(self)
--         if not self.timer then
--             self.timer = vim.loop.new_timer()
--             self.timer:start(0, 5000, function()
--                 vim.schedule_wrap(function()
--                     local path = vim.fn.split(vim.fn.system("which python"), "/")
--                     vim.notify(path)
--                     self.pythonpath = path[#path - 2]
--                 end)
--             end)
--         end
--     end,
--     provider = function(self)
--         return self.pythonpath
--     end,
-- }

local Align = { provider = "%=" }
local Space = { provider = " " }

ViMode = utils.surround({ "", "" }, "bright_bg", { MacroRec, ViMode, Snippets, ShowCmd })

local DefaultStatusline = {
    ViMode,
    Space,
    Spell,
    WorkDir,
    FileNameBlock,
    { provider = "%<" },
    Space,
    Git,
    Space,
    Diagnostics,
    Align,
    -- { flexible = 3,   { Navic, Space }, { provider = "" } },
    Align,
    DAPMessages,
    LSPActive,
    -- VirtualEnv,
    Space,
    FileType,
    { flexible = 3, { FileEncoding, Space }, { provider = "" } },
    Space,
    Ruler,
    SearchCount,
    Space,
    ScrollBar,
}

local InactiveStatusline = {
    condition = conditions.is_not_active,
    { hl = { fg = "gray", force = true }, WorkDir },
    FileNameBlock,
    { provider = "%<" },
    Align,
}

local SpecialStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
        })
    end,
    FileType,
    { provider = "%q" },
    Space,
    HelpFilename,
    Align,
}

local GitStatusline = {
    condition = function()
        return conditions.buffer_matches({
            filetype = { "^git.*", "fugitive" },
        })
    end,
    FileType,
    Space,
    {
        provider = function()
            return vim.fn.FugitiveStatusline()
        end,
    },
    Space,
    Align,
}

local TerminalStatusline = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    hl = { bg = "dark_red" },
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
}

local StatusLines = {
    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
    end,
    static = {
        mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "green",
        },
        mode_color = function(self)
            local mode = conditions.is_active() and vim.fn.mode() or "n"
            return self.mode_colors[mode]
        end,
    },
    fallthrough = false,
    -- GitStatusline,
    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
}

local CloseButton = {
    condition = function(self)
        return not vim.bo.modified
    end,
    update = { "WinNew", "WinClosed", "BufEnter" },
    { provider = " " },
    {
        provider = icons.close,
        hl = { fg = "gray" },
        on_click = {
            callback = function(_, minwid)
                vim.api.nvim_win_close(minwid, true)
            end,
            minwid = function()
                return vim.api.nvim_get_current_win()
            end,
            name = "heirline_winbar_close_button",
        },
    },
}

local WinBar = {
    fallthrough = false,
    -- {
    --     condition = function()
    --         return conditions.buffer_matches({
    --             buftype = { "nofile", "prompt", "help", "quickfix" },
    --             filetype = { "^git.*", "fugitive" },
    --         })
    --     end,
    --     init = function()
    --         vim.opt_local.winbar = nil
    --     end,
    -- },
    {
        condition = function()
            return conditions.buffer_matches({ buftype = { "terminal" } })
        end,
        utils.surround({ "", "" }, "dark_red", {
            FileType,
            Space,
            TerminalName,
            CloseButton,
        }),
    },
    utils.surround({ "", "" }, "bright_bg", {
        fallthrough = false,
        {
            condition = conditions.is_not_active,
            {
                hl = { fg = "bright_fg", force = true },
                FileNameBlock,
            },
            CloseButton,
        },
        {
            -- provider = "      ",
            Navic,
            { provider = "%<" },
            Align,
            FileNameBlock,
            CloseButton,
        },
    }),
}

return { statusline = StatusLines, winbar = WinBar }
