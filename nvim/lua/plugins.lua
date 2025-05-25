local disabled_rtp_plugins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    -- "matchit",
    "gzip",
    "tutor",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
}

-- Bootstrap
------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    ----------------
    --  Required  --
    ----------------
    { "nvim-lua/plenary.nvim",     lazy = true },

    { "dstein64/vim-startuptime",  cmd = "StartupTime" },
    { import = 'plugins.blink-cmp' },
    { import = 'plugins.dashboard' },
    { import = 'plugins.debug' },
    { import = 'plugins.editor' },
    { import = 'plugins.lsp' },
    { import = 'plugins.neo-tree' },
    { import = 'plugins.neotest' },
    { import = 'plugins.syntax' },
    { import = 'plugins.ui' },
    { import = 'plugins.debug' },
}, {
    dev = { path = "~/usr/src" },
    performance = { rtp = { disabled_plugins = disabled_rtp_plugins } },
    rocks = {
        hererocks = true,
    },
})

-- vim.opt.rtp:append({
--     "/Users/laurenzi/usr/src/kanagawa.nvim",
--     "/Users/laurenzi/usr/src/heirline.nvim",
--     "/Users/laurenzi/usr/src/terminal.nvim",
-- })
