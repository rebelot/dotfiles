return {
    flags = {
        allow_incremental_sync = true,
    },
    single_file_support = true,
    settings = {
        -- pyright = { completeFunctionParens = true },
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                -- reportMissingTypeStubs = true,
                -- stubsPath = "$HOME/typings"
            },
        },
    },
}
