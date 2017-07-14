" ============================================================================
" Current plugins
"
" Declare vim-plug plugins

call plug#begin('~/.vim/plugged')

" vim airline: for status bars and other decoration
" More information at https://github.com/vim-airline/vim-airline
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code syntax checker
Plug 'vim-syntastic/syntastic'

" Code completion, jedi-vim sucks, YouCompleteMe requires too much installation
" Plug 'Valloric/YouCompleteMe'
" Plug 'davidhalter/jedi-vim'
Plug 'Shougo/neocomplete' " this requires vim from 7.4 and built with lua

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
" VIMRC settings

set nocompatible              " be iMproved, required
filetype off                  " required
filetype on                   " these 2 seems to be conflict, TODO test
filetype plugin indent on
set t_Co=256
syntax on
let python_highlight_all=1

" GUI
" color scheme
" colorscheme lucius
" colorscheme vibrantink "darkbackground
" colorscheme fruit 
" colorscheme spring
set background=light
colorscheme PaperColor
" show line numbers
set number
" hight cursor line
set cursorline
" show command in bottom line
set showcmd
" show filename on title bar of console windows
set title
" show status line with information
set laststatus=2
" might not be necessary if having vim-airline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
" show fullfile name on status line and modified flag
" more information
" http://got-ravings.blogspot.nl/2008/08/vim-pr0n-making-statuslines-that-own.html
set statusline+=%F 


" ============================================================================
" Spaces and tabs
set shiftwidth=4
set tabstop=4
set expandtab
set ls=2
set softtabstop=4
set nosmartindent
set autoindent
"
" ============================================================================
" Search
set hlsearch
set incsearch
set showmatch
set ruler

" ============================================================================
" Code folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent


nnoremap <F8> :!/opt/local/bin/ctags -R --python-kinds=-i *.py<CR>
nnoremap <Ctrl-1> :TlistToggle<CR>
nnoremap <Ctrl-2> :NERDTreeToggle<CR>
let Tlist_WinWidth=50
set backspace=indent,eol,start
set ofu=syntaxcomplete#Complete
set completeopt=longest,menuone
"set gfn=Monaco:h12
highlight SpellBad ctermbg=Gray
set noerrorbells
map <silent> <F10> :set invnumber<cr>

set history=50
set ignorecase
set smartcase
set pastetoggle=<F11>
set wildmenu
set wildmode=longest:full
set noeb vb t_vb=
augroup filetypedetect
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END 
set colorcolumn=80
set hidden " switch bufferes without having to save



if has('gui_running')
    set guifont=Ubuntu\ Mono\ 13
endif

" ============================================================================
" Plugin settings
" Airlines
"
let g:airline_theme = 'light'
" Don't show the tabline bufferlist
" let g:airline#extensions#tabline#enabled = 1
" Show just the filename
" let g:airline#extensions#tabline#fnamemod = ':t'
" Show buffers
" let g:airline#extensions#tabline#show_buffers = 1
" Show bufferline
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#bufferline#overwrite_variables = 1
" ===========
" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']

