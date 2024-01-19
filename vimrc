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
set nocompatible  " be iMproved, required
filetype off  " required

" temp dir
set directory=/tmp//,.

" set shift, tab width
set ts=4
set sw=4
set sts=0  " fuck soft tabs
set et

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

let g:AutoPairsShortcutFastWrap = '<C-S-E>'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'pangloss/vim-javascript'
Bundle 'slim-template/vim-slim.git'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jessedhillon/vim-easycomment'
Plugin 'vim-scripts/sudo.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ledger/vim-ledger'
Plugin 'leafgarland/typescript-vim'
Plugin 'mxw/vim-jsx'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ap/vim-css-color'
Plugin 'digitaltoad/vim-pug'
Plugin 'sheerun/vim-polyglot'
Plugin 'ghifarit53/tokyonight-vim'

call vundle#end()            " required

" status
set laststatus=2

" command-t
map <silent> <C-P> :CtrlP
map <silent> <C-S-P> :CtrlPBuffer
augroup CommandTExtension
    autocmd!
    autocmd FocusGained * CtrlPClearCache
    autocmd BufWritePost * CtrlPClearCache
augroup END

" powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2

" match trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" jsx
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" colors
syntax enable
filetype off
filetype plugin indent on
" set background=dark
" colorscheme solarized
set termguicolors
let g:tokyonight_style = 'storm' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

"vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = "#0ea1e7" })
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" column length control
if(&background == "light")
    highlight ColorColumn ctermbg=LightGray
elseif(&background == "dark")
    highlight ColorColumn ctermbg=0
endif

" title
autocmd BufEnter * let &titlestring = expand("%:t")
set title

" autocommands for filetypes
au BufRead,BufNewFile *.jinja2 set ft=htmljinja
au FileType * let &colorcolumn=""
au FileType python,javascript,typescript let &colorcolumn="80,".join(range(140,999),",")
au FileType python,java,javascript,typescript,c,cc,cpp,ruby,htmljinja,css,scss,yaml set number
au FileType python set ts=4 sw=4 sts=0 et
au FileType ruby,htmljinja,html,yaml,scss,css,c,cc,cpp,ledger,javascript,typescript,soy set ts=2 sw=2 sts=0
au FileType scss set iskeyword+=-

" wildmenu
set wildmenu
set wildignore=*.pyc,*.swp,*.swo,*.egg-info/,**/node_modules/**,node_modules/**,bower_components/**,tmp/**,dist/**,build/**,**/build/**

" remap colon
map ` :

" window navigation
nmap <space> <c-W>w
nmap <c-j> <C-W>j<C-W>_
nmap <c-k> <C-W>k<C-W>_
nmap <s-j> :res -5<CR>
nmap <s-k> :res +5<CR>

" navigate apparent lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" stay in same column traveling lines
set nostartofline

" unshift
imap <s-tab> <c-d>
vmap <tab> >gv
vmap <s-tab> <gv

" tab navigation
nmap t% :tabedit %<CR>
nmap t- :tabclose<CR>
nmap t+ :tabnew<CR>
nmap t= :tabnew<CR>
nmap tt :tabs<CR>

map <c-l> :tabnext<CR>
map <c-h> :tabprev<CR>
map th :tabprev<CR>
map tl :tabnext<CR>

nmap t< :tabmove -1<CR>
nmap t> :tabmove +1<CR>

set timeoutlen=200 ttimeoutlen=0
" insert mode navigation
" imap <ESC>h <left>
" imap <ESC>l <right>
" imap <ESC>j <down>
" imap <ESC>k <up>

" insert single character
nnoremap <silent> s :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <silent> S :exec "normal a".nr2char(getchar())."\e"<CR>

" Ag configuration
nmap <c-s-f> :Ag 
nmap <c-s-g> yiw<ESC>:Ag <c-r>0
vmap <c-s-g> y<ESC>:Ag "<c-r>0"

" commenting / uncommenting visually selected text
vmap <silent> <C-_> :call ToggleCommentVisual()<CR>
nmap <silent> <C-_> :call ToggleCommentLine()<CR>

au FileType scss,javascript,typescript let b:comment_style="inline"
au FileType scss,javascript,typescript let b:comment_opener="//"

au FileType yaml let b:comment_style="inline"
au FileType yaml let b:comment_opener="#"

au FileType ledger let b:comment_style="inline"
au FileType ledger let b:comment_opener=";"

" markdown syntax
au FileType markdown syn region markdownCode matchgroup=markdownCodeDelimiter start="{:" end="}" keepend contains=.*

" spelling
hi SpellBad cterm=underline
