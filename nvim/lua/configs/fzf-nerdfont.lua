require("fzf-nerdfont").setup({ })


local function insert_fzf_nerdfont()
  vim.cmd.FzfNerdfont()
end

vim.keymap.set("i", "<C-x><C-i>", insert_fzf_nerdfont, {
  noremap = true,
  silent = true,
})

