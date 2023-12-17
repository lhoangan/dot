require("mason").setup()
require("mason-lspconfig").setup ({
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    -- This setting has no relation with the `automatic_installation` setting.
    ---@type string[]
    ensure_installed = {'pyright', 'bashls', 'clangd', 'ltex', 'vimls', 'lua_ls'},

    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Servers are not automatically installed.
    --   - true: All servers set up via lspconfig are automatically installed.
    --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
    ---@type boolean
    automatic_installation = false,

    -- See `:h mason-lspconfig.setup_handlers()`
    ---@type table<string, fun(server_name: string)>?
    handlers = nil,
})

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- Setup language servers.
local lspconfig = require('lspconfig')

lspconfig.bashls.setup {}
lspconfig.clangd.setup {}
lspconfig.vimls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.marksman.setup {}

-- Other servers that need extra configuration
lspconfig.pyright.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        pyright = {
            typeCheckingMode = "off",
            diagnosticMode="openFilesOnly",
        }
    }
}
-- LTeX does not seem to work with dictionary
-- lspconfig.ltex.setup { require 'ltex-ls'.setup {
--     -- configuration from `ltex-ls` plugin: https://github.com/vigoux/ltex-ls.nvim
--     on_attach = on_attach,
--     capabilities = capabilities,
--     use_spellfile = false,
--     window_border = 'single',
--     filetypes = { "latex", "tex", "bib", "markdown", "gitcommit", "text" },
--     settings = {
--         ltex = {
--             enabled = { "latex", "tex", "bib", "markdown", },
--             language = "auto",
--             dictionary = {
--                 ['en-US'] = {'OOD', 'Puneet'},
--             },
--             diagnosticSeverity = "information",
--             sentenceCacheSize = 2000,
--             -- additionalRules = {
--             --   enablePickyRules = true,
--             --   motherTongue = "fr",
--             -- },
--             disabledRules = {
--               fr = { "APOS_TYP", "FRENCH_WHITESPACE" }
--             },
--             dictionary = (function()
--                 -- For dictionary, search for files in the runtime to have
--                 -- and include them as externals the format for them is
--                 -- dict/{LANG}.txt
--                 --
--                 -- Also add dict/default.txt to all of them
--                 local files = {}
--                 for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
--                   local lang = vim.fn.fnamemodify(file, ":t:r")
--                   local fullpath = vim.fs.normalize(file, ":p")
--                   files[lang] = { ":" .. fullpath }
--                 end
--                 if files.default then
--                   for lang, _ in pairs(files) do
--                     if lang ~= "default" then
--                       vim.list_extend(files[lang], files.default)
--                     end
--                   end
--                   files.default = nil
--                 end
--                 return files
--             end)(),
--         },
--     },
-- }}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

--
-------------------------------------------------------------------------------
-- Neovim Language Server Protocol
-- neovim/nvim-lspconfig
-- Ref: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Ref: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
-- Ref: https://github.com/wookayin/dotfiles/blob/master/nvim/lua/config/lsp.lua
-------------------------------------------------------------------------------

-- Popped up window borders
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = 'single',
    }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = 'single',
        close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
    }
)

-- Diagnostic signs
-- neovim <= 0.5.1
vim.fn.sign_define('LspDiagnosticsSignError',       {text=' ', texthl='DiagnosticsSignError'})
vim.fn.sign_define('LspDiagnosticsSignWarning',     {text=' ', texthl='DiagnosticsSignWarn'})
vim.fn.sign_define('LspDiagnosticsSignInformation', {text=' ', texthl='DiagnosticsSignInfo'})
vim.fn.sign_define('LspDiagnosticsSignHint',        {text=' ', texthl='DiagnosticsSignHint'})

-- neovim >= 0.6.0
vim.fn.sign_define('DiagnosticSignError', {text=' ', texthl='DiagnosticSignError'})
vim.fn.sign_define('DiagnosticSignWarn',  {text=' ', texthl='DiagnosticSignWarn'})
vim.fn.sign_define('DiagnosticSignInfo',  {text=' ', texthl='DiagnosticSignInfo'})
vim.fn.sign_define('DiagnosticSignHint',  {text=' ', texthl='DiagnosticSignHint'})

-- Config diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"  -> show source of diagnostics
    -- prefix = '■', -- Could be '●', '▎', 'x'
  },
  float = {
    source = "always",  -- Or "if_many"  -> show source of diagnostics
  },
})


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        if vim.fn.exists(':Telescope') then
            vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
            vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
            vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
            vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
            vim.keymap.set('n', '<F9>', '<cmd>Telescope diagnostics<CR>', opts)
        else
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.keymap.set('n', '<F9>', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
        end

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)

        vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[e',         vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']e',         vim.diagnostic.goto_next, opts)

        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

