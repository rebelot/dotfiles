local term_map = require("terminal.mappings")
require("terminal").setup()

vim.keymap.set({ "n", "x" }, "<leader>ts", term_map.operator_send, { expr = true })
vim.keymap.set("n", "<leader>to", term_map.toggle)
vim.keymap.set("n", "<leader>tO", term_map.toggle({ open_cmd = "enew" }))
vim.keymap.set("n", "<leader>tr", term_map.run)
vim.keymap.set("n", "<leader>tR", term_map.run(nil, { layout = { open_cmd = "enew" } }))
vim.keymap.set("n", "<leader>tk", term_map.kill)
vim.keymap.set("n", "<leader>t]", term_map.cycle_next)
vim.keymap.set("n", "<leader>t[", term_map.cycle_prev)
local ipython = require("terminal").terminal:new({
    layout = { open_cmd = "botright vertical new" },
    cmd = { "ipython" },
    autoclose = true,
})
local htop = require("terminal").terminal:new({
    layout = { open_cmd = "float" },
    cmd = { "htop" },
    autoclose = true,
})
local lazygit = require("terminal").terminal:new({
    layout = { open_cmd = "float", height = 0.9, width = 0.9 },
    cmd = { "lazygit" },
    autoclose = true,
})
vim.env["GIT_EDITOR"] = "nvr -cc close -cc split --remote-wait +'set bufhidden=wipe'"

vim.api.nvim_create_user_command("IPython", function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype == "python" then
        vim.keymap.set("x", "<leader>ts", function()
            vim.api.nvim_feedkeys('"+y', "n", false)
            ipython:send("%paste")
        end, { buffer = bufnr })
        vim.keymap.set("n", "<leader>t?", function()
            require("terminal").send(vim.v.count, vim.fn.expand("<cexpr>") .. "?")
        end, { buffer = bufnr })
    end
    ipython:toggle(nil, true)
end, {})

vim.api.nvim_create_user_command("Lazygit", function(args)
    lazygit.cwd = args.args and vim.fn.expand(args.args)
    lazygit:toggle(nil, true)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Htop", function()
    htop:toggle(nil, true)
end, { nargs = "?" })
