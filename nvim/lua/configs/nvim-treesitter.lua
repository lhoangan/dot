-------------------------------------------------------------------------------
-- Code parser generator for syntax highlighting
-- nvim-treesitter/nvim-treesitter
-------------------------------------------------------------------------------
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        disable = {},
    },
    indent = {
        enable = true,  -- treesitter's indent is buggy
        disable = {},
    },
    -- A list of parser names, or "all" (those listed parsers should always be installed)
    ensure_installed = {
        "python",
        "c",
        "cpp",
        "bash",
        "latex",
        "bibtex",
        "json",
        "yaml",
        "html",
        "css",
        "lua",
        "cmake",
        "dockerfile",
        "vim",
        "vimdoc",
        "markdown"
    },
    matchup = {
        enable = true,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
  },
})
