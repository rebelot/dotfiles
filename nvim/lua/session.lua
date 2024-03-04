vim.opt.sessionoptions =
    { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "terminal", "localoptions" }

local PATH = vim.fn.stdpath("state") .. "/sessions"

local function sesspath(name)
    return PATH .. "/" .. name .. ".vim"
end

local function sessdefaultname()
    return table.concat(vim.split(vim.uv.cwd(), "/", { trimempty = true }), "_")
        .. "_"
        .. os.date("%Y_%m_%d_%H_%M_%S")
end

local function mksess(name)
    vim.uv.fs_mkdir(PATH, 448)
    vim.cmd("mksession! " .. sesspath(name))
end

local function loadsess(name)
    vim.uv.fs_mkdir(PATH, 448)
    local ok, _ = pcall(vim.cmd, "source " .. sesspath(name))
    if not ok then
        vim.notify("Session " .. name .. " not found", vim.log.levels.WARN)
    end
end

local function listsess()
    vim.uv.fs_mkdir(PATH, 448)
    return vim.tbl_map(function(s)
        return s:gsub(".vim", "")
    end, vim.fn.readdir(PATH))
end

local function rmsess(name)
    os.remove(sesspath(name))
end

vim.api.nvim_create_user_command("SessionSave", function(args)
    local name = args.args ~= "" and args.args or sessdefaultname()
    mksess(name)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_user_command("SessionLoad", function(args)
    local name = args.args ~= "" and args.args or "last"
    loadsess(name)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_user_command("SessionRemove", function(args)
    if not args.args then
        vim.notify("Please provide a session name", vim.log.levels.WARN)
        return
    end
    rmsess(args.args)
end, { bang = true, nargs = "?", complete = listsess })

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        mksess("last")
    end,
})
