call plug#begin()

" VSC
Plug 'tpope/vim-fugitive'

" TMUX
Plug 'christoomey/vim-tmux-navigator'

" AIRLINE
" Plug 'vim-airline/vim-airline'

" Themes
Plug 'morhetz/gruvbox'

if has('nvim')
    " Neovim specific plugs
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
else
    " Standard vim specific plugs
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
endif

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

set completeopt=menu,menuone,noselect

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

" Airline
" let g:airline#extensions#branch#enabled = 1

if has('nvim')

    " Find files using Telescope command-line sugar.
    nnoremap <C-t><C-f> <cmd>Telescope find_files<cr>
    nnoremap <C-t><C-g> <cmd>Telescope live_grep<cr>
    nnoremap <C-t><C-b> <cmd>Telescope buffers<cr>
    nnoremap <C-t><C-t> <cmd>Telescope help_tags<cr>

    " Access GIT data using Telescope
    nnoremap <C-g><C-c> <cmd>Telescope git_commits<cr>
    nnoremap <C-g><C-b> <cmd>Telescope git_branches<cr>
    nnoremap <C-g><C-s> <cmd>Telescope git_status<cr>


lua << EOF
    require('config')
EOF

else
    " FZF
    nnoremap <silent> <C-t><C-f> :Files<CR>
    nnoremap <silent> <C-t><C-b> :Buffers<CR>
    nnoremap <silent> <C-t><C-g> :Rg<CR>
    nnoremap <silent> <C-t><C-c> :Commands<CR>
    nnoremap <silent> <C-g><C-c> :Commits<CR>
endif
