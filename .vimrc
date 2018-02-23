"    :::     ::: ::::::::::: ::::    ::::  :::::::::   ::::::::
"    :+:     :+:     :+:     +:+:+: :+:+:+ :+:    :+: :+:    :+:
"    +:+     +:+     +:+     +:+ +:+:+ +:+ +:+    +:+ +:+
"    +#+     +:+     +#+     +#+  +:+  +#+ +#++:++#:  +#+
"     +#+   +#+      +#+     +#+       +#+ +#+    +#+ +#+
" #+#  #+#+#+#       #+#     #+#       #+# #+#    #+# #+#    #+#
" ###    ###     ########### ###       ### ###    ###  ########

call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'eapache/rainbow_parentheses.vim'
Plug 'Townk/vim-autoclose'
Plug 'ervandew/supertab'
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
call plug#end()

set nocompatible
filetype plugin indent on
colorscheme silverwind
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
filetype plugin on
filetype indent on
syntax on

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set bs=2
set cmdheight=1
set modeline
set modelines=4
set exrc
set secure
set complete-=i
set copyindent
set cursorline
set encoding=utf-8
set equalalways
set expandtab
set ffs=unix,dos,mac
set foldmethod=marker
set gdefault
set hidden
set history=500
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set laststatus=2
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set magic
set mat=2
set mouse=""
set nobackup
set nobomb
set noesckeys
set noerrorbells
set nofoldenable
set noshowmode
set noswapfile
set novisualbell
set nowritebackup
set nrformats-=octal
set pastetoggle=<F2>
set ruler
set scrolloff=1
set sessionoptions-=options
set shiftwidth=2
set showcmd
set showmatch
set scrolloff=3
set sidescrolloff=5
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set t_vb=
set tabpagemax=50
set tabstop=2
set title
set titleold=""
set tm=500
set timeoutlen=0
set ttimeoutlen=0
set ttyfast
set undolevels=1000
set virtualedit=block
set visualbell
set visualbell t_vb=
set whichwrap+=<,>,h,l
set wildchar=<TAB>
set wildignore+=*~,*.o,*.pyc,.git\*,.hg\*,.svn\*
set wildmenu
set wrap
set wrapscan

" remap <leader>
let mapleader="-"

" Treat long lines as break lines
map j gj
map k gk

" CTRL+x deletes the current line
map <C-X> dd

" CTRL+d duplicates current line
map <C-D> yyp

" :W does sudo save
command! W w !sudo tee % > /dev/null

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

autocmd FileType Makefile set noexpandtab
inoremap <C-U> <C-G>u<C-U>

" Enable rainbow
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces
let g:rbpt_max = 8
let g:bold_parentheses = 0
let g:rbpt_colorpairs = [
  \ ['208', 'RoyalBlue3'],
  \ ['39', 'SeaGreen3'],
  \ ['46', 'DarkOrchid3'],
  \ ['199', 'firebrick3'],
  \ ['190', 'RoyalBlue3'],
  \ ['92', 'SeaGreen3'],
  \ ['196', 'DarkOrchid3'],
  \ ['44', 'firebrick3'],
  \ ]

" Force redraw for lighline (Cygwin issue)
if !empty($CYGWIN)
  autocmd VimEnter * redraw
endif

" Let cursor move through wrapped lines
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

" CTRL-Space to enter/exit insert mode
nnoremap <C-space> i
imap <C-space> <Esc>

" disable nvim block cursor
set guicursor=
