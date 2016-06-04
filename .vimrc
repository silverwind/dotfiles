"    :::     ::: ::::::::::: ::::    ::::  :::::::::   ::::::::
"    :+:     :+:     :+:     +:+:+: :+:+:+ :+:    :+: :+:    :+:
"    +:+     +:+     +:+     +:+ +:+:+ +:+ +:+    +:+ +:+
"    +#+     +:+     +#+     +#+  +:+  +#+ +#++:++#:  +#+
"     +#+   +#+      +#+     +#+       +#+ +#+    +#+ +#+
" #+#  #+#+#+#       #+#     #+#       #+# #+#    #+# #+#    #+#
" ###    ###     ########### ###       ### ###    ###  ########
"
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" :PlugInstall

call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-sleuth'
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
set complete-=i
set copyindent
set cursorcolumn
set cursorline
set encoding=utf-8
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
set listchars=tab:>-,trail:·,eol:$
set magic
set mat=2
set nobackup
set noerrorbells
set nofoldenable
set noshowmode
set noswapfile
set notitle
set novisualbell
set nowritebackup
set nrformats-=octal
set nu
set pastetoggle=<F2>
set ruler
set scrolloff=1
set sessionoptions-=options
set shiftwidth=2
set showcmd
set showmatch
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
set tm=500
set ttimeout
set ttimeoutlen=50
set ttyfast
set virtualedit=block
set visualbell
set visualbell t_vb=
set whichwrap+=<,>,h,l
set wildchar=<TAB>
set wildignore+=*~,*.o,,*.pyc,.git\*,.hg\*,.svn\*
set wildmenu
set wrap

" Simpler split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Treat long lines as break lines
map j gj
map k gk

" Save on focus lost
au FocusLost * silent! wa

" :W does sudo save
command W w !sudo tee % > /dev/null

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Auto reload .vimrc when editing
autocmd! bufwritepost .vimrc source ~/.vimrc

au FileType Makefile set noexpandtab
inoremap <C-U> <C-G>u<C-U>
