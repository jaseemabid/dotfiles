call plug#begin('~/.vim/plugged')


Plug 'tpope/vim-sensible'           " Sensible defaults for everyone
Plug 'tpope/vim-commentary'         " Comment region with gc
Plug 'ctrlpvim/ctrlp.vim'           " Fuzzy finder for files and buffers
Plug 'junegunn/goyo.vim'            " Distraction free writing

Plug 'neovimhaskell/haskell-vim'    " Language bindings
Plug 'rust-lang/rust.vim'
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

call plug#end()

let mapleader="\<SPACE>"

set showcmd                 " Show (partial) command in status line.
set showmatch               " Show matching brackets.
set showmode                " Show current mode.
set ruler                   " Show the line and column numbers of the cursor.
set number                  " Show the line numbers on the left side.
set formatoptions+=o        " Continue comment marker in new lines.
set textwidth=0             " Hard-wrap long lines as you type them.
set expandtab               " Insert spaces when TAB is pressed.
set tabstop=4               " Render TABs using this many spaces.
set shiftwidth=4            " Indentation amount for < and > commands.
set spell spelllang=en_gb   " Spell check locale
set noerrorbells            " No beeps.
set modeline                " Enable modeline.
set linespace=0             " Set line-spacing to minimum.

" More natural splits
set splitbelow              " Horizontal split below current.
set splitright              " Vertical split to right of current.

" Better search
set ignorecase              " Make searching case insensitive
set smartcase               " ... unless the query has capital letters.
set gdefault                " Use 'g' flag by default with :s/foo/bar/.
set magic                   " Use 'magic' patterns (extended regular expressions).

" Highlight long lines and whitespace
match ErrorMsg '\%>120v.\+'
match ErrorMsg '\s\+$'

set clipboard=unnamedplus,unnamed

autocmd BufWritePre * %s/\s\+$//e

" CtrlP

" Open file menu
nnoremap <Leader>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>


function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
  "if !has('gui_running')
  "  let g:solarized_termcolors=256
  "endif
  colors solarized
endfunction

command! ProseMode call ProseMode()
nmap \p :ProseMode<CR>
