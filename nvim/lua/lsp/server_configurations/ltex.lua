return {
    settings = {
        ltex = {
            completionEnabled = true,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "it",
            },
            ["ltex-ls"] = {
                path = vim.fn.expand('$HOME/usr/src/ltex-ls/lib/ltex-ls-15.2.0'),
            },
        },
    },
}
