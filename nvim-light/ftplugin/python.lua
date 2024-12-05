local root_files = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
}

local function organize_imports()
    local params = {
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(0) },
    }

    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = 'pylance',
    }
    for _, client in ipairs(clients) do
        client.request('workspace/executeCommand', params, nil, 0)
    end
end

local function set_python_path(path)
    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = 'pylance',
    }
    for _, client in ipairs(clients) do
        if client.settings then
            client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
        else
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
        end
        client.notify('workspace/didChangeConfiguration', { settings = nil })
    end
end

vim.lsp.start({
    name = "pylance",
    cmd = { "delance-langserver", "--stdio" },
    root_dir = vim.fs.root(0, root_files),
    single_file_support = true,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
})

vim.api.nvim_buf_create_user_command(0, "PylanceOrganizeImports", organize_imports, { desc = 'Organize Imports', })
vim.api.nvim_buf_create_user_command(0, "PylanceSetPythonPath", set_python_path, {
    desc = 'Reconfigure pyright with the provided python path',
    nargs = 1,
    complete = 'file',
})
