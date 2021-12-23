local lspconfig = require("lspconfig")

local pyright = {
	flags = {
		allow_incremental_sync = true,
	},
	single_file_support = true,
	settings = {
		-- pyright = { completeFunctionParens = true },
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				-- stubsPath = "$HOME/typings"
			},
		},
	},
}

local bashls = {}

local vimls = {}

local julials = {}

local ccls = {
	cmd = { "ccls" },
	init_options = {
		cache = {
			directory = "/tmp/ccls",
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
				"-std=c++17",
				"-Wall",
				"-Wextra",
			},
		},
	},
}

local efm = {
	filetypes = {
		"lua",
		"cpp",
		"sh",
		"bash",
		"c",
		"markdown",
		"pandoc",
		"json",
		"python",
	},
	root_dit = lspconfig.util.root_pattern({ ".git", "." }),
	init_options = {
		documentFormatting = true,
		-- documentRangeFormatting = true,
		codeAction = true,
	},
}

local texlab = {
	settings = {
		texlab = {
			build = {
				args = {
					"-xelatex",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"%f",
				},
				executable = "latexmk",
				forwardSearchAfter = true,
			},
			chktex = {
				onOpenAndSave = true,
			},
			forwardSearch = {
				args = { "%l", "%p", "%f" },
				executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
			},
		},
	},
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local sumneko_lua = {
	cmd = {
		"/opt/local/bin/lua-language-server",
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "use" },
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

-- local jsonls = {
-- 	settings = {
-- 		json = {
-- 			schemas = vim.tbl_extend(
-- 				"force",
-- 				{
-- 					{
-- 						description = "codeLLDB settings",
-- 						fileMatch = { "launch.json" },
-- 						name = "launch.json",
-- 						url = "https://raw.githubusercontent.com/vadimcn/vscode-lldb/master/package.json",
-- 					},
-- 				},
-- 				require("schemastore").json.schemas({
-- 					select = {
-- 						"package.json",
-- 						"compile-commands.json",
-- 					},
-- 				})
-- 			),
-- 		},
-- 	},
-- }

local configs = {}

configs.pyright = pyright
configs.bashls = bashls
configs.vimls = vimls
configs.julials = julials
configs.ccls = ccls
-- servers.efm = efm
configs.texlab = texlab
configs.sumneko_lua = sumneko_lua
-- configs.jsonls = jsonls

return configs
