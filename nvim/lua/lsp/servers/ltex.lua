local function read_spellfile(spellfile)
    local path = vim.fn.stdpath("config") .. "/spell/" .. spellfile
    local words = {}
    if vim.fn.filereadable(path) == 0 then
        return words
    end
    for line in io.lines(path) do
        if line:sub(1, 1) ~= "#" then
            table.insert(words, line)
        end
    end
    return words
end

local function update_spellfile(words)
    local lang = vim.tbl_keys(words)[1] ---@type string
    local wordlist = words[lang]
    vim.fn.writefile(wordlist, vim.fn.stdpath("config") .. "/spell/" .. lang:sub(1, 2) .. ".utf-8.add", "a")
end

local function update_config(client, type, data)
    local settings = client.config.settings
    local ltex = settings.ltex
    ltex[type] = ltex[type] or {}
    for lang, list in pairs(data) do
        ltex[type][lang] = ltex[type][lang] or {}
        for _, element in ipairs(list) do
            table.insert(ltex[type][lang], element)
        end
    end
    client.notify("workspace/didChangeConfiguration", { settings = settings })
end

local function update_config_from_spellfile(client)
    local settings = client.config.settings
    local lang = settings.ltex.language or "en-US"
    settings.ltex.dictionary = settings.ltex.dictionary or {}
    settings.ltex.dictionary[lang] = read_spellfile(lang:sub(1, 2) .. ".utf-8.add")
    client.notify("workspace/didChangeConfiguration", { settings = settings })
end

return {
    on_init = function(client, _)
        client.commands["_ltex.addToDictionary"] = function(command, ctx)
            local words = command.arguments[1].words
            -- add_to_dictionary(client, words)
            update_config(client, "dictionary", words)
            update_spellfile(words)
        end
        client.commands["_ltex.disableRules"] = function(command, ctx)
            local rules = command.arguments[1].ruleIds
            update_config(client, "disabledRules", rules)
        end
        client.commands["_ltex.hideFalsePositives"] = function(command, ctx)
            local falsePositives = command.arguments[1].falsePositives
            update_config(client, "hiddenFalsePositives", falsePositives)
        end
    end,
    on_attach = function(client, bufnr)
        vim.keymap.set("n", "zg", function()
            vim.cmd("execute 'norm! zg'")
            update_config_from_spellfile(client)
        end, { buffer = bufnr, desc = "ltex-ls: add word to dictionary" })

        vim.keymap.set("n", "zw", function()
            vim.cmd("execute 'norm! zw'")
            update_config_from_spellfile(client)
        end, { buffer = bufnr, desc = "ltex-ls: remove word from dictionary" })

        update_config_from_spellfile(client)

        vim.api.nvim_buf_create_user_command(bufnr, "LTexSelectLanguage", function(args)
            client.config.settings.ltex.language = args.args
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            update_config_from_spellfile(client)
        end, {
            nargs = 1,
            -- complete = "customlist,v:lua.ltex_select_language",
        })
    end,
    filetypes = { "bib", "markdown", "org", "plaintex", "rst", "tex", "mail" },
    settings = {
        ltex = {
            completionEnabled = true,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "it",
            },
            -- ["ltex-ls"] = {
            --     path = vim.fn.expand("$HOME/usr/src/ltex-ls/lib/ltex-ls-15.2.0"),
            -- },
            language = "en-US",
            checkFrequency = "save",
            -- dictionary = {
            --     ["en-US"] = read_spellfile("en.utf-8.add"),
            -- },
        },
    },
}
