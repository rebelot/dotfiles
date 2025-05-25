return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap-config")
        end,
    },

    {
        "jbyuki/one-small-step-for-vimkind",
        lazy = true,
        ft = "lua",
        config = function()
            local dap = require("dap")
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to running Neovim instance",
                    host = function()
                        local value = vim.fn.input("Host [127.0.0.1]: ")
                        if value ~= "" then
                            return value
                        end
                        return "127.0.0.1"
                    end,
                    port = function()
                        local val = tonumber(vim.fn.input("Port: "))
                        assert(val, "Please provide a port number")
                        return val
                    end,
                },
            }

            dap.adapters.nlua = function(callback, config)
                callback({ type = "server", host = config.host, port = config.port })
            end
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            require("dap-python").setup() --"~/venvs/debugpy/bin/python")
            require("dap-python").test_runner = "pytest"
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        config = true,
        opts = {
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = true,
            show_stop_reason = true,
            commented = false,
            virt_text_pos = "eol",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil,
        },
    },

    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        opts = {
            controls = {
                enabled = true,
                element = "repl",
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "",
                    terminate = "",
                },
            },
        }
    },
}
