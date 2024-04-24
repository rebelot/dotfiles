return {
    single_file_support = true,
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                -- reportMissingTypeStubs = true,
                -- stubsPath = "$HOME/typings"
            },
        },
    },
}
