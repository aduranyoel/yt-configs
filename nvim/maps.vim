let mapleader = " "

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv 

" circular windows navigation
"nnoremap <Tab>   <c-W>w
"nnoremap <S-Tab> <c-W>W

" TAB in general mode will move to text buffer
nnoremap <silent> <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <silent> <S-TAB> :bprevious<CR>

" Copy to clipboard on windows
autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
vmap <C-c> y

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>

nmap <Leader>so :source ~/AppData/Local/nvim/init.vim <CR>

" split resize
nnoremap <Leader>h 20<C-w><
nnoremap <Leader>l 20<C-w>>

" quick semi
nnoremap <Leader>; $a;<Esc>

" shorter commands
cnoreabbrev tree NERDTreeToggle
cnoreabbrev blame Gblame
cnoreabbrev find NERDTreeFind
cnoreabbrev diff Gdiff

" search commands
nmap <leader>gs :CocSearct 
nmap <Leader>fs :FZF<CR>
nmap <leader>rg :Rg<CR>
map <Leader>e :NERDTreeFind<CR>
map <Leader>p :Files<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" tmux navigator
nnoremap <silent> <Leader><C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <Leader><C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <Leader><C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <Leader><C-l> :TmuxNavigateRight<cr>

" buffers
map <Leader>bf :Buffers<cr>
nmap <leader>bd :bdelete<CR>
nmap <leader><F4> :bw<CR>
nmap <leader><S-F4> :bw!<CR>

" faster scrolling
nnoremap <C-j> 10<C-e>
nnoremap <C-k> 10<C-y>
nmap <Leader>s <Plug>(easymotion-s2)

" git
nnoremap <Leader>G :G<cr>
nnoremap <Leader>gp :G push<cr>
nnoremap <Leader>gl :G pull<cr>
nnoremap <Leader>gc :G commit -m 

" run current file
nnoremap <Leader>x :!node %<cr>

" Ctrl+space to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

set splitright

