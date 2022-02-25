local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {}

function M.setup()
    local colors = {
        bright_bg = utils.get_highlight("Folded").bg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag = {
            warn = utils.get_highlight("DiagnosticWarn").fg,
            error = utils.get_highlight("DiagnosticError").fg,
            hint = utils.get_highlight("DiagnosticHint").fg,
            info = utils.get_highlight("DiagnosticInfo").fg,
        },
        git = {
            del = utils.get_highlight("diffDeleted").fg,
            add = utils.get_highlight("diffAdded").fg,
            change = utils.get_highlight("diffChanged").fg,
        },
    }

    local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
            self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
            mode_names = { -- change the strings if yow like it vvvvverbose!
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
            mode_colors = {
                n = colors.red,
                i = colors.green,
                v = colors.cyan,
                V = colors.cyan,
                ["\22"] = colors.cyan, -- this is an actual ^V, type <C-v><C-v> in insert mode
                c = colors.orange,
                s = colors.purple,
                S = colors.purple,
                ["\19"] = colors.purple, -- this is an actual ^S, type <C-v><C-s> in insert mode
                R = colors.orange,
                r = colors.orange,
                ["!"] = colors.red,
                t = colors.red,
            },
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long
        provider = function(self)
            return " %2(" .. self.mode_names[self.mode] .. "%)"
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
            local mode = self.mode:sub(1, 1) -- get only the first mode character
            return { fg = self.mode_colors[mode], style = "bold" }
        end,
    }

    local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
                filename,
                extension,
                { default = true }
            )
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
        end,
        hl = { fg = utils.get_highlight("Directory").fg },

        utils.make_flexible_component(2, {
            provider = function(self)
                return self.lfilename
            end,
        }, {
            provider = function(self)
                return vim.fn.pathshorten(self.lfilename)
            end,
        }),
    }

    local FileFlags = {
        {
            provider = function()
                if vim.bo.modified then
                    return "[+]"
                end
            end,
            hl = { fg = colors.green },
        },
        {
            provider = function()
                if not vim.bo.modifiable or vim.bo.readonly then
                    return ""
                end
            end,
            hl = { fg = colors.orange },
        },
    }

    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                -- use `force` because we need to override the child's hl foreground
                return { fg = colors.cyan, style = "bold", force = true }
            end
        end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        unpack(FileFlags) -- A small optimisation, since their parent does nothing
        -- { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    local FileType = {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg },
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
        -- did you know? Vim is full of functions!
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
            sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        },
        provider = function(self)
            local curr_line = vim.api.nvim_win_get_cursor(0)[1]
            local lines = vim.api.nvim_buf_line_count(0)
            local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
            return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = colors.blue, bg = colors.bright_bg },
    }

    local LSPActive = {
        condition = conditions.lsp_attached,

        -- You can keep it simple,
        provider = " [LSP]",

        -- Or complicate things a bit and get the servers names
        -- provider  = function(self)
        --     local names = {}
        --     for i, server in ipairs(vim.lsp.buf_get_clients(0)) do
        --         table.insert(names, server.name)
        --     end
        --     return " [" .. table.concat(names, " ") .. "]"
        -- end,
        hl = { fg = colors.green, style = "bold" },
    }

    -- local LSPMessages = {
    --     provider = function()
    --         local status = require("lsp-status").status()
    --         if status ~= " " then
    --             return status
    --         end
    --     end,
    --     hl = { fg = colors.gray },
    -- }

    local Gps = {
        condition = require("nvim-gps").is_available,
        provider = require("nvim-gps").get_location,
        hl = { fg = colors.gray },
    }

    local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
            error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
            warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
            info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
            hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        },

        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        -- {
        --     provider = "!(",
        --     hl = { fg = colors.gray, style = "bold" },
        -- },
        {
            provider = function(self)
                return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = { fg = colors.diag.error },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            end,
            hl = { fg = colors.diag.warn },
        },
        {
            provider = function(self)
                return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = { fg = colors.diag.info },
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = colors.diag.hint },
        },
        -- {
        --     provider = ")",
        --     hl = { fg = colors.gray, style = "bold" },
        -- },
    }

    -- DiagBlock = utils.surround({"![", "]"}, nil, DiagBlock)
    -- DiagBlock = {{provider="--"}, DiagBlock, {provider = '--'}}

    local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0
                or self.status_dict.removed ~= 0
                or self.status_dict.changed ~= 0
        end,

        hl = { fg = colors.orange },

        {
            provider = function(self)
                return " " .. self.status_dict.head
            end,
            hl = { style = "bold" },
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
            hl = { fg = colors.git.add },
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("-" .. count)
            end,
            hl = { fg = colors.git.del },
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ("~" .. count)
            end,
            hl = { fg = colors.git.change },
        },
        {
            condition = function(self)
                return self.has_changes
            end,
            provider = ")",
        },
    }

    local Snippets = {
        -- check that we are in insert or select mode
        condition = function()
            return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
        end,
        provider = function()
            local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and "" or ""
            local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
            return backward .. forward
        end,
        hl = { fg = colors.red, syle = "bold" },
    }

    local DAPMessages = {
        condition = function()
            local session = require("dap").session()
            if session then
                local filename = vim.api.nvim_buf_get_name(0)
                if session.config then
                    local progname = session.config.program
                    return filename == progname
                end
            end
            return false
        end,
        provider = function()
            return " " .. require("dap").status()
        end,
        hl = { fg = utils.get_highlight("Debug").fg },
    }

    local UltTest = {
        condition = function()
            return vim.api.nvim_call_function("ultest#is_test_file", {}) ~= 0
        end,
        static = {
            passed_icon = vim.fn.sign_getdefined("test_pass")[1].text,
            failed_icon = vim.fn.sign_getdefined("test_fail")[1].text,
            passed_hl = { fg = utils.get_highlight("UltestPass").fg },
            failed_hl = { fg = utils.get_highlight("UltestFail").fg },
        },
        init = function(self)
            self.status = vim.api.nvim_call_function("ultest#status", {})
        end,
        {
            provider = function(self)
                return self.passed_icon .. self.status.passed .. " "
            end,
            hl = function(self)
                return self.passed_hl
            end,
        },
        {
            provider = function(self)
                return self.failed_icon .. self.status.failed .. " "
            end,
            hl = function(self)
                return self.failed_hl
            end,
        },
        {
            provider = function(self)
                return "of " .. self.status.tests - 1
            end,
        },
    }

    local WorkDir = {
        provider = function(self)
            self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
            local cwd = vim.fn.getcwd(0)
            self.cwd = vim.fn.fnamemodify(cwd, ":~")
        end,
        hl = { fg = colors.blue, style = "bold" },

        utils.make_flexible_component(1, {
            provider = function(self)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return self.icon .. self.cwd .. trail .. " "
            end,
        }, {
            provider = function(self)
                local cwd = vim.fn.pathshorten(self.cwd)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return self.icon .. cwd .. trail .. " "
            end,
        }, {
            provider = "",
        }),
    }

    local HelpFilename = {
        condition = function()
            return vim.bo.filetype == "help"
        end,
        provider = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = { fg = colors.blue },
    }

    local TerminalName = {
        -- condition = function()
        --     return vim.bo.buftype == 'terminal'
        -- end,
        -- icon = ' ', -- 
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return " " .. tname
        end,
        hl = { fg = colors.blue, style = "bold" },
    }

    local Spell = {
        condition = function()
            return vim.wo.spell
        end,
        provider = "SPELL ",
        hl = { style = "bold", fg = colors.orange },
    }

    ViMode = utils.surround({ "", "" }, colors.bright_bg, { ViMode, Snippets })

    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local DefaultStatusline = {
        ViMode,
        Space,
        Spell,
        WorkDir,
        FileNameBlock,
        { provider = "%<" },
        Space,
        Git,
        -- {
        --     static = { name = "culo", toggle = true },
        --     condition = function(self)
        --         return self.toggle
        --     end,
        --     provider = 'culooooo',
        -- },
        Space,
        Diagnostics,
        Align,
        utils.make_flexible_component(3, Gps, { provider = "" }),
        DAPMessages,
        Align,
        LSPActive,
        Space,
        UltTest,
        Space,
        FileType,
        Space,
        Ruler,
        Space,
        ScrollBar,
    }

    local InactiveStatusline = {
        condition = function()
            return not conditions.is_active()
        end,
        { hl = { fg = colors.gray, force = true }, WorkDir },
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
        Space,
        HelpFilename,
        Align,
    }

    local TerminalStatusline = {
        condition = function()
            return conditions.buffer_matches({ buftype = { "terminal" } })
        end,
        hl = { bg = colors.dark_red },
        { condition = conditions.is_active, ViMode, Space },
        FileType,
        Space,
        TerminalName,
        Align,
    }

    local StatusLines = {

        hl = function()
            if conditions.is_active() then
                return {
                    fg = utils.get_highlight("StatusLine").fg,
                    bg = utils.get_highlight("StatusLine").bg,
                }
            else
                return {
                    fg = utils.get_highlight("StatusLineNC").fg,
                    bg = utils.get_highlight("StatusLineNC").bg,
                }
            end
        end,

        init = utils.pick_child_on_condition,

        SpecialStatusline,
        TerminalStatusline,
        InactiveStatusline,
        DefaultStatusline,
    }

    require("heirline").setup(StatusLines)
end

vim.cmd([[
augroup heirline
    autocmd!
    autocmd ColorScheme * lua require'heirline'.reset_highlights(); require'plugins.heirline'.setup()
augroup END
]])

M.setup()
return M
