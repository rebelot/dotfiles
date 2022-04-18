local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

-- client.server_capabilities.executeCommandProvider
local _commands = {
    "pyright.createtypestub",
    "pyright.organizeimports",
    "pyright.addoptionalforparam",
    "python.createTypeStub",
    "python.orderImports",
    "python.addOptionalForParam",
    "python.removeUnusedImport",
    "python.addImport",
    "python.intellicode.completionItemSelected",
    "python.intellicode.loadLanguageServerExtension",
    "pylance.extractMethod",
    "pylance.extractVariable",
    "pylance.dumpFileDebugInfo",
    "pylance.completionAccepted",
    "pylance.executedClientCommand",
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
        cmd = {
            "node",
            vim.fn.expand("~/.vscode/extensions/ms-python.vscode-pylance-*/dist/server.bundle.crack.js", false, true)[1],
            "--stdio",
        },
        filetypes = { "python" },
        root_dir = function(fname)
            local markers = {
                "Pipfile",
                "pyproject.toml",
                "pyrightconfig.json",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
            }
            return lsputil.root_pattern(unpack(markers))(fname)
                or lsputil.find_git_ancestor(fname)
                or lsputil.path.dirname(fname)
        end,
        settings = {
            python = {
                analysis = vim.empty_dict(),
            },
            telemetry = {
                telemetryLevel = "off",
            },
        },
        docs = {
            package_json = vim.fn.expand(
                "$HOME/.vscode/extensions/ms-python.vscode-pylance-*/package.json",
                false,
                true
            )[1],
            description = [[
         https://github.com/microsoft/pyright
         `pyright`, a static type checker and language server for python
         ]]  ,
        },
        -- before_init = function(_, config)
        --     if not config.settings.python then
        --         config.settings.python = {}
        --     end
        --     if not config.settings.python.pythonPath then
        --         config.settings.python.pythonPath = "/Users/laurenzi/venvs/base/bin/python"
        --     end
        -- end,
    },
}

local function get_python_interpreters(a, l, p)
    local paths = {}
    local is_home_dir = function()
        return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
    end
    local commands = {
        "find $HOME/venvs -name python",
        "which -a python",
        is_home_dir() and "" or "find . -name python",
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

local function change_python_interpreter(path)
    local client = lsputil.get_active_client_by_name(0, "pylance")
    client.stop()
    local config = require("lsp.server_configurations.pylance")
    config.settings.python.pythonPath = path
    lspconfig.pylance.setup(config)
    vim.cmd("LspStart pylance")
end

return {
    on_attach = function(client, bufnr)
        client.commands["pylance.extractVariableWithRename"] = function(command, enriched_ctx)
            command.command = "pylance.extractVariable"
            vim.lsp.buf.execute_command(command)
        end

        client.commands["pylance.extractMethodWithRename"] = function(command, enriched_ctx)
            command.command = "pylance.extractMethod"
            vim.lsp.buf.execute_command(command)
        end

        vim.api.nvim_buf_create_user_command(0, "PythonInterpreter", function(cmd)
            change_python_interpreter(cmd.args)
        end, { nargs = 1, complete = get_python_interpreters })

        vim.api.nvim_buf_create_user_command(
            0,
            "PylanceOrganizeImports",
            organize_imports,
            { desc = "Organize Imports" }
        )

        vim.api.nvim_buf_create_user_command(
            0,
            "PylanceExtractVariable",
            extract_variable,
            { range = true, desc = "Extract variable" }
        )

        vim.api.nvim_buf_create_user_command(
            0,
            "PylanceExtractMethod",
            extract_method,
            { range = true, desc = "Extract methdod" }
        )
    end,
    settings = {
        python = {
            analysis = {
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                stubPath = vim.fn.expand("$HOME/typings"),
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs = "information",
                },
            },
        },
    },
}
