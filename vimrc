"unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Always show status line
set laststatus=2

" Github friendly tab stops
set shiftwidth=2
set softtabstop=2
set expandtab

