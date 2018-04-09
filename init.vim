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
call plug#end()
if has('nvim')
	au VimEnter * set wildmode=full
endif
if !&scrolloff
    set scrolloff=3 
endif
set tabstop=4
set shiftwidth=4
set expandtab
set clipboard+=unnamedplus
set number
set ignorecase
set smartcase
let vim_markdown_preview_toggle=2
let vim_markdown_preview_github=1
let g:airline#extensions#tabline#enabled=1
let NERDTreeShowHidden=1
