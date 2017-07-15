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

" ===========
" Neocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 1
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
