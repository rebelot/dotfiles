local dap = require("dap")
local dapui = require("dapui")
local map = vim.keymap.set
local fn = vim.fn
-- require('dap.ext.vscode').load_launchjs()

fn.sign_define(
    "DapBreakpoint",
    { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" }
)
fn.sign_define(
    "DapBreakpointCondition",
    { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "debugBreakpoint" }
)
fn.sign_define(
    "DapBreakpointRejected",
    { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "debugBreakpoint" }
)
fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" })
fn.sign_define("DapStopped", { text = "", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "Error" })

-- mappings
map("n", "<leader>dC", require("dap").continue, { desc = "DAP: Continue" })
map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
map("n", "<leader>dB", function()
    require("dap").set_breakpoint(fn.input("Breakpoint condition: "))
end, { desc = "DAP: Set breakpoint" })
map("n", "<leader>do", require("dap").step_over, { desc = "DAP: Step over" })
map("n", "<leader>dO", require("dap").step_out, { desc = "DAP: Step out" })
map("n", "<leader>dn", require("dap").step_into, { desc = "DAP: Step into" })
map("n", "<leader>dN", require("dap").step_back, { desc = "DAP: Step back" })
map("n", "<leader>dr", require("dap").repl.toggle, { desc = "DAP: Toggle REPL" })
map("n", "<leader>d.", require("dap").goto_, { desc = "DAP: Go to" })
map("n", "<leader>dh", require("dap").run_to_cursor, { desc = "DAP: Run to cursor" })
map("n", "<leader>de", require("dap").set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })
map("n", "<leader>dv", require("telescope").extensions.dap.variables, { desc = "DAP-Telescope: Variables" })
map("n", "<leader>dc", require("telescope").extensions.dap.commands, { desc = "DAP-Telescope: Commands" })
map("n", "<leader>dx", require("dapui").eval, { desc = "DAP-UI: Eval" })
map("n", "<leader>dX", function()
    dapui.eval(fn.input("expression: "))
end, { desc = "DAP-UI: Eval expression" })

dap.listeners.after["event_initialized"]["dapui"] = function()
    dapui.open()
end
dap.listeners.after["event_terminated"]["dapui"] = function()
    dapui.close()
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
        return fn.input("Host [127.0.0.1]: ", "127.0.0.1")
    end,
    port = function()
        return tonumber(fn.input("Port [5678]: ", "5678"))
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
        path = fn.input("Python path: ", path or "", "file")
        return path ~= "" and fn.expand(path) or nil
    end,
    args = function()
        local args = {}
        local i = 1
        while true do
            local arg = fn.input("Argument [" .. i .. "]: ")
            if arg == "" then
                break
            end
            args[i] = arg
            i = i + 1
        end
        return args
    end,
    justMyCode = function()
        return fn.input("justMyCode? [y/n]: ") == "y"
    end,
    stopOnEntry = function()
        return fn.input("stopOnEntry? [y/n]: ") == "y"
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
            return fn.input("Path to executable: ", fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        terminal = "integrated",
        args = function()
            local args = {}
            local i = 1
            while true do
                local arg = fn.input("Argument [" .. i .. "]: ")
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
            return fn.input("Path to executable: ", fn.getcwd() .. "/", "file")
        end,
        waitFor = true,
    },
}

dap.configurations.c = dap.configurations.cpp

return M
