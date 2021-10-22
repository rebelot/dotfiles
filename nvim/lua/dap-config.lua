local dap = require'dap'
-- require('dap.ext.vscode').load_launchjs()

vim.fn.sign_define('DapBreakpoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text=' ', texthl='DiagnosticWarn', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text=' ', texthl='DiagnosticError', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='debugBreakpoint', linehl='debugPC', numhl=''})

vim.cmd [[au FileType dap-repl lua require('dap.ext.autocompl').attach()]]

local M = {}
function M.DapEditConfig()
    if vim.fn.filereadable('nvim-dap_launch.json') == 1 then
        vim.cmd('vsplit nvim-dap_launch.json')
        return
    end
    local buf = vim.api.nvim_create_buf(true, false)
    vim.bo[buf].filetype = 'json'
    vim.api.nvim_buf_set_name(buf, 'nvim-dap_launch.json')
    local lines = {
        '{',
        '   "version": "0.2.0",',
        '   "configurations": [',
        '       {',
        '           "type": "type",',
        '           "request": "launch",',
        '           "name": "Debug",',
        '           "program": "executable name"',
        '       }',
        '   ]',
        '}'
    }
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)

    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.cmd [[au BufWritePost <buffer> lua require'dap.ext.vscode'.load_launchjs('nvim-dap_launch.json')]]
end

vim.cmd [[command! DapEditConfig lua require'dap-config'.DapEditConfig()]]
vim.cmd [[command! DapReloadConfig lua require'dap'.configurations = {}; vim.cmd("luafile ~/.config/nvim/lua/dap-config.lua"); require'dap.ext.vscode'.load_launchjs('nvim-dap_launch.json')]]
vim.cmd [[command! DapClose lua require'dapui'.close(); vim.cmd("bd! \\[dap-repl]") ]]

-- mappings
local map_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>dC', '<cmd>lua require"dap".continue()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dn', '<cmd>lua require"dap".step_into()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dN', '<cmd>lua require"dap".step_back()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', map_opts)
-- vim.api.nvim_set_keymap('n', '<leader>di', '<cmd>lua require"dap.ui.widgets".hover()<CR>', map_opts)
-- vim.api.nvim_set_keymap('x', '<leader>di', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', map_opts)
-- vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>lua require"dap-config".DapSidebarToggle()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>d.', '<cmd>lua require"dap".goto_()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dh', '<cmd>lua require"dap".run_to_cursor()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>de', '<cmd>lua require"dap".set_exception_breakpoints()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dv', '<cmd>Telescope dap variables<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dc', '<cmd>Telescope dap commands<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dx', '<cmd>lua require"dapui".eval()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dX', '<cmd>lua require"dapui".eval(vim.fn.input("expression: "))<CR>', map_opts)
vim.api.nvim_set_keymap('x', '<leader>dx', '<cmd>lua require"dapui".eval()<CR>', map_opts)

dap.listeners.after['event_initialized']['dapui'] = function()
    require'dapui'.open()
end
dap.listeners.after['event_terminated']['dapui'] = function()
    require'dapui'.close()
    vim.cmd("bd! \\[dap-repl]")
end

dap.listeners.after['event_disassemble']['test'] = function(session, err, response, payload)
    print(vim.inspect(response))
end

dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, {
    type = 'python';
    request = 'attach';
    name = 'attach PID';
    processId = require'dap.utils'.pick_process
})
table.insert(dap.configurations.python, {
    type = 'python';
    request = 'launch';
    name = 'launch args';
    program = '${workspaceFolder}/${file}';
    args = function()
        local args = vim.fn.input('args (split with @@): ')
        local argl = vim.fn.split(args, [[\s*@@\s*}]])
        return argl
    end;
    console = 'integratedTerminal'
})
-- dap.adapters.lldb = {
--   type = 'executable',
--   command = "lldb-vscode-mp-12",
--   name = "lldb"
-- }
dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000
}
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    runInTerminal = true,
    terminal = 'integrated',
    args = {},
  },
  {
    name = "attach PID",
    type = "codelldb",
    request = "attach",
    pid = require('dap.utils').pick_process,
  },
  {
    name = "Attach to Name (wait)",
    type = "codelldb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    waitFor = true
  }
}

dap.configurations.c = dap.configurations.cpp

return M
