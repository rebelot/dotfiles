local lspconfig = require 'lspconfig'
local vim = vim

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
        silent = true,
        max_height = '10',
        border = 'rounded'
    })

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded'
    })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }

capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)()
        }
    }
}

vim.lsp.util.close_preview_autocmd = function(events, winnr)
    events = vim.tbl_filter(function(v)
        return v ~= 'CursorMovedI' and v ~= 'BufLeave'
    end, events)
    vim.api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_win_close, "..winnr..", true)")
end

-- lsp-status
require'lsp-status'.register_progress()
capabilities.textDocument.completion.completionItem.workDoneProgress = true
capabilities.window.workDoneProgress = true

local M = {}

function M.echo_cursor_diagnostic()
    local severity_hl = {
        'DiagnosticError', 'DiagnosticSignWarn', 'DiagnosticInfo',
        'DiagnosticHint'
    }
    local severity_prefix = {"[Error]", "[Warning]", "[Info]", "[Hint]"}
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

    if vim.tbl_isempty(line_diagnostics) then return end

    local message = {}
    for i, diagnostic in ipairs(line_diagnostics) do
        local diag_col = diagnostic.col
        local diag_end_col = diagnostic.end_col
        if diag_col <= col and col <= diag_end_col then
            local source = diagnostic.source or ''
            local severity = severity_prefix[diagnostic.severity] .. " "
            local msg = source .. ': ' .. diagnostic.message:gsub("\n", "")
            local avail_space = vim.v.echospace - (#severity + #msg)
            table.insert(message, {severity, severity_hl[diagnostic.severity]})
            table.insert(message, {msg:gsub(1, avail_space), 'Normal'})
            vim.api.nvim_echo(message, false, {})
        end
    end
end

-- local function preview_location_callback(err, result, ctx)
--     if result == nil or vim.tbl_isempty(result) then
--         -- print('No location found')
--         return nil
--     end
--     -- print(vim.inspect(result))
--     if vim.tbl_islist(result) then
--         vim.lsp.util.preview_location(result[1])
--     else
--         vim.lsp.util.preview_location(result)
--     end
-- end
--
-- function M.peek_definition()
--     local params = vim.lsp.util.make_position_params()
--     return vim.lsp.buf_request(0, 'textDocument/definition', params,
--                                preview_location_callback)
-- end

-- function code_action_listener()
--     local context = {
--         diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
--     }
--     local params = vim.lsp.util.make_range_params()
--     params.context = context
--     vim.lsp.buf_request(0, 'textDocument/codeAction', params,
--                         function(err, _, result) print(vim.inspect(result)) end)
-- end


local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    require"lsp-status".on_attach(client)
    -- mappings
    local opts = {
        noremap = true,
        silent = true
    }
    -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('x', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    -- buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
    buf_set_keymap('n', '<C-w>d',
                   '<Cmd>split <bar> Telescope lsp_definitions<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
    buf_set_keymap('n', '<leader>lt',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>li', '<cmd>Telescope lsp_implementations<CR>',
                   opts)
    buf_set_keymap('n', '<leader>la', '<cmd>Telescope lsp_code_actions<CR>',
                   opts)
    buf_set_keymap('x', '<leader>la',
                   '<cmd>Telescope lsp_range_code_actions<CR>', opts)
    buf_set_keymap('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>',
                   opts)
    buf_set_keymap('n', '<leader>lS',
                   '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
    buf_set_keymap('n', '<leader>lw',
                   '<cmd>lua print(table.concat(vim.lsp.buf.list_workspace_folders(), "; "))<CR>',
                   opts)
    buf_set_keymap('n', '<leader>lW',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ld',
                   '<cmd>lua vim.diagnostic.open_float(nil, {scope ="line", border = "rounded"})<CR>',
                   opts)
    buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>',
                   opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                   opts)
    buf_set_keymap('n', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                   opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                   opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                   opts)
    -- buf_set_keymap('n', '<leader>lg', '<cmd>lua peek_definition()<CR>', opts) -- treesitter does it better atm

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf",
                       "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>", opts)
        vim.cmd [[command! -buffer LspFormat lua vim.lsp.buf.formatting_seq_sync()]]
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("x", "<leader>lf",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        vim.cmd [[command! -buffer -range LspRangeFormat lua vim.lsp.buf.range_formatting()]]
    end

    vim.api.nvim_exec([[
    augroup lsp_echo_diagnostics
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua require'lsp-config'.echo_cursor_diagnostic()
    "autocmd CursorHold <buffer> lua vim.diagnostic.open_float(nil, {scope = "cursor", border = "rounded", focusable = false})
    autocmd CursorMoved <buffer> echo ""
    augroup END
    ]], false)

    if client.resolved_capabilities.signature_help then
        vim.api.nvim_exec([[
    augroup lsp_signature_help
    autocmd! * <buffer>
    "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({focusable = false})
    augroup END
    ]], false)
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    end
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local configs = {
    pyright = {
        flags = {
            allow_incremental_sync = false
        },
        settings = {
            -- pyright = { completeFunctionParens = true },
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    stubsPath = "$HOME/typings"
                }
            }
        }
    },
    bashls = {},
    vimls = {},
    julials = {},
    ccls = {
        cmd = {'ccls'},
        init_options = {
            cache = {
                directory = '/tmp/ccls'
            },
            clang = {
                -- run: clang -print-resource-dir
                resourceDir = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0",
                extraArgs = {
                    -- run: clang -xc++ -fsyntax-only -v /dev/null
                    "-isystem/usr/local/include",
                    "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1",
                    "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0/include",
                    "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
                    "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
                    "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks",
                    "-std=c++17", "-Wall", "-Wextra"
                }
            }
        }
    },
    efm = {
        filetypes = {
            'lua', 'cpp', 'sh', 'bash', 'c', 'markdown', 'pandoc',
            'json', 'python'
        },
        root_dit = lspconfig.util.root_pattern{".git", "."},
        init_options = {
            documentFormatting = true,
            -- documentRangeFormatting = true,
            codeAction = true
        }
    },
    texlab = {
        settings = {
            texlab = {
                build = {
                    args = {
                        "-xelatex", "-verbose", "-file-line-error",
                        "-synctex=1", "-interaction=nonstopmode", "%f"
                    },
                    executable = "latexmk",
                    forwardSearchAfter = true
                },
                chktex = {
                    onOpenAndSave = true
                },
                forwardSearch = {
                    args = {"%l", "%p", "%f"},
                    executable = "/Applications/Skim.app/Contents/SharedSupport/displayline"
                }
            }
        }
    },
    sumneko_lua = {
        cmd = {
            '/Users/laurenzi/usr/src/lua-language-server/bin/macOS/lua-language-server',
            "-E", "/Users/laurenzi/usr/src/lua-language-server/main.lua"
        },
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'use'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false
                }
            }
        }
    },
    jsonls = {
        settings = {
            json = {
                schemas = vim.tbl_extend('force', {
                    {
                        description = "codeLLDB settings",
                        fileMatch = { "launch.json" },
                        name = "launch.json",
                        url = 'https://raw.githubusercontent.com/vadimcn/vscode-lldb/master/package.json'
                    },
                }, require'schemastore'.json.schemas {
                        select = {
                            'package.json',
                            'compile-commands.json'
                        },
                    }
                )
            }
        }
    }
}

for server, config in pairs(configs) do
    config.capabilities = capabilities
    config.on_attach = on_attach
    lspconfig[server].setup(config)
end

function M.change_python_interpreter(path)
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    configs.pyright.settings.python.pythonPath = path
    lspconfig.pyright.setup(configs.pyright)
    vim.cmd('e%')
end

function M.get_python_interpreters(a, l, p)
    local paths = {}
    local is_home_dir = function()
        return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
    end
    local commands = {'find $HOME/venvs -name python', 'which -a python', is_home_dir() and '' or 'find . -name python'}
    for _, cmd in ipairs(commands) do
        local _paths = vim.fn.systemlist(cmd)
        if _paths then
            for _, path in ipairs(_paths) do
                table.insert(paths, path)
            end
        end
    end
    table.sort(paths)
    local res = {}
    for i, path in ipairs(paths) do
        if path ~= paths[i+1] then table.insert(res, path) end
    end
    if a then
        for _, p in ipairs(res) do
            if not string.find(p, a) then
                res = vim.fn.getcompletion(a, 'file')
            end
        end
    end
    return res
end


vim.api.nvim_exec([[
command! -nargs=1 -complete=customlist,PythonInterpreterComplete PythonInterpreter lua require'lsp-config'.change_python_interpreter(<q-args>)

function! PythonInterpreterComplete(A,L,P) abort
  return v:lua.require('lsp-config').get_python_interpreters()
endfunction
]], false)

return M
