local function get_python_interpreters(a, l, p)
	local paths = {}
	local is_home_dir = function()
		return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
	end
	local commands = {
		is_home_dir() and "" or [[find ~+ -name python]],
		"echo ${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/python}",
		"find $HOME/venvs -name python",
		"which -a python",
	}
	for _, cmd in ipairs(commands) do
		vim.list_extend(paths, vim.fn.systemlist(cmd))
	end
	local res = {}
	local hash = {}
	for _, v in ipairs(paths) do
		if not hash[v] then
			res[#res + 1] = v
			hash[v] = true
		end
	end
	if a ~= "" then
		local sub = vim.fn.matchfuzzy(res, a)
		if vim.tbl_isempty(sub) then
			return vim.fn.getcompletion(a, "file")
		end
		return sub
	end
	return res
end

local function change_python_interpreter(path)
	vim.g.PythonPath = path

	for _, client in ipairs(vim.lsp.get_clients({ name = "pylance" })) do
		local config = client.config
		client:stop(true)
		vim.diagnostic.reset()
		vim.defer_fn(function()
			vim.lsp.start(config)
		end, 500)
	end
end

-- local function set_python_path(path)
--     local clients = vim.lsp.get_clients {
--         bufnr = vim.api.nvim_get_current_buf(),
--         name = 'pyright',
--     }
--     for _, client in ipairs(clients) do
--         if client.settings then
--             client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
--         else
--             client.config.settings = vim.tbl_deep_extend('force', client.config.settings,
--                 { python = { pythonPath = path } })
--         end
--         client.notify('workspace/didChangeConfiguration', { settings = nil })
--     end
-- end

-- client.server_capabilities.executeCommandProvider
local commands = {
	"pyright.createtypestub",
	"pyright.organizeimports",
	"pyright.dumpFileDebugInfo",
	"python.createTypeStub",
	"python.orderImports",
	"python.addOptionalForParam",
	"python.removeUnusedImport",
	"python.addImport",
	"pylance.changeSpelling",
	"python.intellicode.completionItemSelected",
	"python.intellicode.loadLanguageServerExtension",
	"pylance.extractMethod",
	"pylance.extractVariable",
	"pylance.completionAccepted",
	"pylance.executedClientCommand",
	"pylance.moveSymbol",
	"pylance.getSourceFiles",
	"pylance.getAutoImports",
	"pylance.convertImportFormat",
	"pylance.fixAll",
	"pylance.pytest.a ddAllFixtureTypeAnnotations",
	"pylance.pytest.addFixtureTypeAnnotation",
	"pylance.indexing.clearPersistedIndices",
	"pylance.profiling.start",
	"pylance.profiling.stop",
	"pylance.logging.start",
	"pylance.logging.stop",
	"pylance.implementAllAbstractClasses",
	"pylance.implementAllAbstractClassesWithCopil ot",
	"pylance.getAllDocstringRanges",
	"pylance.generateDocstring",
	"pylance.fixupCopilotDocstringOutput",
	"pylance.server.runCurrentFileInSandbox",
	"pylance.implementUsingCopilot",
}

local function organize_imports(client)
	local command = {
		command = "pyright.organizeimports",
		arguments = { vim.uri_from_bufnr(0) },
	}
	client:exec_cmd(command)
end

---@param client vim.lsp.Client
local function extract_variable(client)
	local pos_params = vim.lsp.util.make_range_params(0, "utf-8")
	local command = {
		command = "pylance.extractVariable",
		arguments = pos_params,
	}
	client:exec_cmd(command)
	-- vim.lsp.buf.rename()
end

---@param client vim.lsp.Client
local function extract_method(client)
	local pos_params = vim.lsp.util.make_range_params(0, "utf-8")
	local command = {
		command = "pylance.extractMethod",
		arguments = pos_params,
	}
	client:exec_cmd(command)
	-- vim.lsp.buf.rename()
end

---@type vim.lsp.ClientConfig
return {
	name = "pylance",
	autostart = true,
	single_file_support = true,
	cmd = { "delance-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	before_init = function(_, config)
		local venv = os.getenv("VIRTUAL_ENV")
		if not config.settings.python then
			config.settings.python = {}
		end
		config.settings.python.pythonPath = vim.g.PythonPath
			or (venv and venv .. "/bin/python")
			or vim.g.python3_host_prog
		vim.notify("PythonPath: " .. config.settings.python.pythonPath)
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "PythonInterpreter", function(args)
			vim.fn.setenv("PATH", (args.args:gsub("/python$", "")) .. ":" .. vim.fn.getenv("PATH"))
			vim.fn.setenv("VIRTUAL_ENV", (args.args:gsub("/bin/python$", "")))
			change_python_interpreter(args.args)
			-- set_lsp_python_path(args.args)
		end, { nargs = 1, complete = get_python_interpreters, desc = "Change python interpreter" })

		vim.api.nvim_buf_create_user_command(bufnr, "PylanceOrganizeImports", function()
			organize_imports(client)
		end, { desc = "Organize Imports" })

		vim.api.nvim_buf_create_user_command(bufnr, "PylanceExtractVariable", function()
			extract_variable(client)
		end, { range = true, desc = "Extract variable" })

		vim.api.nvim_buf_create_user_command(bufnr, "PylanceExtractMethod", function()
			extract_method(client)
		end, { range = true, desc = "Extract methdod" })
	end,
	settings = {
		python = {
			analysis = {
				indexOptions = {
					regenerateStdLibIndices = true,
				},
				indexing = true,
				packageIndexDepths = {
					name = "",
					depth = 4,
					includeAllSymbols = true,
				},
				persistAllIndices = false,
				useLibraryCodeForTypes = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "strict",
				-- autoImportCompletions = false, -- huge pollution
				supportRestructuredText = true,
				enablePytestSupport = true,
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
					pytestParameters = true,
				},
				autoFormatStrings = true,
				-- diagnosticSeverityOverrides = {
				--     reportMissingTypeStubs = "information",
				-- },
			},
		},
	},
}
