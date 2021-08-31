local lspconfig = require'lspconfig'
local vim = vim


-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = false,
--     underline = true,
--     signs = true,
--     update_in_insert = false,
--     severity_sort = true
--   }
-- )
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  function(_, _, params, client_id, _)
    local config = { -- your config
        virtual_text = false,
        underline = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true
    }
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics

    for i, v in ipairs(diagnostics) do
      diagnostics[i].message = string.format("%s: %s", v.source, v.message)
    end

    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
      silent = true,
      -- focusable = false,
      border = 'single',
      max_height = '10'
  }
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
vim.lsp.handlers.hover, { border = "single" })


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
-- do
--     local error_table = {'E','W','I','H'}
--     local method = "textDocument/publishDiagnostics"
--     local default_handler = vim.lsp.handlers[method]
--     vim.lsp.handlers[method] = function(err, meth, result, client_id, bufnr, config)
--         default_handler(err, meth, result, client_id, bufnr, config)
--         local diagnostics = vim.lsp.diagnostic.get_all()
--         local qflist = {}
--         for buf, diagnostic in pairs(diagnostics) do
--             for _, d in ipairs(diagnostic) do
--                 d.bufnr = buf
--                 d.lnum = d.range.start.line + 1
--                 d.col = d.range.start.character + 1
--                 d.type = error_table[d.severity]
--                 d.text = d.message
--                 table.insert(qflist, d)
--             end
--         end
--         vim.lsp.util.set_qflist(qflist)
--     end
-- end
-- lsp-status
require'lsp-status'.register_progress()
capabilities.textDocument.completion.completionItem.workDoneProgress = true
capabilities.window.workDoneProgress = true


function echo_diagnostics()
  local error_table_hl = {'LspDiagnosticsSignError','LspDiagnosticsSignWarning','LspDiagnosticsSignInformation','LspDiagnosticsSignHint'}
  local error_table_prefix = {"[Error]", "[Warning]", "[Info]", "[Hint]"}
  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
  if vim.tbl_isempty(line_diagnostics) then return end
  local message = {}
  local message_len = 0
  for i, diagnostic in ipairs(line_diagnostics) do
      local avail_space = vim.v.echospace - message_len
      -- if [ErrType] could throw off, skip altogether
      if (avail_space < 9) then
          break
      end

      local diag = error_table_prefix[diagnostic.severity] .. " "
      local msg = diagnostic.message .. " "

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

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  require "lsp-status".on_attach(client)

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('x', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('i', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<C-q>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = "single"})<CR>', opts)
  buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lg', '<cmd>lua peek_definition()<CR>', opts) -- treesitter does it better atm

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<leader>gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  if client.resolved_capabilities.signature_help then
    vim.api.nvim_exec([[
    augroup lsp_au
    autocmd! * <buffer>
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({focusable = false})
    autocmd CursorHold <buffer> lua echo_diagnostics()
    autocmd CursorMoved <buffer> echo ""
    augroup END
    ]], false)
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspconfig.pyright.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        -- pyright = { completeFunctionParens = true },
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true
        }
      }
    }
}

-- lspconfig.bashls.setup{}

-- lspconfig.vimls.setup{}

-- lspconfig.julials.setup{}

lspconfig.ccls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
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
          "-std=c++17",
        },
      },
    },
}

lspconfig.texlab.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        latex = {
            forwardSearch = {
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline";
                args = {"%l", "%p", "%f"};
            }
        }
    }
}

lspconfig.efm.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {'lua', 'cpp', 'python', 'sh', 'bash', 'tex', 'c', 'markdown', 'pandoc'},
    init_options = {
        documentFormatting = true,
        codeAction = true
    },
    settings = {
        languages = {
            python = {
                { formatCommand = 'black --quiet -', formatStdin = true},
                { lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
                  lintStdin = true,
                  lintIgnoreExitCode = true,
                  lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
                  lintSource = "flake8"
                },
                { formatCommand = "isort --stdout --profile black -",
                  formatStdin = true
                },
                { lintCommand = "mypy --show-column-numbers --ignore-missing-imports",
                  lintFormats = {
                    "%f:%l:%c: %trror: %m",
                    "%f:%l:%c: %tarning: %m",
                    "%f:%l:%c: %tote: %m"
                  },
                lintSource = "mypy"
               }
            }
        }
    }
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {'/Users/laurenzi/usr/src/lua-language-server/bin/macOS/lua-language-server', "-E", "/Users/laurenzi/usr/src/lua-language-server/main.lua"};
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'use'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- local servers = require "lspinstall".installed_servers()
local servers = {"texlab", "vimls", "bashls", "julials" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup{capabilities = capabilities, on_attach = on_attach}
end

vim.fn.sign_define('LspDiagnosticsSignError', { text = "" }) --, texthl = "RedSign" })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "" }) --, texthl = "YellowSign" })
vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "" }) --, texthl = "BlueSign" })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = "" }) --, texthl = "AquaSign" })

function ChangePythonInterpreter(path)
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    lspconfig.pyright.setup{settings = {python = {pythonPath = path}}, on_attach = on_attach, capabilities = capabilities}
    vim.cmd('e%')
end

vim.api.nvim_exec(
[[
command! -nargs=1 -complete=customlist,PythonInterpreterComplete PythonInterpreter lua ChangePythonInterpreter(<q-args>)

function! PythonInterpreterComplete(A,L,P) abort
  let l:venvs = systemlist('find $HOME/venvs -name python')
  let l:binaries = systemlist('which -a python')
  return l:venvs + l:binaries
endfunction
]], false)
