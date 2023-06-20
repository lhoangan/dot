" default settings, might overlap with NVIM

" default of NVIM
syntax on
filetype plugin indent on

set autoindent
set background=dark
set backspace=indent,eol,start
set hidden                      " switch bufferes without having to save
set history=10000               " set to maximum amount
set hlsearch
set incsearch
set noerrorbells                " NVIM default: set belloff all
set ruler
set showcmd                     " show command in bottom line
set wildmenu
" set wildmode=list:longest,full" remove to use NVIM floating box

"
" my taste
"

" set nocompatible              " (may be) required in VIM, ignored in NVIM
set cursorline                  " highlight the line where the cursor is
set title                       " show filename on title bar of console windows
set showmatch
"
" Spaces and Tabs -------------------------------------------------------------- 
set ls=2                        " TODO: what?
set tabstop=4                   " defining width of tab to be as 4 spaces
set expandtab                   " adding spaces when tab is hit
set softtabstop=4               " illustration is here
set shiftwidth=4                " http://vimcasts.org/episodes/tabs-and-spaces/
"
" Indentation and Columns ------------------------------------------------------ 
set nosmartindent               " keeping indents for lines starting with # 
set list                        " using with next line to show spaces, tabs,
set listchars=tab:\|.,trail:.   " showing tabs (not 4 spaces) as |...
set colorcolumn=80              " colorizing the 80th column
set tw=80                       " warping text at 80th column
"
" Line numbers and Rule -------------------------------------------------------- 
set number relativenumber       " using relative number
augroup numbertoggle            " turning off in insert mode or buffer unfocused
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  "
" Folding----------------------------------------------------------------------- 
set foldenable                  " enable folding
" zj, zk for jumping up/down from one fold the others
" zM to mask all zR to expand all
set foldlevelstart=10           " open most folds by default
set foldnestmax=10              " 10 nested fold max
" May causing vim to crash when creating new line on top
set foldmethod=indent           " set indent fold method for python
nnoremap <space> za
vnoremap <space> zf             " would not work with indent method
" More folding preference https://stackoverflow.com/questions/357785/what-is-the-recommended-way-to-use-vim-folding-for-python-code

" Splitting -------------------------------------------------------------------- 
set splitbelow                  " more natural split opening
set splitright                  " more natural split opening
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Highlight -------------------------------------------------------------------

highlight SpellBad ctermbg=Gray
map <silent> <F10> :set invnumber<cr> " Turn off absolute number for current line
" command to highlight unsaved lines
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif
" Auto highlight word under cursor
" https://stackoverflow.com/questions/1551231/highlight-variable-under-cursor-in-vim-like-in-netbeans
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match DiffAdd /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <silent> <F3> :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>


" Status line with information ------------------------------------------------- 
set laststatus=2
" might not be necessary if having vim-airline
set statusline+=%#warningmsg#
" show fullfile name on status line and modified flag
" more information
" http://got-ravings.blogspot.nl/2008/08/vim-pr0n-making-statuslines-that-own.html
set statusline+=%F
"------------------------------------------------------------------------------- 



" set ofu=syntaxcomplete#Complete " specifing function Insert mode omni completion C-X C-O.
" set completeopt=longest,menuone
" map <silent> <F10> :set invnumber<cr>
" set pastetoggle=<F11>
" syntax highlight


" ===================
" tidying :ls
" https://vi.stackexchange.com/questions/4102/how-to-shorten-the-result-of-ls-to-get-only-the-file-name-and-not-the-whole-pa
function! s:MyBufList()
  set nomore
  let buf_count = bufnr("$")
  for i in range(1, buf_count)
    if getbufvar(l:i, '&buflisted') > 0
      let path = bufname(i)
      let filename = fnamemodify(path, ":t")
      let folder = fnamemodify(path, ":h")
      echo i "|" filename . "\t(" . folder . ")"
    endif
  endfor
  set more
endfunction

function! ListBuffers()
    redir => ls_output
    silent exec 'ls'
    redir END

    let list = substitute(ls_output, '"(\f*\ )*(\f*)"' , '\=submatch(2)',    "g")

    echo list
endfunction

command! MBL call s:MyBufList()
command! LB call ListBuffers()

nmap <silent> <Leader>b :MBL<CR>:call feedkeys(':b ')<CR>


"================================================================================ 
"================================================================================ 
" Declaring plugins using vim-plug " https://github.com/junegunn/vim-plug
call plug#begin()

" Interface ---------------------------------------------------------------------
" OneDark theme
Plug 'navarasu/onedark.nvim'
" Lualine
Plug 'nvim-lualine/lualine.nvim'    " :help lua-heredoc
Plug 'nvim-tree/nvim-web-devicons'  " Adding icon to lualine
"--------------------------------------------------------------------------------
" Utilities----------------------------------------------------------------------
" Vim Script
Plug 'nvim-lua/plenary.nvim'        " Part of todo-comments plugin
Plug 'folke/todo-comments.nvim'
"--------------------------------------------------------------------------------
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } "
"--------------------------------------------------------------------------------
Plug 'nvim-tree/nvim-tree.lua/'
"--------------------------------------------------------------------------------
"--------------------------------------------------------------------------------
"
"--------------------------------------------------------------------------------
call plug#end()
"================================================================================ 
"================================================================================ 
"
"--------------------------------------------------------------------------------
" OneDark theme
" Available style: dark, darker, deep, cool, warm, warmer, light
lua require('onedark').setup { style = 'darker' }
lua require('onedark').load()

"--------------------------------------------------------------------------------
" Lualine :help lua-heredoc
lua << END
require('lualine').setup() -- start lua line
require('lualine').setup{
sections = {
  lualine_c = {
    {
      'buffers',
      show_filename_only = true,   -- Shows shortened relative path when set to false.
      hide_filename_extension = false,   -- Hide filename extension when set to true.
      show_modified_status = true, -- Shows indicator when the buffer is modified.

      mode = 0, -- 0: Shows buffer name
                -- 1: Shows buffer index
                -- 2: Shows buffer name + buffer index
                -- 3: Shows buffer number
                -- 4: Shows buffer name + buffer number

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

      symbols = {
        modified = ' ●',      -- Text to show when the buffer is modified
        alternate_file = '#', -- Text to show to identify the alternate file
        directory =  '',     -- Text to show when the buffer is a directory
      },
    }
  }
}
}

END
"--------------------------------------------------------------------------------
" Todo-comment
lua << EOF
require("todo-comments").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
"--------------------------------------------------------------------------------
" nvim-tree config
lua << END
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
END
