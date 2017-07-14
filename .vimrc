set nocompatible
filetype on
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
set gfn=Monaco:h12
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
