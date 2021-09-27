local vim = vim
vim.o.completeopt = "menu,menuone,noselect"

require "compe".setup {
  enabled = true,
  autocomplete = true,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  documentation = true,
  allow_prefix_unmatch = false,
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  with_text = false,
  source = {
    path = true,
    buffer = true,
    calc = false,
    ultisnips = {priority = 999},
    vsnip = false,
    nvim_lsp = {priority = 1000},
    nvim_lua = true,
    spell = true,
    tags = true,
    tmux = {all_panes = true},
  }
}
