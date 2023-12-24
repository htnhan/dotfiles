" pathogen options -  https://github.com/tpope/vim-pathogen/
execute pathogen#infect()
filetype plugin indent on

" hexmode options - https://github.com/fidian/hexmode
let g:hexmode_patterns='*.bin,*.dat,*.hex,*.x86, *.x64'
let g:hexmode_xxd_options='-g 1'

set encoding=UTF-8
syntax on              " turn on syntax highlight
set ai                 " auto indent
set number             " set line number
set tabstop=4          " a tab = 4 spaces
set expandtab          " no tab, only spaces
set ruler              " pretty ruler, flag long lines
set laststatus=2
set dir=$HOME/.vim/tmp " tmp dir to manage all the swap files
set bg=dark            " dark background please

colorscheme onedark
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

" create a function to highlight specific color...
highlight ColorColumn ctermbg=red

" set color at location #80
call matchadd('ColorColumn', '\%79v', 100)
call matchadd('ColorColumn', '\%99v', 100)
call matchadd('ColorColumn', '\%119v', 100)

autocmd BufWritePre * :silent %s/\s\+$//e
autocmd BufWritePre * :silent %s/\t/    /e

syn keyword cTodo contained TODO XXX FIXME
augroup HighlightTodo
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'XXX', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'FIXME', -1)
augroup END
