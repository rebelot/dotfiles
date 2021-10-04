local lspconfig = require 'lspconfig'
local vim = vim

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false, -- , source = 'always'},
        underline = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true
    })

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
        silent = true,
        border = 'single',
        max_height = '10'
    })

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single"
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

-- lsp-status
require'lsp-status'.register_progress()
capabilities.textDocument.completion.completionItem.workDoneProgress = true
capabilities.window.workDoneProgress = true

function echo_diagnostics()
    local error_table_hl = {
        'LspDiagnosticsSignError', 'LspDiagnosticsSignWarning',
        'LspDiagnosticsSignInformation', 'LspDiagnosticsSignHint'
    }
    local error_table_prefix = {"[Error]", "[Warning]", "[Info]", "[Hint]"}
    local line_diagnostics = vim.diagnostic.get(0, {
        lnum = vim.fn.line('.') - 1
    })
    if vim.tbl_isempty(line_diagnostics) then return end
    local message = {}
    local message_len = 0
    for i, diagnostic in ipairs(line_diagnostics) do
        local avail_space = vim.v.echospace - message_len
        -- if [ErrType] could throw off, skip altogether
        if (avail_space < 9) then break end

        local diag = error_table_prefix[diagnostic.severity] .. " "
        local msg = diagnostic.source .. ": " .. diagnostic.message .. " "

        table.insert(message, {diag, error_table_hl[diagnostic.severity]})
        table.insert(message, {msg:sub(0, avail_space - #diag)})

        message_len = message_len + #msg + #diag + 2
    end
    vim.api.nvim_echo(message, false, {})
end

local function preview_location_callback(_, method, result)
    if result == nil or vim.tbl_isempty(result) then
        vim.lsp.log.info(method, 'No location found')
        return nil
    end
    if vim.tbl_islist(result) then
        vim.lsp.util.preview_location(result[1])
    else
        vim.lsp.util.preview_location(result)
    end
end

local function peek_definition()
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, 'textDocument/definition', params,
                               preview_location_callback)
end

function code_action_listener()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, _, result)
        print(vim.inspect(result))
    end
    )
end

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    require"lsp-status".on_attach(client)
    -- mappings
    local opts = { noremap = true, silent = true }
    -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('x', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    -- buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
    buf_set_keymap('n', '<C-w>d', '<Cmd>split <bar> Telescope lsp_definitions<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
    buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>li', '<cmd>Telescope lsp_implementations<CR>', opts)
    buf_set_keymap('n', '<leader>la', '<cmd>Telescope lsp_code_actions<CR>', opts)
    buf_set_keymap('x', '<leader>la', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
    buf_set_keymap('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>', opts)
    buf_set_keymap('n', '<leader>lS', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
    buf_set_keymap('n', '<leader>lw', '<cmd>lua print(table.concat(vim.lsp.buf.list_workspace_folders(), "; "))<CR>', opts)
    buf_set_keymap('n', '<leader>lW', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.show_line_diagnostics({border = "single", source = "always"})<CR>', opts)
    buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<leader>lg', '<cmd>lua peek_definition()<CR>', opts) -- treesitter does it better atm

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>", opts)
        vim.cmd [[command! -buffer LspFormat lua vim.lsp.buf.formatting_seq_sync()]]
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("x", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        vim.cmd [[command! -buffer -range LspRangeFormat lua vim.lsp.buf.range_formatting()]]
    end

    vim.api.nvim_exec([[
    augroup lsp_echo_diagnostics
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua echo_diagnostics()
    autocmd CursorHold <buffer> lua vim.diagnostic.show_position_diagnostics({border = "single", source = "always", focusable = false})
    autocmd CursorMoved <buffer> echo ""
    augroup END
    ]], false)

    if client.resolved_capabilities.signature_help then
        vim.api.nvim_exec([[
    augroup lsp_signature_help
    autocmd! * <buffer>
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({focusable = false})
    augroup END
    ]], false)
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
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
        cmd = {'ccls-clang-11'},
        init_options = {
            cache = {
                directory = '/tmp/ccls'
            },
            clang = {
                resourceDir = "/Library/Developer/CommandLineTools/usr/lib/clang/12.0.5",
                extraArgs = {
                    "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
                    "-isystem/Library/Developer/CommandLineTools/usr/lib/clang/12.0.5/include",
                    "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include",
                    "-isystem/Library/Developer/CommandLineTools/usr/include",
                    "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks",
                    "-std=c++17"
                }
            }
        }
    },
    efm = {
        filetypes = {
            'lua', 'cpp', 'python', 'sh', 'bash', 'tex', 'c', 'markdown',
            'pandoc'
        },
        init_options = {
            documentFormatting = true,
            codeAction = true
        },
        settings = {
            languages = {
                python = {
                    {
                        formatCommand = 'black --quiet -',
                        formatStdin = true
                    }, {
                        lintCommand = "flake8 --max-line-length 160 --ignore=E221,E241,E201,F401,E302,E305 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
                        lintStdin = true,
                        lintIgnoreExitCode = true,
                        lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
                        lintSource = "flake8"
                    }, {
                        formatCommand = "isort --stdout --profile black -",
                        formatStdin = true
                    }, {
                        lintCommand = "mypy --show-column-numbers --ignore-missing-imports",
                        lintFormats = {
                            "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m",
                            "%f:%l:%c: %tote: %m"
                        },
                        lintSource = "mypy"
                    }
                },
                sh = {
                    {
                        lintSource = "shellcheck",
                        lintCommand = 'shellcheck -f gcc -x',
                        lintFormats = {
                            '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
                            '%f:%l:%c: %tote: %m'
                        }
                    }, {
                        formatCommand = 'shfmt -ci -s -bn',
                        formatStdin = true
                    }
                },
                lua = {
                    {
                        formatCommand = 'lua-format -i',
                        formatStdin = true
                    }
                }
            }
        }
    },
    texlab = {
        settings = {
            latex = {
                forwardSearch = {
                    executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                    args = {"%l", "%p", "%f"}
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
    }
}

for server, config in pairs(configs) do
    config.capabilities = capabilities
    config.on_attach = on_attach
    require'lspconfig'[server].setup(config)
end

function ChangePythonInterpreter(path)
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    local pyright_config = configs.pyright
    pyright_config.settings.python.pythonPath = path
    pyright_config.on_attach = on_attach
    pyright_config.capabilities = capabilities
    lspconfig.pyright.setup(pyright_config)
    vim.cmd('e%')
end

vim.api.nvim_exec([[
command! -nargs=1 -complete=customlist,PythonInterpreterComplete PythonInterpreter lua ChangePythonInterpreter(<q-args>)

function! PythonInterpreterComplete(A,L,P) abort
  let l:venvs = systemlist('find $HOME/venvs -name python')
  let l:binaries = systemlist('which -a python')
  return l:venvs + l:binaries
endfunction
]], false)
