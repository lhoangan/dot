local fzf = require('fzf-lua')

fzf.setup{
    files = {
        fzf_opts = {
            ['--layout'] = 'reverse-list',
        }
    },
    previewers = {
        bat = {
          cmd             = "/home/hale/Downloads/bat-v0.26.0-i686-unknown-linux-gnu/bat",
          args            = "--color=always --style=numbers,changes",
        },
    },
    -- winopts = { preview = { default = bat } },
    winopts = { preview = { default = false, hidden = "hidden" } }, -- reduce buffer numbers
}

local git_path = vim.loop.cwd() .. "/.git"
local ok, err = vim.loop.fs_stat(git_path)
if not ok then
	print(err)
end

-- nnoremap <C-p> <cmd>lua require('fzf-lua').files()<CR> -- vim language
vim.keymap.set("n", "<C-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<C-S>", "<cmd>lua require('fzf-lua').files({ prompt='LS> ', cwd=git_path })<CR>", { silent = true })

-- nnoremap <C-\> <cmd>lua require('fzf-lua').buffers()<CR>
-- vim.keymap.set("n", "<C-\\>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
vim.keymap.set("n", "<C-\\>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
-- nnoremap <C-g> <cmd>lua require('fzf-lua').grep()<CR>
vim.keymap.set("n", "<C-d>", "<cmd>lua require('fzf-lua').grep()<CR>", { silent = true })
-- nnoremap <C-l> <cmd>lua require('fzf-lua').live_grep()<CR>
vim.keymap.set("n", "<C-a>", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })

