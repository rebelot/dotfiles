require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },
        }),
        require("neotest-plenary"),
        require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua" },
        }),
    },
})

vim.api.nvim_create_user_command("NTestRun", function(args)
    local fname = args.args ~= "" and vim.fn.expand(args.fargs[1])
    local strategy = args.fargs[2] or "integrated"
    require("neotest").run.run({ fname, strategy = strategy })
end, { nargs = "*" })

vim.api.nvim_create_user_command("NTestOpen", function()
    require("neotest").output.open({ enter = true, short = true })
end, {})

vim.api.nvim_create_user_command("NTestSummary", function()
    require("neotest").summary.toggle()
end, {})
