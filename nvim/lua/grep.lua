vim.o.grepprg = "ag --vimgrep"

-- function _G.Grep(...)
--     vim.pretty_print(vim.o.grepprg .. " " .. vim.fn.expandcmd(table.concat({ ... }, " ")))
--     return vim.fn.systemlist(vim.o.grepprg .. " " .. vim.fn.expandcmd(table.concat({ ... }, " ")))
-- end
--
-- vim.api.nvim_create_user_command("Grep", function(args)
--     local results = Grep(unpack(args.fargs))
--     vim.fn.setqflist({}, "r", { lines = results, title = "GREP" })
--     if next(results) then
--         vim.cmd("cwindow")
--     end
-- end, { complete = "file_in_path", bar = true, nargs = "+" })

-- vim.api.nvim_create_user_command("Grep", "cgetexpr v:lua.Grep(<f-args>)", {nargs='+', complete = "file_in_path", bar = true})
-- vim.api.nvim_create_user_command("LGrep", "lgetexpr v:lua.Grep(<f-args>)", {nargs='+', complete = "file_in_path", bar = true})

-- local qf_au_id = vim.api.nvim_create_augroup('QuickFix', {clear = true})
-- vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'cgetexpr', command = 'cwindow', group = qf_au_id})
-- vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'lgetexpr', command = 'lwindow', group = qf_au_id})
-- vim.cmd([[cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep']])
vim.cmd([[
function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
augroup quickfix
   autocmd!
   autocmd QuickFixCmdPost cgetexpr cwindow
   autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
]])
