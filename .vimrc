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
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos
set mouse=a
"set nobinary


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
set completeopt=menu,menuone,noselect

" TextEdit might fail if hidden is not set.
set hidden

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

" move selected lines with Shift + k/j
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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
    nnoremap <silent> <C-g><C-c> :Commits<CR>
    nnoremap <silent> <C-c><C-c> :Command<CR>
    nnoremap <silent> <C-c><C-f> :Format<CR>

    " COC
    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ CheckBackspace() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
      else
        inoremap <silent><expr> <c-@> coc#refresh()
        endif
    
    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)
    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocActionAsync('format')

endif
