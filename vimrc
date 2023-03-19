"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " VI compatible mode is disabled so that vim things work

" =============================================================================
"   PLUGINS
" =============================================================================

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Build Universal Ctags
function! BuildUCtags(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !./autogen.sh
        !./configure
        !make
        !sudo make install
    endif
endfunction

call plug#begin()
" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

" Latex
Plug 'lervag/vimtex'

" C/C++
Plug 'octol/vim-cpp-enhanced-highlight'

" Ctags
Plug 'universal-ctags/ctags', { 'do': function('BuildUCtags') }
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'

" Completion
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer' }

" Linting
Plug 'dense-analysis/ale'

" Format
Plug 'vim-autoformat/vim-autoformat'

Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'skywind3000/asyncrun.vim'

" Movement
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-unimpaired'
call plug#end()

" =============================================================================
"  EDITOR SETTINGS
" =============================================================================

" Leader
let mapleader=" "       " leader is space

" Spaces & Tabs & Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " Insert 4 spaces on a tab
set expandtab       " tabs are spaces, mainly because of python
set autoindent
set smartindent

" UI Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number              " show line numbers
set relativenumber      " show relative numbering
set showcmd             " show command in bottom bar
filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype specific plugin files
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set laststatus=2        " Show the status line at the bottom
set mouse+=a            " A necessary evil, mouse support
set noerrorbells visualbell t_vb=    "Disable annoying error noises
set splitbelow          " Open new vertical split bottom
set splitright          " Open new horizontal splits right
set linebreak           " Have lines wrap instead of continue off-screen
set scrolloff=12        " Keep cursor in approximately the middle of the screen
set updatetime=100      " Some plugins require fast updatetime
" set ttyfast             " Improve redrawing
set cursorline          " highlight current line
hi CursorLine term=bold ctermbg=0 cterm=bold
set background=dark     " Fix vim color scheme change in tmux

" Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Ignore case in searches by default
set smartcase           " But make it case sensitive if an uppercase is entered
" turn off search highlight
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>
" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*,*.swp

" Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move vertically by visual line instead of physical line
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
" (Shift)Tab (de)indents code
vnoremap <Tab> >
vnoremap <S-Tab> <
" Jump to start and end of line using the home row keys
nnoremap H ^
nnoremap L $

" Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autochdir
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" File Encoding
set fileencodings=utf-8,ucs-bom,utf-16,gbk,big5,gb18030,latin1

" Auto close
inoremap {<CR> {<CR>}<Esc>O
inoremap {;<CR> {<CR>};<Esc>O

" =============================================================================
"   PLUGIN CONFIG
" =============================================================================

" Airline config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_skip_empty_sections = 1

function! AirlineInit()
  let g:airline_section_z = airline#section#create_right(['%P','%l/%L','%c'])
endfunction
autocmd VimEnter * call AirlineInit()

let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_theme = 'powerline'
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : ['#I', '#W', '#F'],
      \'options': {
        \'status-justify': 'left'},
      \'y'    : ['%R', '%a', '%F'],
      \'z'    : '#H'}

" Vimtex config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk_engines={'_': '-xelatex'}
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Gutentags config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " enable gtags module
" " let g:gutentags_modules = ['ctags', 'gtags_cscope']
"
" " config project root markers
" let g:gutentags_project_root=['.root', '.svn', '.git', '.hg', '.project']
"
" " generate datebases in my cache directory, prevent gtags files polluting my project
" let g:gutentags_ctags_tagfile = '.tags'
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags
"
" " config ctags arguments
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
" " change focus to quickfix window after search (optional).
" " let g:gutentags_plus_switch = 1
"
" " create ~/.cache/tags if it doesn't exist
" if !isdirectory(s:vim_tags)
"     silent! call mkdir(s:vim_tags, 'p')
" endif

" Youcompleteme config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menu,menuone
let g:ycm_show_diagnostics_ui = 0
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
let g:ycm_key_invoke_completion = '<c-z>'
noremap <c-z> <NOP>
let g:ycm_confirm_extra_conf = 0
let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }
let g:ycm_filetype_whitelist = {
            \ "c": 1,
            \ "cpp": 1,
            \ "python": 1,
            \ "vim": 1,
            \ "sh": 1,
            \ "zsh": 1,
            \ "markdown": 1,
            \ }
augroup MyYCMCustom
    autocmd!
    autocmd FileType c,cpp,python let b:ycm_hover = {
                \ 'command': 'GetDoc',
                \ 'syntax': &filetype
                \ }
augroup END

" ALE config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_cpp_cc_options = '-std=c++17 -O2 -Wall'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'

" Asyncrun config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:asyncrun_open = 6
let g:asyncrun_bell = 1
let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
nnoremap <silent> <F9> :w <cr> :AsyncRun g++ -std=c++17 -Wall -g -O0 -fsanitize=address -I /usr/local/boost_1_78_0 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
nnoremap <silent> <F5> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
nnoremap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
nnoremap <silent> <F8> :AsyncRun -cwd=<root> -raw make run <cr>
nnoremap <silent> <F6> :AsyncRun -cwd=<root> -raw make test <cr>
nnoremap <silent> <F4> :AsyncRun -cwd=<root> cmake . <cr>

" Autoformat config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F3> :Autoformat<CR>
nnoremap <leader>jd :YcmCompleter GoTo<CR>
let g:ycm_auto_hover = ""

" =============================================================================
"   CUSTOM SHORTCUTS
" =============================================================================

" ev sv  --  Vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

"  w wq q q!  --  Quick Save
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>
nmap <Leader>wq :wq<CR>
nmap <Leader>Q :q!<CR>

"  y d p P   --  Quick copy paste into system clipboard
nmap <Leader>y "+y
nmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>y "+y
vmap <Leader>d "+d
vmap <Leader>p "+p
vmap <Leader>P "+P
