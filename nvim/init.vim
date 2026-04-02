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
set signcolumn=yes              " column left to line-number to always show
"
" Line numbers and Rule --------------------------------------------------------
set number relativenumber         " using relative number
" This option results in utility window (tree/search) reactivate Lnum when refocus
" augroup numbertoggle            " turning off in insert mode or buffer unfocused
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
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
let g:markdown_folding = 1

" Splitting --------------------------------------------------------------------
set splitbelow                  " more natural split opening
set splitright                  " more natural split opening
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Clipboard -------------------------------------------------------------------
" Link the * register with system's clipboard: have to set in init file
" Try copy with this command    "*yy    (" use register | * name of the register)
set clipboard+=unnamedplus

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

"https://stackoverflow.com/questions/36813466/highlighting-arbitrary-lines-in-vim
" \l to highlight an arbitrary line
" nnoremap <silent> <leader>l :call matchadd('Search', '\%'.line('.').'l')<CR>
" " \L to remove the current highlighted line
" nnoremap <silent> <leader>L :
"   \for m in filter(getmatches(), { i, v -> has_key(l:v, 'pattern') && l:v.pattern is? '\%'.line('.').'l'} )
"   \<BAR>           :call matchdelete(m.id)
"   \<BAR> :endfor<CR>

" Highlights at current lines that move when inserting new line above
" by ChatGPT inspired by the previous version
highlight MarkedLine guibg=#2a3a4a guifg=NONE ctermbg=237 ctermfg=NONE
" Store a list of used marks and their match IDs
let w:marks = []
let w:mark_ids = {}

" cycle through marks a–z
let s:nextmark = char2nr('a')

function! s:MarkAdd()
  " choose a mark character
  let m = nr2char(s:nextmark)
  let s:nextmark = s:nextmark + 1

  " set the mark
  execute 'mark ' . m

  " store it
  call add(w:marks, m)

  " create initial match
  let id = matchadd('MarkedLine', '\%'.line("'".m). 'l')
  let w:mark_ids[m] = id
endfunction

" --- Refresh all highlights when marks move ---
function! s:MarkRefresh()
  for m in w:marks
    if has_key(w:mark_ids, m)
      call matchdelete(w:mark_ids[m])
    endif
    let w:mark_ids[m] = matchadd('MarkedLine', '\%'.line("'".m). 'l')
  endfor
endfunction

" --- Remove highlight if the mark on this line exists ---
function! s:MarkDelete()
  let lnum = line('.')

  " Find which mark (if any) is on the current line
  for m in copy(w:marks)
    if line("'".m) == lnum
      " delete old highlight
      if has_key(w:mark_ids, m)
        call matchdelete(w:mark_ids[m])
        call remove(w:mark_ids, m)
      endif

      " delete the mark itself
      execute "delmarks " . m

      " remove from marks list
      call remove(w:marks, index(w:marks, m))
      return
    endif
  endfor
endfunction

nnoremap <leader>l :call <SID>MarkAdd()<CR>
nnoremap <silent> <leader>L :call <SID>MarkDelete()<CR>

" refresh after edits (marks may move)
autocmd TextChanged,TextChangedI *
      \ if exists('w:marks') | call <SID>MarkRefresh() | endif

"================================================================================
" Center cursor after search
" https://stackoverflow.com/questions/39892498/center-cursor-position-after-search-in-vim
" function! CenterSearch()
"   let cmdtype = getcmdtype()
"   if cmdtype == '/' || cmdtype == '?'
"     return "\<enter>zz"
"   endif
"   return "\<enter>"
" endfunction
" 
" cnoremap <silent> <expr> <enter> CenterSearch()
" 
" nmap * *zz
" nmap # #zz
" nmap n nzz
" nmap N Nzz

" Center the window vertically at the last search match if the search ends up
" scrolling the window up or down at least 75% (3/4) of the actual window height,
" which preserves the context and makes search navigation much easier
"
function! CenterSearch(command = v:null)
  set lazyredraw
  if a:command isnot v:null
    let winstartold = line("w0")
    let winendold   = line("w$")
    try
      execute "normal! " .. a:command
    catch
      echohl ErrorMsg
      echo substitute(v:exception, "^Vim(.*):", "", "")
      echohl NONE
    endtry
  else
    let winstartold = s:winstartold
    let winendold   = s:winendold
  endif
  let winstartnew = line("w0")
  let winendnew   = line("w$")
  let winframe    = float2nr(winheight(0) * (1.0 - 0.75))
  if (winendnew - winstartnew + 1 > 0 && winendold - winstartold + 1 > 0)
  \  && ((winstartnew < winstartold && winendnew < winendold
  \       && winendnew <= winstartold + winframe)
  \      || (winstartnew > winstartold && winendnew > winendold
  \          && winstartnew >= winendold - winframe))
    execute "normal zz"
  endif
  redraw
  set nolazyredraw
endfunction

nnoremap <silent> n :call CenterSearch("n")<CR>
nnoremap <silent> N :call CenterSearch("N")<CR>

" Execute the search as usual, while remembering the resulting window position
" and possibly centering the window vertically at the resulting match
"
function! ExecuteSearch()
  let cmdtype = getcmdtype()
  if cmdtype ==# "/" || cmdtype ==# "?"
    let s:winstartold = line("w0")
    let s:winendold   = line("w$")
    return "\<CR>\<Esc>:call CenterSearch()\<CR>"
  endif
  return "\<CR>"
endfunction

cnoremap <silent> <expr> <CR> ExecuteSearch()

set scrolloff=3 " keep a minimal number of lines above and below the cursor, preserve more context

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

"================================================================================
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
cnoremap <expr> ls (getcmdtype() == ':' && getcmdpos() == 1) ? "MBL\<CR>:b" : "ls"

"================================================================================
" neovim highlight yanked text
" ref: https://www.reddit.com/r/neovim/comments/gofplz/neovim_has_added_the_ability_to_highlight_yanked/
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=500}
augroup END

