require("ultest").setup({
    builders = {
        ["python#pytest"] = function(cmd)
            -- The command can start with python command directly or an env manager
            local non_modules = { "python", "pipenv", "poetry" }
            -- Index of the python module to run the test.
            local module_index = 1
            if vim.tbl_contains(non_modules, cmd[1]) then
                module_index = 3
            end
            local module = cmd[module_index]

            -- Remaining elements are arguments to the module
            local args = vim.list_slice(cmd, module_index + 1)
            return {
                dap = {
                    type = "python",
                    request = "launch",
                    module = module,
                    args = args,
                },
            }
        end,
    },
})

vim.cmd('let test#python#runner = "pytest"')
vim.cmd('let test#strategy = "neovim"')
vim.cmd('let test#python#pytest#options = "--color=yes"')
vim.cmd("let g:ultest_use_pty = 1")
vim.api.nvim_set_keymap("n", "<leader>ut", "<cmd>Ultest<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>us", "<cmd>UltestSummary<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ud", "<cmd>UltestDebugNearest<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>uo", "<cmd>UltestOutput<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>un", "<cmd>UltestNearest<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ul", "<cmd>UltestLast<cr>", { noremap = true })
