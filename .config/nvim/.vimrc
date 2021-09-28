"
" Setup a vim environment
"
set nocompatible

set runtimepath^=$HOME/.config/nvim
set runtimepath^=$HOME/.config/nvim/autoload
set runtimepath^=$HOME/.config/nvim/plugged

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-plug' 

" on-demand loading
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
" vimtex plugin
Plug 'lervag/vimtex'

" Plug 'Shougo/vimshell', { 'rev': '3787e5' }
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1

" if has('python') || has('python3')
if has('python3')
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
endif

Plug 'ervandew/supertab'

" add the pywal plugin 
Plug 'dylanaraps/wal.vim'
" colorscheme wal 

call plug#end()

filetype plugin indent on

" This is a new style
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})

" let g:SuperTabDefaultCompletionType = '<C-n>'

let g:UltiSnipsExpandTrigger='<tab>'

let g:UltiSnipsJumpForwardTrigger='<c-j>'

let g:UltiSnipsJumpBackwardTrigger='<c-k>'

let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_view_method = 'zathura'

let g:python3_host_prog = '/usr/bin/python'

colorscheme wal
