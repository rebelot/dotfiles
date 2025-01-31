local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local function get_python_interpreters(a, l, p)
    local paths = {}
    local is_home_dir = function()
        return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
    end
    local commands = {
        "find $HOME/venvs -name python",
        "which -a python",
        is_home_dir() and "" or [[find ~+ -name python]],
    }
    for _, cmd in ipairs(commands) do
        local _paths = vim.fn.systemlist(cmd)
        if _paths then
            for _, path in ipairs(_paths) do
                table.insert(paths, path)
            end
        end
    end
    table.sort(paths)
    local res = {}
    for i, path in ipairs(paths) do
        if path ~= paths[i + 1] then
            table.insert(res, path)
        end
    end
    if a then
        for _, p in ipairs(res) do
            if not string.find(p, a) then
                res = vim.fn.getcompletion(a, "file")
            end
        end
    end
    return res
end

local function set_lsp_python_path(path)
    local client = vim.lsp.get_clients({ bufnr = 0, name = "pylance" })[1]
    local config = client.config
    config.settings.python.pythonPath = path
    client.stop({ force = true })
    vim.defer_fn(function()
        vim.lsp.start(config)
    end, 500)
end

local function change_python_interpreter(path)
    local client = lsputil.get_active_client_by_name(0, "pylance")
    -- client.stop()
    local config = require("lsp.servers.pylance")
    config.settings.python.pythonPath = path
    lspconfig.pylance.setup(config)
    vim.cmd("LspRestart pylance")
end

-- client.server_capabilities.executeCommandProvider
local _commands = {
    "pyright.createtypestub",
    "pyright.organizeimports",
    "pyright.dumpFileDebugInfo",
    "python.createTypeStub",
    "python.orderImports",
    "python.addOptionalForParam",
    "python.removeUnusedImport",
    "python.addImport",
    "python.intellicode.completionItemSelected",
    "python.intellicode.loadLanguageServerExtension",
    "pylance.extractMethod",
    "pylance.extractVariable",
    "pylance.completionAccepted",
    "pylance.executedClientCommand",
    "pylance.moveSymbol",
    "pylance.getSour ceFiles",
    "pylance.convertImportFormat",
    "pylance.fixAll",
    "pylance.pytest.addAllFixtureTypeAnnotations",
    "pylance.pytest.addFixtureTypeAnnotation",
    "pylance.indexing.clearPersistedIndices",
}

local function organize_imports()
    local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
    }
    vim.lsp.buf.execute_command(params)
end

local function extract_variable()
    local pos_params = vim.lsp.util.make_given_range_params()
    local params = {
        command = "pylance.extractVariable",
        arguments = {
            vim.api.nvim_buf_get_name(0),
            pos_params.range,
        },
    }
    vim.lsp.buf.execute_command(params)
    -- vim.lsp.buf.rename()
end

local function extract_method()
    local pos_params = vim.lsp.util.make_given_range_params()
    local params = {
        command = "pylance.extractMethod",
        arguments = {
            vim.api.nvim_buf_get_name(0),
            pos_params.range,
        },
    }
    vim.lsp.buf.execute_command(params)
    -- vim.lsp.buf.rename()
end

require("lspconfig.configs").pylance = {
    default_config = {
        name = "pylance",
        autostart = true,
        single_file_support = true,
        cmd = { "delance-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = function(fname)
            local markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
                ".git",
            }
            return vim.fs.root(0, markers)
        end,
        settings = {
            python = {
                analysis = vim.empty_dict(),
            },
        },
        docs = {
            package_json = vim.fn.expand("$HOME/usr/src/pylance_langserver/extension/package.json"),
            description = [[
         https://github.com/microsoft/pyright
         `pyright`, a static type checker and language server for python
         ]],
        },
        before_init = function(_, config)
            -- local venv = os.getenv("VIRTUAL_ENV")
            if not config.settings.python then
                config.settings.python = {}
            end
            if not config.settings.python.pythonPath then
                config.settings.python.pythonPath = "python"
            end
        end,
    },
}

vim.lsp.commands["pylance.extractVariableWithRename"] = function(command, enriched_ctx)
    command.command = "pylance.extractVariable"
    vim.lsp.buf.execute_command(command)
end

vim.lsp.commands["pylance.extractMethodWithRename"] = function(command, enriched_ctx)
    command.command = "pylance.extractMethod"
    vim.lsp.buf.execute_command(command)
end

return {
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "PythonInterpreter", function(args)
            vim.fn.setenv("PATH", (args.args:gsub("/python$", "")) .. ":" .. vim.fn.getenv("PATH"))
            vim.fn.setenv("VIRTUAL_ENV", (args.args:gsub("/bin/python$", "")))
            change_python_interpreter(args.args)
        end, { nargs = 1, complete = get_python_interpreters, desc = "Change python interpreter" })

        vim.api.nvim_buf_create_user_command(
            bufnr,
            "PylanceOrganizeImports",
            organize_imports,
            { desc = "Organize Imports" }
        )

        vim.api.nvim_buf_create_user_command(
            bufnr,
            "PylanceExtractVariable",
            extract_variable,
            { range = true, desc = "Extract variable" }
        )

        vim.api.nvim_buf_create_user_command(
            bufnr,
            "PylanceExtractMethod",
            extract_method,
            { range = true, desc = "Extract methdod" }
        )
    end,
    -- handlers = {
    --     ["textDocument/inlayHint"] = require("lsp.inlay_hints").show_handler,
    -- },
    settings = {
        python = {
            analysis = {
                indexOptions = {
                    regenerateStdLibIndices = true,
                },
                indexing = true,
                packageIndexDepths = {
                    name = "",
                    depth = 4,
                    includeAllSymbols = true,
                },
                persistAllIndices = false,
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                -- autoImportCompletions = false, -- huge pollution
                supportRestructuredText = true,
                enablePytestSupport = true,
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                    callArgumentNames = true,
                    pytestParameters = true,
                },
                autoFormatStrings = true,
                -- diagnosticSeverityOverrides = {
                --     reportMissingTypeStubs = "information",
                -- },
            },
        },
    },
}
