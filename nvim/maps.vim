let mapleader = " "
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv 

vnoremap < <gv
vnoremap > >gv
" Copy to clipboard on windows
autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
vmap <C-c> y

nnoremap <C-s> :w<CR>
nnoremap <C-w>q :q<CR>
nnoremap <C-W>Q :q!<CR>

nmap <Leader>so :source ~/AppData/Local/nvim/init.vim <CR>

" split resize
nnoremap <Leader>> 10<C-w>>
nnoremap <Leader>< 10<C-w><

" quick semi
nnoremap <Leader>; $a;<Esc>


