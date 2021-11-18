vim.g.ale_enabled = 0
vim.g.ale_floating_preview = 1
vim.g.ale_set_highlights = 1
vim.g.ale_sign_error = '' --  ⤫
vim.g.ale_sign_warning = '' -- ﯧ  ﯦ   ⚠    
vim.g.ale_lint_on_text_changed = 'always'
vim.g.ale_fixers = {
    python = 'autopep8',
    sh = 'shfmt'
}
vim.g.ale_linters = {
    python = {'flake8', 'pylint', 'mypy'}
}
vim.g.ale_python_mypy_options = '--ignore-missing-imports'
vim.g.ale_python_pylint_options = '--disable=C'
vim.g.ale_python_flake8_options = '--ignore=E221,E241,E201'
vim.g.ale_virtualenv_dir_names = {
    '.env', '.venv', 'env', 've-py3', 've', 'virtualenv', 'venv',
    '.ve', 'venvs'
}
            -- vim.cmd [[ let g:ale_pattern_options = {'\.py$': {'ale_enabled': 0}, '\.c[p]*$': {'ale_enabled': 0}, '\.vim$': {'ale_enabled': 0}} ]]
