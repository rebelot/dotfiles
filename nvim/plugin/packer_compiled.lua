-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/laurenzi/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/laurenzi/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/laurenzi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/laurenzi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/laurenzi/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  FastFold = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/FastFold"
  },
  NrrwRgn = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/NrrwRgn"
  },
  SimpylFold = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/SimpylFold"
  },
  ale = {
    config = { "\27LJ\2\n‚\5\0\0\3\0\25\00036\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0005\1\f\0=\1\v\0006\0\0\0009\0\1\0005\1\15\0005\2\14\0=\2\16\1=\1\r\0006\0\0\0009\0\1\0'\1\18\0=\1\17\0006\0\0\0009\0\1\0'\1\20\0=\1\19\0006\0\0\0009\0\1\0'\1\22\0=\1\21\0006\0\0\0009\0\1\0005\1\24\0=\1\23\0K\0\1\0\1\n\0\0\t.env\n.venv\benv\vve-py3\ave\15virtualenv\tvenv\b.ve\nvenvs\29ale_virtualenv_dir_names\28--ignore=E221,E241,E201\30ale_python_flake8_options\16--disable=C\30ale_python_pylint_options\29--ignore-missing-imports\28ale_python_mypy_options\vpython\1\0\0\1\4\0\0\vflake8\vpylint\tmypy\16ale_linters\1\0\2\vpython\rautopep8\ash\nshfmt\15ale_fixers\valways\29ale_lint_on_text_changed\bï”©\21ale_sign_warning\bï™™\19ale_sign_error\23ale_set_highlights\25ale_floating_preview\16ale_enabled\6g\bvim\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/ale"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["compe-tmux"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/compe-tmux"
  },
  ["csv.vim"] = {
    commands = { "CSVInit" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/csv.vim"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n)\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\14dashboard\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  delimitmate = {
    config = { '\27LJ\2\nï\1\0\0\2\0\b\0\0216\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\2\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\3\0\0\6"\6`\31delimitMate_nesting_quotes\29delimitMate_expand_space\26delimitMate_expand_cr\31delimitMate_jump_expansion%delimitMate_expand_inside_quotes\6g\bvim\0' },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/delimitmate"
  },
  ["feline.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18feline-config\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/feline.nvim"
  },
  fzf = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nM\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/goyo.vim"
  },
  ["julia-vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/julia-vim"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/limelight.vim"
  },
  ["lsp-status.nvim"] = {
    config = { "\27LJ\2\nì\1\0\2\a\0\r\0\0309\2\0\1\15\0\2\0X\3\26€5\2\6\0005\3\1\0006\4\2\0009\4\3\0049\4\4\0049\6\0\1:\6\1\6B\4\2\2=\4\5\3=\3\a\0025\3\b\0006\4\2\0009\4\3\0049\4\4\0049\6\0\1:\6\2\6B\4\2\2=\4\5\3=\3\t\0026\3\n\0'\5\v\0B\3\2\0029\3\f\3\18\5\0\0\18\6\2\0D\3\3\0K\0\1\0\rin_range\20lsp-status.util\frequire\bend\1\0\1\14character\3\0\nstart\1\0\0\tline\14byte2line\afn\bvim\1\0\1\14character\3\0\15valueRangeÕ\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\18select_symbol\0\19spinner_frames\1\t\0\0\bâ£¾\bâ£½\bâ£»\bâ¢¿\bâ¡¿\bâ£Ÿ\bâ£¯\bâ£·\1\0\v\18status_symbol\5\20update_interval\3d\17indicator_ok\6 \19indicator_hint\6 \19indicator_info\6 \23indicator_warnings\6 \21indicator_errors\6 \24component_separator\5\24indicator_separator\5\16diagnostics\1\21current_function\1\vconfig\15lsp-status\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\nV\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\14with_text\2\vpreset\rcodicons\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22bufferline-config\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15cmp-config\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n’\3\0\0\4\0\15\0\0296\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0005\3\6\0B\0\3\0016\0\2\0009\0\3\0009\0\4\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0'\2\t\0B\0\2\0029\0\n\0B\0\1\0016\0\2\0009\0\v\0+\1\2\0=\1\f\0006\0\2\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0Cau FileType dap-repl lua require('dap.ext.autocompl').attach()\bcmd\21dap_virtual_text\6g\18load_launchjs\19dap.ext.vscode\1\0\4\vlinehl\fdebugPC\vtexthl\20debugBreakpoint\nnumhl\5\ttext\bï‘Š\15DapStopped\1\0\4\vlinehl\5\vtexthl\20debugBreakpoint\nnumhl\5\ttext\tï†ˆ \18DapBreakpoint\16sign_define\afn\bvim\bdap\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-python"] = {
    config = { "\27LJ\2\nW\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\31~/venvs/debugpy/bin/python\nsetup\15dap-python\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-dap-python"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21nvim-tree-config\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-tree.lua/."
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22treesitter-config\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["python-syntax"] = {
    config = { '\27LJ\2\nž\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\4\0K\0\1\0"python_highlight_space_errors.python_highlight_file_headers_as_comments\25python_highlight_all\6g\bvim\0' },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/python-syntax"
  },
  ["sqlite.lua"] = {
    config = { "\27LJ\2\nR\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0$/opt/local/lib/libsqlite3.dylib\21sqlite_clib_path\6g\bvim\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/sqlite.lua"
  },
  ["suda.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/suda.vim"
  },
  tabular = {
    after_files = { "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/tabular"
  },
  tagbar = {
    commands = { "TagbarToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/tagbar"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-dap.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-dap.nvim", "telescope-frecency.nvim", "telescope-fzf-native.nvim" },
    loaded = true,
    only_config = true
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "Trouble", "Trouble*" },
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/trouble.nvim"
  },
  ultisnips = {
    config = { "\27LJ\2\nÌ\2\0\0\2\0\v\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0006\0\0\0009\0\1\0'\1\t\0=\1\b\0006\0\0\0009\0\1\0)\1\0\0=\1\n\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\15<c-x><c-s>\26UltiSnipsListSnippets$<Plug>(ultisnips_jump_backward)!UltiSnipsJumpBackwardTrigger#<Plug>(ultisnips_jump_forward) UltiSnipsJumpForwardTrigger\29<Plug>(ultisnips_expand)\27UltiSnipsExpandTrigger\6g\bvim\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["unicode.vim"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/unicode.vim"
  },
  ["vim-bbye"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-bbye"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\n¢\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\28matchup_override_vimtex\6g\bvim\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/vim-mundo"
  },
  ["vim-pandoc"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-pandoc"
  },
  ["vim-pandoc-syntax"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax"
  },
  ["vim-peekaboo"] = {
    config = { "\27LJ\2\na\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\19vert bo 30 new\20peekaboo_window\21peekaboo_compact\6g\bvim\0" },
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-peekaboo"
  },
  ["vim-pymol"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-pymol"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-sneak"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-sneak"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-snippets/."
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-table-mode"] = {
    commands = { "TableModeToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/vim-table-mode"
  },
  ["vim-tmux"] = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-tmux"
  },
  ["vim-zsh"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/vim-zsh"
  },
  vimux = {
    loaded = true,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vimux"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    config = { "\27LJ\2\nˆ\2\0\0\2\0\n\0\0176\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0006\0\0\0009\0\1\0005\1\t\0=\1\b\0K\0\1\0\1\0\4\bcpp\rnvim_lsp\rmarkdown\rnvim_lsp\vpython\rnvim_lsp\blua\rnvim_lsp\24vista_executive_for\vuctags\27vista_ctags_executable\nctags\28vista_default_executive\17floating_win\31vista_echo_cursor_strategy\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/laurenzi/.local/share/nvim/site/pack/packer/opt/vista.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Runtimepath customization
time([[Runtimepath customization]], true)
vim.o.runtimepath = vim.o.runtimepath .. ",/Users/laurenzi/.local/share/nvim/site/pack/packer/start/vim-snippets/." .. ",/Users/laurenzi/.local/share/nvim/site/pack/packer/start/nvim-tree.lua/."
time([[Runtimepath customization]], false)
-- Config for: ale
time([[Config for ale]], true)
try_loadstring("\27LJ\2\n‚\5\0\0\3\0\25\00036\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0005\1\f\0=\1\v\0006\0\0\0009\0\1\0005\1\15\0005\2\14\0=\2\16\1=\1\r\0006\0\0\0009\0\1\0'\1\18\0=\1\17\0006\0\0\0009\0\1\0'\1\20\0=\1\19\0006\0\0\0009\0\1\0'\1\22\0=\1\21\0006\0\0\0009\0\1\0005\1\24\0=\1\23\0K\0\1\0\1\n\0\0\t.env\n.venv\benv\vve-py3\ave\15virtualenv\tvenv\b.ve\nvenvs\29ale_virtualenv_dir_names\28--ignore=E221,E241,E201\30ale_python_flake8_options\16--disable=C\30ale_python_pylint_options\29--ignore-missing-imports\28ale_python_mypy_options\vpython\1\0\0\1\4\0\0\vflake8\vpylint\tmypy\16ale_linters\1\0\2\vpython\rautopep8\ash\nshfmt\15ale_fixers\valways\29ale_lint_on_text_changed\bï”©\21ale_sign_warning\bï™™\19ale_sign_error\23ale_set_highlights\25ale_floating_preview\16ale_enabled\6g\bvim\0", "config", "ale")
time([[Config for ale]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22treesitter-config\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lsp-status.nvim
time([[Config for lsp-status.nvim]], true)
try_loadstring("\27LJ\2\nì\1\0\2\a\0\r\0\0309\2\0\1\15\0\2\0X\3\26€5\2\6\0005\3\1\0006\4\2\0009\4\3\0049\4\4\0049\6\0\1:\6\1\6B\4\2\2=\4\5\3=\3\a\0025\3\b\0006\4\2\0009\4\3\0049\4\4\0049\6\0\1:\6\2\6B\4\2\2=\4\5\3=\3\t\0026\3\n\0'\5\v\0B\3\2\0029\3\f\3\18\5\0\0\18\6\2\0D\3\3\0K\0\1\0\rin_range\20lsp-status.util\frequire\bend\1\0\1\14character\3\0\nstart\1\0\0\tline\14byte2line\afn\bvim\1\0\1\14character\3\0\15valueRangeÕ\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\18select_symbol\0\19spinner_frames\1\t\0\0\bâ£¾\bâ£½\bâ£»\bâ¢¿\bâ¡¿\bâ£Ÿ\bâ£¯\bâ£·\1\0\v\18status_symbol\5\20update_interval\3d\17indicator_ok\6 \19indicator_hint\6 \19indicator_info\6 \23indicator_warnings\6 \21indicator_errors\6 \24component_separator\5\24indicator_separator\5\16diagnostics\1\21current_function\1\vconfig\15lsp-status\frequire\0", "config", "lsp-status.nvim")
time([[Config for lsp-status.nvim]], false)
-- Config for: vim-peekaboo
time([[Config for vim-peekaboo]], true)
try_loadstring("\27LJ\2\na\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\19vert bo 30 new\20peekaboo_window\21peekaboo_compact\6g\bvim\0", "config", "vim-peekaboo")
time([[Config for vim-peekaboo]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\nV\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\14with_text\2\vpreset\rcodicons\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21telescope-config\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-bufferline.lua
time([[Config for nvim-bufferline.lua]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22bufferline-config\frequire\0", "config", "nvim-bufferline.lua")
time([[Config for nvim-bufferline.lua]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15cmp-config\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: python-syntax
time([[Config for python-syntax]], true)
try_loadstring('\27LJ\2\nž\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\4\0K\0\1\0"python_highlight_space_errors.python_highlight_file_headers_as_comments\25python_highlight_all\6g\bvim\0', "config", "python-syntax")
time([[Config for python-syntax]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
try_loadstring("\27LJ\2\n)\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\14dashboard\frequire\0", "config", "dashboard-nvim")
time([[Config for dashboard-nvim]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: sqlite.lua
time([[Config for sqlite.lua]], true)
try_loadstring("\27LJ\2\nR\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0$/opt/local/lib/libsqlite3.dylib\21sqlite_clib_path\6g\bvim\0", "config", "sqlite.lua")
time([[Config for sqlite.lua]], false)
-- Config for: delimitmate
time([[Config for delimitmate]], true)
try_loadstring('\27LJ\2\nï\1\0\0\2\0\b\0\0216\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\2\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\3\0\0\6"\6`\31delimitMate_nesting_quotes\29delimitMate_expand_space\26delimitMate_expand_cr\31delimitMate_jump_expansion%delimitMate_expand_inside_quotes\6g\bvim\0', "config", "delimitmate")
time([[Config for delimitmate]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\n’\3\0\0\4\0\15\0\0296\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0005\3\6\0B\0\3\0016\0\2\0009\0\3\0009\0\4\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0'\2\t\0B\0\2\0029\0\n\0B\0\1\0016\0\2\0009\0\v\0+\1\2\0=\1\f\0006\0\2\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0Cau FileType dap-repl lua require('dap.ext.autocompl').attach()\bcmd\21dap_virtual_text\6g\18load_launchjs\19dap.ext.vscode\1\0\4\vlinehl\fdebugPC\vtexthl\20debugBreakpoint\nnumhl\5\ttext\bï‘Š\15DapStopped\1\0\4\vlinehl\5\vtexthl\20debugBreakpoint\nnumhl\5\ttext\tï†ˆ \18DapBreakpoint\16sign_define\afn\bvim\bdap\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: feline.nvim
time([[Config for feline.nvim]], true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18feline-config\frequire\0", "config", "feline.nvim")
time([[Config for feline.nvim]], false)
-- Config for: nvim-dap-python
time([[Config for nvim-dap-python]], true)
try_loadstring("\27LJ\2\nW\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\31~/venvs/debugpy/bin/python\nsetup\15dap-python\frequire\0", "config", "nvim-dap-python")
time([[Config for nvim-dap-python]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\n¢\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\28matchup_override_vimtex\6g\bvim\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
try_loadstring("\27LJ\2\nÌ\2\0\0\2\0\v\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0006\0\0\0009\0\1\0'\1\t\0=\1\b\0006\0\0\0009\0\1\0)\1\0\0=\1\n\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\15<c-x><c-s>\26UltiSnipsListSnippets$<Plug>(ultisnips_jump_backward)!UltiSnipsJumpBackwardTrigger#<Plug>(ultisnips_jump_forward) UltiSnipsJumpForwardTrigger\29<Plug>(ultisnips_expand)\27UltiSnipsExpandTrigger\6g\bvim\0", "config", "ultisnips")
time([[Config for ultisnips]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21nvim-tree-config\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd telescope-fzf-native.nvim ]]

-- Config for: telescope-fzf-native.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")

vim.cmd [[ packadd telescope-frecency.nvim ]]

-- Config for: telescope-frecency.nvim
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")

vim.cmd [[ packadd telescope-dap.nvim ]]

-- Config for: telescope-dap.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0", "config", "telescope-dap.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TableModeToggle lua require("packer.load")({'vim-table-mode'}, { cmd = "TableModeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[au CmdUndefined Trouble* ++once lua require"packer.load"({'trouble.nvim'}, {}, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TagbarToggle lua require("packer.load")({'tagbar'}, { cmd = "TagbarToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MundoToggle lua require("packer.load")({'vim-mundo'}, { cmd = "MundoToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CSVInit lua require("packer.load")({'csv.vim'}, { cmd = "CSVInit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType python ++once lua require("packer.load")({'SimpylFold'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType zsh ++once lua require("packer.load")({'vim-zsh'}, { ft = "zsh" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
