return {
    settings = {
        texlab = {
            build = {
                args = {
                    "-pdfxe",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "%f",
                },
                executable = "latexmk",
                forwardSearchAfter = true,
                onSave = true,
            },
            chktex = {
                onOpenAndSave = true,
            },
            forwardSearch = {
                args = { "%l", "%p", "%f" },
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            },
        },
    },
}
