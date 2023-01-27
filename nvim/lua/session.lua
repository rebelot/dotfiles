local PATH = vim.fn.stdpath("state") .. "/sessions"

local function mksess(name)
    vim.loop.fs_mkdir(PATH, 448)
    vim.cmd("mksession! " .. PATH .. "/" .. name .. ".vim")
end

local function loadsess(name)
    vim.loop.fs_mkdir(PATH, 448)
    local ok, _ = pcall(vim.cmd, "source " .. PATH .. "/" .. name .. ".vim")
    if not ok then
        vim.notify("Session " .. name .. " not found", vim.log.levels.WARN)
    end
end

local function listsess()
    vim.loop.fs_mkdir(PATH, 448)
    return vim.tbl_map(function(s)
        return s:gsub(".vim", "")
    end, vim.fn.readdir(PATH))
end

local function rmsess(name)
    os.remove(PATH .. "/" .. name .. ".vim")
end

vim.api.nvim_create_user_command("SessionSave", function(args)
    local name = args.args ~= "" and args.args or "last"
    mksess(name)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_user_command("SessionLoad", function(args)
    local name = args.args ~= "" and args.args or "last"
    loadsess(name)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_user_command("SessionRemove", function(args)
    local name = args.args ~= "" and args.args or "last"
    rmsess(name)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        mksess("last")
    end,
})
