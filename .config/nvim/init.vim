"
" Setup a vim environment
"
set nocompatible

set runtimepath^=$HOME/.config/nvim
set runtimepath^=$HOME/.config/nvim/autoload
set runtimepath^=$HOME/.config/nvim/plugged
" set runtimepath^=$HOME/.config/nvim/shada

syntax on
syntax enable 

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-plug' 

" shorthand notations: fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

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

" add jedi
Plug 'davidhalter/jedi-vim' 
" add the pywal plugin 
Plug 'dylanaraps/wal.vim'
" colorscheme wal 

" Use limelight
" Plug 'junegunn/limelight.vim'

call plug#end()

filetype plugin indent on

" This is a new style
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})

let g:UltiSnipsExpandTrigger='<tab>'

let g:UltiSnipsJumpForwardTrigger='<c-j>'

let g:UltiSnipsJumpBackwardTrigger='<c-k>'

let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_view_method = 'zathura'

let g:python3_host_prog = '/usr/bin/python'

let g:tex_flavor='latex'

set spell spelllang=en
" if !exists('g:ycm_semantic_triggers')
"    let g:ycm_semantic_triggers = {}
" endif

" au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
colorscheme wal

""" Custom mappings

noremap <silent> <Down> gj
noremap <silent> <Up> gk
set number
