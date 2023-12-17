-------------------------------------------------------------------------------
-- Code completion
-- hrsh7th/nvim-cmp
--
-- Ref: for snippet:
-- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
-- https://raw.githubusercontent.com/L3MON4D3/LuaSnip/master/Examples/snippets.lua
-------------------------------------------------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            --vim.fn["vsnip#anonymous"](args.body)

            -- For `luasnip` user.
            require('luasnip').lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-c>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp', max_item_count = 10  },
        { name = 'luasnip', max_item_count = 10  },       -- For luasnip user.
        { name = 'buffer', max_item_count = 10 },-- source for buffer words
        { name = 'path' },                      -- source for filesystem paths
        { name = 'nvim_lsp_signature_help' },   -- display func.sign w current var emphasized
        { name = 'calc' },                      -- source for math calculation
        --{ name = 'vsnip' },       -- For vsnip user.
        --{ name = 'ultisnips' },  -- For ultisnips user.

    },
    formatting = {
        format = require('lspkind').cmp_format({mode='symbol_text', preset='codicons'}),
    },
})
