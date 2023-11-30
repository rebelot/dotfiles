require("ibl").setup({
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
