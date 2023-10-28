-------------------------------------------------------------------------------
-- Status line at the bottom
-- nvim-lualine/lualine.nvim
-------------------------------------------------------------------------------
-- Changing filename color based on modified status
-- You can use a custom component extending builtin filename component to do this.
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
local custom_fname = require('lualine.components.filename'):extend()
local highlight = require'lualine.highlight'
local default_status_colors = { saved = '#228B22', modified = '#C70039' }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      {fg = default_status_colors.saved}, 'filename_status_saved', self.options),
    modified = highlight.create_component_highlight_group(
      {fg = default_status_colors.modified}, 'filename_status_modified', self.options),
  }
  if self.options.color == nil then self.options.color = '' end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(vim.bo.modified
                                              and self.status_colors.modified
                                              or self.status_colors.saved) .. data
  return data
end

-------------------------------------------------------------------------------
require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'onedark',
        -- theme = 'catppuccin',
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
        -- lualine_b = {
        --     'branch',
        --     {
        --         'diff',
        --         colored=true,
        --         diff_color = {
        --             added = { fg = "#98C379", },
        --             modified = { fg = "#E5C07B", },
        --             removed = { fg = "#E06C75", }
        --         },
        --         symbols = {added = '+', modified = '~', removed = '-'}
        --     },
        --     -- 'diagnostics'            -- errors
        -- },
        lualine_b = { {
            'buffers',
            show_filename_only = true,   -- Shows shortened relative path when set to false.
            hide_filename_extension = false,   -- Hide filename extension when set to true.
            show_modified_status = true, -- Shows indicator when the buffer is modified.

            mode = 4, -- 0: Shows buffer name
                      -- 1: Shows buffer index (continuous number)
                      -- 2: Shows buffer name + buffer index (continuous)
                      -- 3: Shows buffer number (to call buffer)
                      -- 4: Shows buffer name + buffer number (to call buffer)

            max_length = vim.o.columns * 4 / 5, -- Maximum width of buffers component,
                                                -- it can also be a function that returns
                                                -- the value of `max_length` dynamically.

            -- Automatically updates active buffer color to match color of other
            -- components (will be overidden if buffers_color is set)
            use_mode_colors = false,

            buffers_color = {
                -- Same values as the general color option can be used here.
                active = {fg='white'}, -- lualine_section_normal',     -- Color for active buffer.
                inactive = 'lualine_section_inactive', -- Color for inactive buffer.
            },

            fmt = function(name, context)
                local bufnr = context.bufnr
                if bufnr == vim.api.nvim_get_current_buf() then
                    return name
                else
                    local name_ = name
                    local ext = name:match("^.+(%..+)$")
                    if ext ~= nil and ext ~= '' then
                        name_ = name:gsub(ext, "")
                    end
                    if string.len(name_) - 7 > 8+4 then
                        return name_:sub(1, 7) .. ' > ' .. name_:sub(-8, -1)
                    else if string.len(name_) < 10 then
                        return name_
                    else
                        return name_:sub(1, 7) .. ' >'
                    end end
                end
            end
        } },
        lualine_c = {},-- 'filename'}, custom_fname
        lualine_x = {'filetype'}, -- 'encoding', 'fileformat'
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},-- 'location'},
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
