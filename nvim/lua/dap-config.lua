local dap = require'dap'
require('dap.ext.vscode').load_launchjs()

vim.fn.sign_define('DapBreakpoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='debugBreakpoint', linehl='debugPC', numhl=''})

vim.cmd [[au FileType dap-repl lua require('dap.ext.autocompl').attach()]]

local function make_dap_sidebar()
    local widgets = require'dap.ui.widgets'
    return widgets.sidebar(widgets.scopes, {width=40}, 'vertical leftabove split')
end

local DapSidebar = nil
local M = {}

function M.DapSidebarToggle()
    if DapSidebar then
        DapSidebar.close()
        DapSidebar = nil
        return
    end
    DapSidebar = make_dap_sidebar()
    DapSidebar.open()
end

vim.api.nvim_set_keymap('n', '<leader>dC', '<cmd>lua require"dap".continue()<CR>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".set_breakpoint("")<left><left>', {noremap = true, silent = false})

dap.listeners.after['event_initialized']['set_keymaps'] = function()
    local bufnr = 0
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    -- mappings
    buf_set_keymap('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>', opts)
    buf_set_keymap('n', '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', opts)
    buf_set_keymap('n', '<leader>dn', '<cmd>lua require"dap".step_into()<CR>', opts)
    buf_set_keymap('n', '<leader>dN', '<cmd>lua require"dap".step_back()<CR>', opts)
    buf_set_keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', opts)
    buf_set_keymap('n', '<leader>di', '<cmd>lua require"dap.ui.widgets".hover()<CR>', opts)
    buf_set_keymap('x', '<leader>di', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', opts)
    buf_set_keymap('n', '<leader>ds', '<cmd>lua require"dap-config".DapSidebarToggle()<CR>', opts)
    buf_set_keymap('n', '<leader>d.', '<cmd>lua require"dap".goto_()<CR>', opts)
    buf_set_keymap('n', '<leader>dh', '<cmd>lua require"dap".run_to_cursor()<CR>', opts)
    buf_set_keymap('n', '<leader>de', '<cmd>lua require"dap".set_exception_breakpoints()<CR>', opts)
    buf_set_keymap('n', '<leader>dv', '<cmd>Telescope dap variables<CR>', opts)
    buf_set_keymap('n', '<leader>dc', '<cmd>Telescope dap commands<CR>', opts)
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

return M
