local lspconfig = require("lspconfig")

local M = {}

-- function M.addWsFolder()
--     vim.ui.input({
--         prompt = "Add Workspace folder: ",
--         completion = "dir",
--     }, function(input)
--         if input then
--             vim.lsp.buf.add_workspace_folder(input)
--         end
--     end)
-- end

-- function M.removeWsFolder()
--     vim.ui.input({
--         prompt = "Remove Workspace folder: ",
--         completion = "dir",
--     }, function(input)
--         if input then
--             vim.lsp.buf.remove_workspace_folder(input)
--         end
--     end)
-- end


function M.update_settings(client, settings)
    settings = { settings = vim.tbl_deep_extend('force', client.config.settings, settings) }
    client.notify("workspace/didChangeConfiguration", settings)
end



return M
