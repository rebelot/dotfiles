---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

local function get_python_interpreters(a, l, p)
    local paths = {}
    local is_home_dir = function()
        return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
    end
    local commands = {
        is_home_dir() and "" or [[find ~+ -name python]],
        "echo ${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/python}",
        "find $HOME/venvs -name python",
        "which -a python",
    }
    for _, cmd in ipairs(commands) do
        vim.list_extend(paths, vim.fn.systemlist(cmd))
    end
    local res = {}
    local hash = {}
    for _, v in ipairs(paths) do
        if not hash[v] then
            res[#res + 1] = v
            hash[v] = true
        end
    end
    if a ~= "" then
        local sub = vim.fn.matchfuzzy(res, a)
        if vim.tbl_isempty(sub) then
            return vim.fn.getcompletion(a, "file")
        end
        return sub
    end
    return res
end

local function change_python_interpreter(path)
    vim.g.PythonPath = path

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0, name = "basedpyright" })) do
        local config = client.config
        client:stop(true)
        vim.defer_fn(function()
            vim.lsp.start(config)
        end, 500)
    end
end

return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                supportRestructuredText = true,
                enablePytestSupport = true,
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                    callArgumentNames = true,
                    pytestParameters = true,
                },
                autoFormatStrings = true,
            },
        },
    },
    before_init = function(_, config)
        local venv = os.getenv("VIRTUAL_ENV")
        if not config.settings.python then
            config.settings.python = {}
        end
        config.settings.python.pythonPath = vim.g.PythonPath
            or (venv and venv .. "/bin/python")
            or vim.g.python3_host_prog
        vim.notify("pythonPath: " .. config.settings.python.pythonPath)
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
            client:exec_cmd({
                command = "basedpyright.organizeimports",
                arguments = { vim.uri_from_bufnr(bufnr) },
            })
        end, {
            desc = "Organize Imports",
        })

        vim.api.nvim_buf_create_user_command(bufnr, "PythonInterpreter", function(args)
            vim.fn.setenv("PATH", (args.args:gsub("/python$", "")) .. ":" .. vim.fn.getenv("PATH"))
            vim.fn.setenv("VIRTUAL_ENV", (args.args:gsub("/bin/python$", "")))
            change_python_interpreter(args.args)
            -- set_lsp_python_path(args.args)
        end, { nargs = 1, complete = get_python_interpreters, desc = "Change python interpreter" })
    end,
}
