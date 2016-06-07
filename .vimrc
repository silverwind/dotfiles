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
Plug 'ervandew/supertab'
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
set cursorline
set encoding=utf-8
set equalalways " Make all windows the same size when adding/removing windows
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
set nobomb " Turn off the byte order mark
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
set titleold= " Don't set the title to 'Thanks for flying Vim' when exiting
set tm=500
set ttimeout
set ttimeoutlen=50
set ttyfast
set undolevels=1000
set virtualedit=block
set visualbell
set visualbell t_vb=
set whichwrap+=<,>,h,l
set wildchar=<TAB>
set wildignore+=*~,*.o,,*.pyc,.git\*,.hg\*,.svn\*
set wildmenu
set wrap
set wrapscan " Searches wrap around when reaching EOF

" Simpler split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Treat long lines as break lines
map j gj
map k gk

" Save on focus lost
autocmd FocusLost * silent! wa

" :W does sudo save
command! W w !sudo tee % > /dev/null

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Auto reload .vimrc when editing
augroup reload_vimrc
    autocmd!
    autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

autocmd FileType Makefile set noexpandtab
inoremap <C-U> <C-G>u<C-U>

" Enable rainbow
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

" Force redraw for lighline (Cygwin issue)
autocmd VimEnter * redraw

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

