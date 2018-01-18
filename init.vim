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
call plug#end()
let NERDTreeShowHidden=1
if has('nvim')
	au VimEnter * set wildmode=full
endif
set tabstop=4
set shiftwidth=4
set expandtab
set clipboard+=unnamedplus
