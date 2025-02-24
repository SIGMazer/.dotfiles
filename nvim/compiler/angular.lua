
if vim.g.current_compiler == 'angular' then
    return
end

vim.g.current_compiler = 'angular'

vim.opt_local.makeprg = 'NODE_OPTIONS=--max-old-space-size=24561 ng serve -o --watch'

-- typescript errorformat
vim.opt_local.errorformat = vim.opt_local.errorformat + {
    '%E%f:%l:%c - %m'
}
