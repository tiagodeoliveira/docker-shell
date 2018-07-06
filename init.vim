call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'scrooloose/nerdcommenter'
Plug 'udalov/kotlin-vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'neomake/neomake'
Plug 'vim-airline/vim-airline'
Plug 'posva/vim-vue'
Plug 'Shougo/unite.vim'
Plug 'Quramy/vison'
Plug 'vim-syntastic/syntastic'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
call plug#end()

if has('nvim')
  au VimEnter * set wildmode=full
endif
if !&scrolloff
    set scrolloff=3 
endif

syntax enable
filetype plugin indent on

set nocompatible
set encoding=utf-8
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set showcmd
set tabstop=2
set shiftwidth=2
set nofoldenable
set expandtab
set backspace=indent,eol,start
set clipboard+=unnamedplus
set autoindent
set number
set relativenumber
set ignorecase
set smartcase
set incsearch               " Incremental searching
set hlsearch                " Highlight matches
set showmatch               " Show match numbers
set guioptions-=m           " Remove menu in GUI
set guioptions-=T           " Remove toolbar in GUI
set showmode
set list
set ruler
set nobackup
set nowritebackup
set noswapfile
set listchars=tab:▸\ ,eol:¬
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let vim_markdown_preview_toggle=2
let vim_markdown_preview_github=1
let g:airline#extensions#tabline#enabled=1
let NERDTreeShowHidden=1
let NERDTreeDirArrows = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
let mapleader=","           " Use comma as <leader>
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

