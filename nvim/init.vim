set number
set mouse=a
set numberwidth=1
set clipboard=unnamed
syntax on
set showcmd
set ruler
set cursorline
set encoding=utf-8
set showmatch
set termguicolors
set sw=2
set relativenumber

source ~/AppData/Local/nvim/plugins.vim
source ~/AppData/Local/nvim/plugins-config.vim
source ~/AppData/Local/nvim/maps.vim

" Theme
colorscheme onedark

highlight Normal ctermbg=NONE
set laststatus=2
set noshowmode

" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

