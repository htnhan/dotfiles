syntax on               " turn on syntax highlighting as soon as possible

set ai                  " I like auto-indent
set number              " with numbers
set expandtab           " there is no tab, just space
set tabstop=4           " and a tab is replaced by 4 space
set ruler               " with a ruler
set laststatus=2
set dir=~/.vim/tmp
set bg=light

"create a funciton ColorColumn to highlight with specific color
"then call matchadd to call that function at column #81 every 100 ms
highlight ColorColumn ctermbg=red
"call matchadd('ColorColumn', '\%73v', 100) "set that


"force trailing spaces and tabs to be even more visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list


autocmd BufWritePre * :silent %s/\s\+$//e
"autocmd BufWritePre * :silent %s/\t/    /e

"hilight TODO stuffs"
syn keyword cTodo contained TODO XXX FIXME
augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1)
augroup END

