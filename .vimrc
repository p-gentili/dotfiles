syntax enable	        " enable syntax processing
set background=dark
colorscheme PaperColor

set number              " show line numbers
set relativenumber      " show relative line numbers

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces when shifting
set expandtab           " tabs are spaces
set backspace=indent,eol,start
set autoindent

set cursorline          " highlight current line

set foldenable          " enable folding
set foldlevelstart=99   " open most folds by default
set foldlevel=99        " open most folds by default
"set foldnestmax=1      " fold w/o nested folding
set foldmethod=indent   " fold based on indent level

set wildmenu            " menu for completion

" remap esc to jk 
inoremap jk <Esc>

" remap for moving within windows without pressing ctrl+w
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" gVIM
if has('win32')
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set shell=powershell
    vmap <C-c> "+yi    
    vmap <C-x> "+c
    vmap <C-v> c<ESC>"+p
    imap <C-v> <ESC>"+pa
endif

" plugins manager
if has('win32')
    call plug#begin('C:\Users\pgentili\_vimfiles\vim_plugged')
else
    call plug#begin("~/.vim/plugged")
endif


Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'https://github.com/vim-scripts/vim-svngutter.git'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()
" ALE
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
\   'python': ['flake8'],
\}

set mouse=a         " use mouse

