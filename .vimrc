set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'bling/vim-airline'
Plugin 'rking/ag.vim'
Plugin 'godlygeek/tabular'
Plugin 'easymotion/vim-easymotion'
Plugin 'sjl/gundo.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'isRuslan/vim-es6'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'majutsushi/tagbar'
Plugin 'sevko/vim-nand2tetris-syntax'
Plugin 'airblade/vim-gitgutter'
Plugin 'ternjs/tern_for_vim'
Plugin 'ruanyl/vim-fixmyjs'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
let mapleader = ","
syntax on
au BufNewFile,BufRead *.es6 set filetype=javascript
syntax enable
set wildmenu
set lazyredraw

set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>
set foldenable
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za
set foldmethod=indent

nnoremap j gj
nnoremap k gk

nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>
nnoremap <leader>u :GundoToggle<CR>

nnoremap <leader>s :mksession<CR>

nnoremap <leader>a :Ag<space>

set tabstop=4 shiftwidth=4 expandtab
function! TrimWhiteSpace()
  %s/\s*$//
  ''
:endfunction

set list listchars=trail:.,extends:>
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

let g:airline#extensions#tabline#enabled = 1

highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn="100,".join(range(150,999),",")

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_auto_jump = 1
let g:syntastic_quiet_messages={'level':'warnings'}
" let g:syntastic_shell = '/usr/local/bin/fish'

let g:syntastic_javascript_checkers = ['eslint']

let g:fixmyjs_rc_path = getcwd() + '/.eslintrc'

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50,results:50'
let g:ctrlp_user_command = 'ag %s -l -U --nocolor -g ""'
let g:ctrlp_working_path_mode = 'r'

set wildignore+=*/node_modules/*,*.swp,*.pyc,*/target/*,*/_vendor/*,static/*js

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

set tags=./tags;
"let g:ctrlp_buftag_ctags_bin = getcwd() . '/tags'
let g:easytags_dynamic_files = 1
let g:easytags_async = 1
let g:easytags_syntax_keyword = 'always'
let g:easytags_events = ['BufWritePost']

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:syntastic_bash_checkers=['']

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set list
set listchars=tab:\ \_

set shell=bash

nnoremap <leader>f <Char-58>Fixmyjs<CR>

nnoremap <leader>s <Char-23><Char-19>
nnoremap <leader>v <Char-23><Char-22>

nnoremap <leader>e <Char-58>CtrlP<CR>
nnoremap <leader>E <Char-58>NERDTree<CR>
nnoremap <leader>t <Char-58>CtrlPTag<CR>
nnoremap <leader>b <Char-58>CtrlPBuffer<CR>
nnoremap <leader>r <Char-58>TagbarOpenAutoClose<CR>

nnoremap <leader>eq <Char-58>Tab<Char-47><Char-61><CR>
nnoremap <leader><Char-58> <Char-58>Tab<Char-47><Char-58><Char-92>zs<CR>
vnoremap <leader>eq <Char-58>Tab<Char-47><Char-61><CR>
vnoremap <leader><Char-58> <Char-58>Tab<Char-47><Char-58><Char-92>zs<CR>

nnoremap <leader>T <Char-58>tabfind ./<CR>

map . <Plug>(easymotion-prefix)

map ; :
noremap ;; ;

let g:tagbar_left = 1

let g:ag_hightlight=1