"================================================================================
" Auto change working directory to the current file
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
" ref: https://vimways.org/2019/vim-and-the-working-directory/
nnoremap <leader>cd :lcd %:h:p
autocmd BufEnter * silent! lcd %:p:h

"================================================================================
" Declaring plugins using vim-plug " https://github.com/junegunn/vim-plug
call plug#begin()

" LSP and coding language ---------------------------------------------------------------------
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " better code highlighting
Plug 'nvim-treesitter/nvim-treesitter-context' " show current function signature on top
Plug 'jose-elias-alvarez/null-ls.nvim'
" Autocompletion
Plug 'L3MON4D3/LuaSnip'         " https://github.com/hrsh7th/nvim-cmp/
Plug 'saadparwaiz1/cmp_luasnip' " as suggested by nvim-cmp
Plug 'onsails/lspkind.nvim'     " VSCode-like pictorgrams
Plug 'hrsh7th/cmp-nvim-lsp'     " source for neovim's built-in language server client
Plug 'hrsh7th/cmp-buffer'       " source for buffer words
Plug 'hrsh7th/cmp-path'         " source for filesystem paths
Plug 'hrsh7th/cmp-cmdline'      " source for vim's cmdline
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'," src for func. sign. w current param emphasized
Plug 'hrsh7th/cmp-calc',        " source for math calculation
Plug 'hrsh7th/nvim-cmp'

" Interface ---------------------------------------------------------------------
" OneDark theme
Plug 'navarasu/onedark.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'catppuccin/nvim'
" Lualine
Plug 'nvim-lualine/lualine.nvim'    " :help lua-heredoc
Plug 'MeanderingProgrammer/render-markdown.nvim'
"--------------------------------------------------------------------------------
" Utilities----------------------------------------------------------------------
" Vim Script
Plug 'nvim-lua/plenary.nvim'        " Part of todo-comments plugin
Plug 'folke/todo-comments.nvim'
"--------------------------------------------------------------------------------
" Plug 'nvim-telescope/telescope-ui-select.nvim'
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } "
Plug 'junegunn/fzf'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
"--------------------------------------------------------------------------------
Plug 'nvim-tree/nvim-tree.lua/'
Plug 'nvim-tree/nvim-web-devicons'  " Adding icon to lualine
"--------------------------------------------------------------------------------
Plug 'lukas-reineke/indent-blankline.nvim', { 'main': 'ibl' }   " Showing indent line
Plug 'simrat39/symbols-outline.nvim'    " Show file layout
Plug 'ekickx/clipboard-image.nvim'      " Paste image directly from clipboard for Markdown
"--------------------------------------------------------------------------------
Plug 'windwp/nvim-autopairs'                " auto closing brackets, parentheses
Plug 'Pocco81/true-zen.nvim'
"--------------------------------------------------------------------------------
Plug 'preservim/tagbar'                 " showing file structure and navigation

"--------------------------------------------------------------------------------
call plug#end()
"================================================================================
"================================================================================
"
"--------------------------------------------------------------------------------
" OneDark theme
" Available style: dark, darker, deep, cool, warm, warmer, light
" lua require('onedark').setup { style = 'dark' }
" lua require('onedark').load()
lua require('configs/catppuccin')

" Config content in in lua/configs/todo-comments-nvim.lua
lua require("configs/todo-comments-nvim")
lua require("configs/lualine")
lua require("configs/nvim-tree")
lua require("configs/mason-lspconfig")
lua require("configs/nvim-treesitter")
" lua require("configs/telescope")
lua require("configs/nvim-cmp")
lua require("configs/symbols-outline")
lua require("configs/indent-blankline")
lua require("configs/clipboard-image")

lua require("configs/true-zen")
lua require("configs/nvim-autopairs")

lua require("configs/fzf")

lua require("configs/render-markdown")

" require tagbar plugin
nmap <F7> :NvimTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>   
