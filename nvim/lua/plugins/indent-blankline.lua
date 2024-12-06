require("ibl").setup({
    scope = { show_start = false, show_end = false },
    exclude = {
        buftypes = { "terminal", "prompt", "nofile" },
        filetypes = {
            "help",
            "dashboard",
            "Trouble",
            "dap.*",
            "NvimTree",
            "packer",
        },
    },
})
