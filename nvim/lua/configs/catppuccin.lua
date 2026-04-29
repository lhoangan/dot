require('catppuccin').setup({
    flavour = "mocha",              -- latte, frappe, macchiato, mocha
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
    term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    background = {                  -- :h background
        light = "latte",
        dark = "mocha",
    },
    dim_inactive = {
        enabled = false,            -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,          -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,              -- Force no italic
    no_bold = false,                -- Force no bold
    no_underline = false,           -- Force no underline
    styles = {
        comments = { 'italic' },
        conditionals = { 'bold' },
        loops = { 'bold' },
        functions = { 'bold', 'italic' },
        keywords = { 'bold', 'italic' },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        aerial = true,
        mason = true,
        cmp = true,
        treesitter = true,
        nvimtree = true,
        render_markdown = true,
        gitsigns = true,
        leap = true,
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        pounce = true,
        rainbow_delimiters = true,
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        navic = {
            enabled = true,
            custom_bg = 'NONE',
        },
        dap = {
            enabled = true,
            enable_ui = true, -- enable nvim-dap-ui
        },
    }
})
require('catppuccin').load()
vim.cmd.colorscheme 'catppuccin-nvim'

-- vim.cmd.highlight('DiagnosticUnderlineError gui=undercurl') -- use undercurl for error, if supported by terminal
