local dap = require("dap")

local map = vim.keymap.set
local fn = vim.fn
-- require('dap.ext.vscode').load_launchjs()

fn.sign_define("DapBreakpoint", { text = "", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" })
fn.sign_define(
    "DapBreakpointCondition",
    { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "debugBreakpoint" }
)
fn.sign_define(
    "DapBreakpointRejected",
    { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "debugBreakpoint" }
)
fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "debugBreakpoint" })
fn.sign_define(
    "DapStopped",
    { text = "", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "DiagnosticSignError" }
)

-- mappings
map("n", "<leader>dC", dap.continue, { desc = "DAP: Continue" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
map("n", "<leader>dB", function()
    dap.set_breakpoint(fn.input("Breakpoint condition: "))
end, { desc = "DAP: Set breakpoint" })
map("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
map("n", "<leader>dO", dap.step_out, { desc = "DAP: Step out" })
map("n", "<leader>dn", dap.step_into, { desc = "DAP: Step into" })
map("n", "<leader>dN", dap.step_back, { desc = "DAP: Step back" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
map("n", "<leader>d.", dap.goto_, { desc = "DAP: Go to" })
map("n", "<leader>dh", dap.run_to_cursor, { desc = "DAP: Run to cursor" })
map("n", "<leader>de", dap.set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })

map("n", "<leader>dv", function()
    require("telescope").extensions.dap.variables()
end, { desc = "DAP-Telescope: Variables" })
map("n", "<leader>dc", function()
    require("telescope").extensions.dap.commands()
end, { desc = "DAP-Telescope: Commands" })

map({ "n", "x" }, "<leader>dx", function()
    require("dapui").eval()
end, { desc = "DAP-UI: Eval" })

map("n", "<leader>dX", function()
    require("dapui").eval(fn.input("expression: "), {})
end, { desc = "DAP-UI: Eval expression" })

--

dap.listeners.after.event_initialized["dapui"] = function()
    require("dapui").open({})
    require("nvim-dap-virtual-text").refresh()
end
dap.listeners.after.event_terminated["dapui"] = function()
    require("dapui").close({})
    require("nvim-dap-virtual-text").refresh()
    vim.cmd("silent! bd! \\[dap-repl]")
end
dap.listeners.before.event_exited["dapui"] = function()
    require("dapui").close({})
    require("nvim-dap-virtual-text").refresh()
    vim.cmd("silent! bd! \\[dap-repl]")
end

dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, {
    type = "python",
    request = "attach",
    name = "attach PID",
    processId = "${command:pickProcess}",
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
        for _, server in ipairs(vim.lsp.buf_get_clients()) do
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

dap.adapters.node2 = {
    type = "executable",
    command = "node-debug2-adapter",
    args = {}
}

dap.configurations.typescript = {
        {
            type = "node2",
            name = "node attach",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
        }
    }
dap.configurations.javascript = dap.configurations.typescript

dap.configurations.cpp = {
    {
        name = "Launch (codelldb)",
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
        name = "attach PID (codelldb)",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
    },
    {
        name = "Attach to Name (wait) (codelldb)",
        type = "codelldb",
        request = "attach",
        program = function()
            return fn.input("Path to executable: ", fn.getcwd() .. "/", "file")
        end,
        waitFor = true,
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- `${file}`: Active filename
-- `${fileBasename}`: The current file's basename
-- `${fileBasenameNoExtension}`: The current file's basename without extension
-- `${fileDirname}`: The current file's dirname
-- `${fileExtname}`: The current file's extension
-- `${relativeFile}`: The current file relative to |getcwd()|
-- `${relativeFileDirname}`: The current file's dirname relative to |getcwd()|
-- `${workspaceFolder}`: The current working directory of Neovim
-- `${workspaceFolderBasename}`: The name of the folder opened in Neovim
-- `${command:pickProcess}`: Open dialog to pick process using |vim.ui.select|
