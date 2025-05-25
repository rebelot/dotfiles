return {
    "rcarriga/neotest",
    cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/neotest-python",
        "rcarriga/neotest-vim-test",
        "rcarriga/neotest-plenary",
        "rouge8/neotest-rust",
        "vim-test/vim-test",
    },
    config = function()
        vim.cmd([[
command! NeotestSummary lua require("neotest").summary.toggle()
command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
command! NeotestNearest lua require("neotest").run.run()
command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
command! NeotestAttach lua require("neotest").run.attach()
command! NeotestOutput lua require("neotest").output_panel.toggle()
]])
    end,
    opts = function()
        return {
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
                require("neotest-plenary"),
                -- require("neotest-rust"),
                require("rustaceanvim.neotest"),
                require("neotest-vim-test")({
                    ignore_file_types = { "python", "vim", "lua", "rust" },
                }),
            },
        }
    end
}
