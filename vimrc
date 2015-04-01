" fix tmux swallowing control characters
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

set t_Co=256

set modeline
set nofoldenable
set nowrap
set nocompatible              " be iMproved, required
filetype off                  " required

" temp dir
set directory=/tmp//,.

" set shift, tab width
set ts=4
set sw=4
set et
set softtabstop=0

" syntax & highlighting
syntax sync fromstart
syntax on
map <silent> <c-L> :redraw<CR>:syn sync fromstart<CR>
set smartindent
set incsearch
set hlsearch
 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'jiangmiao/auto-pairs'
Plugin 'pangloss/vim-javascript'
Bundle 'slim-template/vim-slim.git'
Plugin 'wincent/command-t'
Plugin 'jessedhillon/vim-easycomment'

call vundle#end()            " required
filetype plugin indent on    " required

" command-t
map <silent> <C-T> :CommandT<CR>
if &term =~ "xterm" || &term =~ "screen"
    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
    let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
    let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']
endif

" powerline
let g:Powerline_symbols = 'fancy'

" solarized
syntax enable
set background=dark
colorscheme solarized

" column length control
let &colorcolumn="80,".join(range(99,999),",")
if(&background == "light")
    highlight ColorColumn ctermbg=LightGray
elseif(&background == "dark")
    highlight ColorColumn ctermbg=0
endif

" autocommands for filetypes
au BufRead,BufNewFile *.jinja2 set ft=htmljinja
au FileType python,javascript,ruby,htmljinja,css,scss set number
au FileType ruby set ts=2
au FileType ruby set sw=2

" wildmenu
set wildmenu
set wildignore=*.pyc,*.swp,*.swo,*.egg-info/

" window navigation
map <space> <c-W>w
map <c-J> <C-W>j<C-W>_
map <c-K> <C-W>k<C-W>_

" unshift
imap <s-tab> <c-d>
vmap <tab> >gv
vmap <s-tab> <gv

" tab navigation
nmap t% :tabedit %<CR>
nmap t- :tabclose<CR>
nmap t+ :tabnew<CR>
nmap tt :tabs<CR>

map <c-l> :tabnext<CR>
map <c-h> :tabprev<CR>
map th :tabprev<CR>
map tl :tabnext<CR>

nmap t< :tabmove -1<CR>
nmap t> :tabmove +1<CR>

" insert single character
nnoremap <silent> s :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <silent> S :exec "normal a".nr2char(getchar())."\e"<CR>

" commenting / uncommenting visually selected text
vmap <silent> <C-_> :call ToggleCommentVisual()<CR>
nmap <silent> <C-_> :call ToggleCommentLine()<CR>

au FileType scss let b:comment_style="inline"
au FileType scss let b:comment_opener="//"

au FileType yaml let b:comment_style="inline"
au FileType yaml let b:comment_opener="#"
