local function byte2hex()
    vim.cmd"%! xxd -g 1 -u"
    vim.b.hex_ft = vim.bo.filetype
    vim.opt_local.binary = true
    vim.bo.filetype = "xxd"
end

local function hex2byte()
    vim.cmd"%! xxd -r"
    vim.bo.filetype = vim.b.hex_ft
    vim.opt_local.binary = false
end

vim.api.nvim_create_user_command('HexEdit', byte2hex, {})
vim.api.nvim_create_user_command('Hex2Byte', hex2byte, {})
