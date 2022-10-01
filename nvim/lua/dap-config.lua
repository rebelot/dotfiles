local dap = require("dap")
-- require('dap.ext.vscode').load_launchjs()

vim.fn.sign_define(
    "DapBreakpoint",
    { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "debugBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "debugBreakpoint" }
)
vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "Error" })

-- mappings
vim.keymap.set("n", "<leader>dC", require("dap").continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
vim.keymap.set("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Set breakpoint" })
vim.keymap.set("n", "<leader>do", require("dap").step_over, { desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>dO", require("dap").step_out, { desc = "DAP: Step out" })
vim.keymap.set("n", "<leader>dn", require("dap").step_into, { desc = "DAP: Step into" })
vim.keymap.set("n", "<leader>dN", require("dap").step_back, { desc = "DAP: Step back" })
vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle, { desc = "DAP: Toggle REPL" })
vim.keymap.set("n", "<leader>d.", require("dap").goto_, { desc = "DAP: Go to" })
vim.keymap.set("n", "<leader>dh", require("dap").run_to_cursor, { desc = "DAP: Run to cursor" })
vim.keymap.set("n", "<leader>de", require("dap").set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })
vim.keymap.set("n", "<leader>dv", require("telescope").extensions.dap.variables, { desc = "DAP-Telescope: Variables" })
vim.keymap.set("n", "<leader>dc", require("telescope").extensions.dap.commands, { desc = "DAP-Telescope: Commands" })
vim.keymap.set("n", "<leader>dx", require("dapui").eval, { desc = "DAP-UI: Eval" })
vim.keymap.set("n", "<leader>dX", function()
    require("dapui").eval(vim.fn.input("expression: "))
end, { desc = "DAP-UI: Eval expression" })

dap.listeners.after["event_initialized"]["dapui"] = function()
    require("dapui").open()
end
dap.listeners.after["event_terminated"]["dapui"] = function()
    require("dapui").close()
    vim.cmd("bd! \\[dap-repl]")
end

dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, {
    type = "python",
    request = "attach",
    name = "attach PID",
    processId = require("dap.utils").pick_process,
    console = "integratedTerminal",
})
table.insert(dap.configurations.python, {
    type = "python",
    request = "attach",
    name = "Attach remote jMC=false",
    host = function()
        return vim.fn.input("Host [127.0.0.1]: ", "127.0.0.1")
    end,
    port = function()
        return tonumber(vim.fn.input("Port [5678]: ", "5678"))
    end,
    justMyCode = false,
    console = "integratedTerminal",
})
table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "launch with options",
    program = "${file}",
    -- python = function() end,
    pythonPath = function()
        local path
        for _, server in pairs(vim.lsp.buf_get_clients()) do
            path = vim.tbl_get(server, "config", "settings", "python", "pythonPath")
            if path then
                break
            end
        end
        path = vim.fn.input("Python path: ", path or "", "file")
        return path ~= "" and vim.fn.expand(path) or nil
    end,
    args = function()
        local args = {}
        local i = 1
        while true do
            local arg = vim.fn.input("Argument [" .. i .. "]: ")
            if arg == "" then
                break
            end
            args[i] = arg
            i = i + 1
        end
        return args
    end,
    justMyCode = function()
        return vim.fn.input("justMyCode? [y/n]: ") == "y"
    end,
    stopOnEntry = function()
        return vim.fn.input("stopOnEntry? [y/n]: ") == "y"
    end,
    console = "integratedTerminal",
})

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        terminal = "integrated",
        args = function()
            local args = {}
            local i = 1
            while true do
                local arg = vim.fn.input("Argument [" .. i .. "]: ")
                if arg == "" then
                    break
                end
                args[i] = arg
                i = i + 1
            end
            return args
        end,
    },
    {
        name = "attach PID",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
    },
    {
        name = "Attach to Name (wait)",
        type = "codelldb",
        request = "attach",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        waitFor = true,
    },
}

dap.configurations.c = dap.configurations.cpp

return M
