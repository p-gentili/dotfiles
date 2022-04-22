" plugins manager
if has('win32')
    call plug#begin('C:\Users\pgentili\_vimfiles\vim_plugged')
else
    call plug#begin("~/.vim/plugged")
endif

" Syntax
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" VSC
Plug 'tpope/vim-fugitive'

" TMUX
Plug 'christoomey/vim-tmux-navigator'

" AIRLINE
Plug 'vim-airline/vim-airline'

" Themes
Plug 'morhetz/gruvbox'

if has('nvim')
    " Neovim specific plugs
else
    " Standard vim specific plugs
endif

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


call plug#end()

"if (has("termguicolors"))
"  set termguicolors
"endif

syntax enable           " enable syntax processing
colorscheme gruvbox
set background=dark

set number              " show line numbers
" set relativenumber      " show relative line numbers

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

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

set fileformat=unix
set fileformats=unix,dos
"set nobinary

set mouse=a

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle= 3
let g:netrw_winsize = 20
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

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

" FZF
nnoremap <silent> <C-t> :Files<CR>

" Airline
let g:airline#extensions#branch#enabled = 1
