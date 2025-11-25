" See https://github.com/iggredible/Learn-Vim for a comprehensive vim manual

" Keybindings:
"   <leader> = <Space>
"
"   Fzf:
"     <leader><leader> - Search git files
"     <leader>fi       - Search all files
"     <leader><CR>     - Search buffers
"     <leader>fl       - Search lines in current buffer
"     <leader>m        - Search file history
"     <leader>C        - Change color scheme
"
"   Spell checking:
"     <leader>s  - Toggle spell checking
"     <leader>ss - Show spelling suggestions (fzf)
"     <leader>sa - Add word to dictionary
"     <leader>sw - Mark word as wrong
"
"   Other:
"     <Esc><Esc> - Clear search highlight
"     \p         - Enable prose mode (Goyo + spell check)
"     gc         - Toggle comment (visual mode)

call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'            " Distraction free writing
Plug 'tpope/vim-commentary'         " Comment region with gc
Plug 'tpope/vim-sensible'           " Sensible defaults for everyone

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neovimhaskell/haskell-vim'    " Language bindings
Plug 'rust-lang/rust.vim'
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

call plug#end()

let mapleader="\<SPACE>"

set expandtab               " Insert spaces when TAB is pressed.
set formatoptions+=o        " Continue comment marker in new lines.
set linespace=0             " Set line-spacing to minimum.
set modeline                " Enable modeline.
set noerrorbells            " No beeps.
set number                  " Show the line numbers on the left side.
set ruler                   " Show the line and column numbers of the cursor.
set shiftwidth=4            " Indentation amount for < and > commands.
set showcmd                 " Show (partial) command in status line.
set showmatch               " Show matching brackets.
set showmode                " Show current mode.
set spell spelllang=en_gb   " Spell check locale
set tabstop=4               " Render TABs using this many spaces.
set textwidth=0             " Hard-wrap long lines as you type them.

" More natural splits
set splitbelow              " Horizontal split below current.
set splitright              " Vertical split to right of current.

" Better search
set gdefault                " Use 'g' flag by default with :s/foo/bar/.
set ignorecase              " Make searching case insensitive
set magic                   " Use 'magic' patterns (extended regular expressions).
set smartcase               " ... unless the query has capital letters.
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc> " Clear highlight with ESC ESC

" Highlight long lines and whitespace
match ErrorMsg '\%>120v.\+'
match ErrorMsg '\s\+$'

set clipboard=unnamedplus,unnamed

autocmd BufWritePre * %s/\s\+$//e

" Fzf
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader>fi       :Files<CR>
nnoremap <leader>C        :Colors<CR>
nnoremap <leader><CR>     :Buffers<CR>
nnoremap <leader>fl       :Lines<CR>
nnoremap <leader>m        :History<CR>

" Spell checking with fzf
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': '40%'})
endfunction

nnoremap <leader>s :setlocal spell!<CR>
nnoremap <leader>ss :call FzfSpell()<CR>
nnoremap <leader>sa zg
nnoremap <leader>sw zw

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
