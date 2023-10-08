-------------------------------------------------------------------------------
-- Show indent lines
-- lukas-reineke/indent-blankline.nvim
-------------------------------------------------------------------------------

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require('indent_blankline').setup({
    --char = "|",
    buftype_exclude = {"terminal"},
    filetype_exclude = {"help", "startify", "make", "NvimTree", "dashboard",
                        "lsp-installer", "alpha", "packer"},
    use_treesitter = true,
    -- space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false, -- true
})

-- Considering custom background highlight
-- More info: https://github.com/lukas-reineke/indent-blankline.nvim
-- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
-- 
-- require("indent_blankline").setup {
--     space_char_blankline = " ",
--     show_current_context = true,
--     show_current_context_start = true,
-- }
