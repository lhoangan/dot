-------------------------------------------------------------------------------
-- Status line at the bottom
-- nvim-lualine/lualine.nvim
-------------------------------------------------------------------------------
require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'onedark',
        --component_separators = {left='', right=''},
        --section_separators = {left='', right=''},
        -- component_separators = {left='', right=''},
        -- section_separators = {left='', right=''},
        component_separators = {left='', right=''},
        section_separators = {left='', right=''},
        disabled_filetypes = {}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            'branch',
            {
                'diff',
                colored=true,
                diff_color = {
                    added = { fg = "#98C379", },
                    modified = { fg = "#E5C07B", },
                    removed = { fg = "#E06C75", }
                },
                symbols = {added = '+', modified = '~', removed = '-'}
            },
            'diagnostics'
        },
        lualine_c = { {
            'buffers',
            show_filename_only = true,   -- Shows shortened relative path when set to false.
            hide_filename_extension = false,   -- Hide filename extension when set to true.
            show_modified_status = true, -- Shows indicator when the buffer is modified.

            mode = 4, -- 0: Shows buffer name
                      -- 1: Shows buffer index (continuous number)
                      -- 2: Shows buffer name + buffer index (continuous)
                      -- 3: Shows buffer number (to call buffer)
                      -- 4: Shows buffer name + buffer number (to call buffer)

            max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                                -- it can also be a function that returns
                                                -- the value of `max_length` dynamically.

            -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
            use_mode_colors = false,

            buffers_color = {
                -- Same values as the general color option can be used here.
                active = {fg='white'}, -- lualine_section_normal',     -- Color for active buffer.
                inactive = 'lualine_section_inactive', -- Color for inactive buffer.
            },
        } },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {'nvim-tree', 'quickfix', 'fugitive'},
    symbols = {
        modified = ' ●',      -- Text to show when the buffer is modified
        alternate_file = '#', -- Text to show to identify the alternate file
        directory =  '',     -- Text to show when the buffer is a directory
    },
})
