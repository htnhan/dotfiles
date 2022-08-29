syntax on              " turn on syntax highlight
set ai                 " auto indent
set number             " set line number
set tabstop=4          " a tab = 4 spaces
set expandtab          " no tab, only spaces
set ruler              " pretty ruler, flag long lines
set laststatus=2
set dir=$HOME/.vim/tmp " tmp dir to manage all the swap files
set path+=**           " recursive search
set bg=dark            " dark background please
set nocompatible       " no compatability mode
filetype plugin on

" create a function to highlight specific color...
highlight ColorColumn ctermbg=red

" set color at location #81
call matchadd('ColorColumn', '\%81v', 100)

autocmd BufWritePre * :silent %s/\s\+$//e
autocmd BufWritePre * :silent %s/\t/    /e

syn keyword cTodo contained TODO XXX FIXME Fixme
augroup HighlightTodo
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'XXX', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'FIXME', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'Fixme', -1)
augroup END
