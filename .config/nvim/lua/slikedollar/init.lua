require("slikedollar.set")
require("slikedollar.remap")

local augroup = vim.api.nvim_create_augroup
local trailing_whitespace_group = augroup('trailing_ws', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 50,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = trailing_whitespace_group,
    pattern = "*",
    command = [[%s/\s\+$//e]], -- removes trailing whitespace
})

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
