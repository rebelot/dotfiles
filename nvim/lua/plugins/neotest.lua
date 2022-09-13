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
    consumers = {
        statusline = function(client)
            return {
                statusline = function()
                    local adapters = client:get_adapters()
                    local results = {}
                    for _, adapter in ipairs(adapters) do
                        local res = client:get_results(adapter)
                        for key, r in pairs(res) do
                            results[key] = r
                        end
                    end
                    local status = { total = 0, failed = 0, passed = 0}
                    for _, res in pairs(results) do
                        if res.status == 'failed' then
                            status.failed = status.failed + 1
                        elseif res.status == 'passed' then
                            status.passed = status.passed + 1
                        end
                    end
                    vim.pretty_print(status)
                end,
            }
        end,
    },
})

vim.cmd([[
command! NeotestSummary lua require("neotest").summary.toggle()
command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
command! NeotestNearest lua require("neotest").run.run()
command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
command! NeotestAttach lua require("neotest").run.attach()
]])
