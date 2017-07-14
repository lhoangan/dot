" ============================================================================
" Current plugins
"
" Declare vim-plug plugins

call plug#begin('~/.vim/plugged')


" vim airline: for status bars and other decoration
" More information at https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code syntax checker
Plug 'vim-syntastic/syntastic'

" Code completion, jedi-vim seems to be newer and has better support
" Plug 'Valloric/YouCompleteMe'
Plug 'davidhalter/jedi-vim'

" LaTeX plugin
Plug 'lervag/vimtex'

" Git integration
Plug 'motemen/git-vim'

" Buffer finders
Plug 'ctrlpvim/ctrlp.vim'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Finish declearing plugins
call plug#end()

" ============================================================================
" Plugin settings
" Airlines
"
let g:airline_theme = 'light theme'
" Show buffer lists for 1 tab
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
"
" ============================================================================
" VIMRC settings

set nocompatible              " be iMproved, required
filetype off                  " required
filetype on                   " these 2 seems to be conflict, TODO test
filetype plugin indent on
set t_Co=256
syntax on
let python_highlight_all=1
set shiftwidth=4
set tabstop=4
set expandtab
set ls=2
set number
set showcmd
set hlsearch
set softtabstop=4
set nosmartindent
set autoindent
set incsearch
set showmatch
set ruler
nnoremap <F8> :!/opt/local/bin/ctags -R --python-kinds=-i *.py<CR>
nnoremap <Ctrl-1> :TlistToggle<CR>
nnoremap <Ctrl-2> :NERDTreeToggle<CR>
let Tlist_WinWidth=50
set backspace=indent,eol,start
set ofu=syntaxcomplete#Complete
set completeopt=longest,menuone
"colorscheme lucius
"colorscheme vibrantink "darkbackground
"colorscheme fruit 
colorscheme spring
"set gfn=Monaco:h12
highlight SpellBad ctermbg=Gray
set cursorline
set noerrorbells
map <silent> <F10> :set invnumber<cr>
set history=50
set ignorecase
set smartcase
set title
set pastetoggle=<F11>
set wildmenu
set wildmode=longest:full
set laststatus=2
set noeb vb t_vb=
augroup filetypedetect
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END 
set colorcolumn=80

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if has('gui_running')
    set guifont=Ubuntu\ Mono\ 13
endif

let g:syntastic_python_checkers = ['pyflakes']
