"unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set shiftwidth=2
set softtabstop=2
set expandtab

