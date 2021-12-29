call plug#begin('~/AppData/Local/nvim/plugged')
" syntax
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'norcalli/nvim-colorizer.lua'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

 " Themes
"Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'

" NERDTREE
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" typing
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim',
Plug 'editorconfig/editorconfig-vim'
Plug 'mg979/vim-visual-multi'
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-signify'
Plug 'yggdroot/indentline'
Plug 'scrooloose/nerdcommenter'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'

"Smooth Scrolling
Plug 'psliwka/vim-smoothie'

call plug#end()
