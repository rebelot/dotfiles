require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },
        }),
        require("neotest-plenary"),
        require("neotest-rust"),
        require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua", "rust" },
        }),
    },
    consumers = {
        statusline = function(client)
            return {
                statusline = function()
                    local adapters = client:get_adapters()
                    vim.pretty_print(adapters)
                    local statuses = {}
                    local root_id = vim.api.nvim_buf_get_name(0)
                    for _, adapter_id in ipairs(adapters) do
                        local results = client:get_results(adapter_id)
                        vim.pretty_print(results)
                        local tree = client:get_position(root_id, { adapter = adapter_id })
                        if not tree then
                            return
                        end
                        for _, pos in tree:iter() do
                            if pos.type == "test" then
                                local id = pos.id
                                if results[id] then
                                    table.insert(statuses, results[id].status)
                                else
                                    table.insert(statuses, "none")
                                end
                            end
                        end
                    end
                    local status_dict = { total = 0, failed = 0, passed = 0 }
                    for _, s in ipairs(statuses) do
                        if s == "failed" then
                            status_dict.failed = status_dict.failed + 1
                        elseif s == "passed" then
                            status_dict.passed = status_dict.passed + 1
                        elseif s == "none" then
                            status_dict.total = status_dict.total + 1
                        end
                    end
                    status_dict.total = status_dict.total + status_dict.failed + status_dict.passed
                    return status_dict
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
command! NeotestOutput lua require("neotest").output_panel.toggle()
]])
