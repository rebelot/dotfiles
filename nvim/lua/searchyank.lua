-- Lorem ipsum dolor sit amet, consetetur sadipscing elitr,
-- sed diam nonumy eirmod tempor invidunt ut
-- labore et dolore magna aliquyam erat, sed diam
-- voluptua. At vero eos et accusam et justo
-- duo dolores et ea rebum. Stet clita kasd
-- gubergren, no sea takimata sanctus est Lorem ipsum
-- dolor sit amet.

-- /dol\w* -> 1,7SearchYank -> p -> dolor dolore dolores dolor

vim.api.nvim_create_user_command("SearchYank", function(args)
    vim.fn.setreg(args.reg:lower(), "")
    local line1 = args.line1 or 1
    local line2 = args.line2 or vim.fn.line('$')
    vim.api.nvim_cmd({
        cmd = "substitute",
        args = { string.format([[//\=setreg('%s', submatch(0), 'al')/n]], args.reg) },
        range = { line1, line2 },
    }, {})
end, { range = true, register = true })
