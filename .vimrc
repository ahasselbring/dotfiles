set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'bling/vim-airline'
let g:airline_powerline_fonts=1
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled=1
Plugin 'tpope/vim-fugitive'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Valloric/YouCompleteMe'
let g:ycm_confirm_extra_conf=0
let g:ycm_autoclose_preview_window_after_completion=1
Plugin 'jeaye/color_coded'

call vundle#end()

filetype plugin indent on

set backspace=indent,eol,start
set laststatus=2
set mouse=a
set ruler
set number
set showcmd
set showmatch
set incsearch
set ignorecase
set smartcase
set tabstop=2
set shiftwidth=2
set expandtab
autocmd FileType make setlocal noexpandtab
set autoindent
autocmd FileType cpp setlocal smartindent
imap jj <Esc>
set background=dark
colorscheme molokai
syntax on
