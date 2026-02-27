" .vimrc - Vim Config File

set encoding=utf-8
scriptencoding utf-8

" Performance settings
set lazyredraw
set ttyfast
set regexpengine=1
set synmaxcol=500
set updatetime=800

" vim-plug setup
call plug#begin('~/.vim/plugged')
Plug 'theamallalgi/zitchdog.vim'
call plug#end()

" Core settings
filetype plugin indent on
syntax enable
set mouse=a
set clipboard+=unnamed
set clipboard+=unnamedplus
set noswapfile
set nobackup
set nowritebackup

" Variables
let mapleader = ' '
let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin = 1

" Display settings
set number relativenumber
set laststatus=2
set noshowmode
set showcmd
set ruler
set cursorline
set scrolloff=3
set splitbelow splitright
set fillchars=fold:-,vert:\|
set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:+
set showbreak=↪
set linebreak

" Search settings
set incsearch
set hlsearch
set ignorecase smartcase

" Indentation settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set autoindent
set smartindent

" Completion settings
set wildmenu
set wildmode=list:full
set completeopt+=menuone
set completeopt-=preview
set pumheight=15
set complete+=k,kspell complete-=w complete-=b complete-=u complete-=t

" File settings
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformats=unix,dos
set autowrite
set confirm

" Fold settings
set foldlevel=0
set foldmethod=manual

" Terminal settings
if !has('nvim')
   let &t_SI = "\<esc>[6 q"
   let &t_EI = "\<esc>[2 q"
   if exists('&t_SR')
       let &t_SR = "\<esc>[4 q"
   endif
   set t_Co=256
   if !isdirectory($HOME . '/.local/vim/undo')
       call mkdir($HOME . '/.local/vim/undo', 'p', 0700)
   endif
   set undodir=~/.local/vim/undo
endif

" Misc settings
language en_US.utf-8
set pastetoggle=<F12>
set timeoutlen=500
set matchpairs+=<:>,「:」
set concealcursor=nc
set history=500
set undofile
set spelllang=en,cjk
set virtualedit=block
set formatoptions+=mM
set tildeop
set nojoinspaces
set novisualbell noerrorbells
set nocursorcolumn

" Advanced settings
if exists('&inccommand')
   set inccommand=nosplit
endif
if exists('&pumblend')
   set pumblend=5
endif
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.pyc,*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.pdf
set title
set titlestring=%(\%{hostname()}\ %)\ %(\%{expand('%:p')}\ %)\ %{\strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

" Functions
function! StripTrailingWhitespaces() abort
   let l:save = winsaveview()
   keeppatterns %s/\v\s+$//e
   call winrestview(l:save)
endfunction

function! ToggleFileExplorer()
 if exists(":NERDTreeToggle")
   NERDTreeToggle
 else
   Lexplore
 endif
endfunction

function! StatuslineTrailingSpaceWarning()
   if !exists('b:statusline_trailing_space_warning')
       if !&modifiable
           let b:statusline_trailing_space_warning = ''
           return b:statusline_trailing_space_warning
       endif
       let l:line_num = search('\s\+$', 'nw')
       if l:line_num != 0
           let b:statusline_trailing_space_warning = ' [' . l:line_num . ']' . 'trailing space'
       else
           let b:statusline_trailing_space_warning = ''
       endif
   endif
   return b:statusline_trailing_space_warning
endfunction

function! StatuslineTabWarning()
   if !exists('b:statusline_tab_warning')
       if !&modifiable
           let b:statusline_trailing_space_warning = ''
           return b:statusline_trailing_space_warning
       endif
       let has_leading_tabs = search('^\t\+', 'nw') != 0
       let has_leading_spaces = search('^ \+', 'nw') != 0
       if has_leading_tabs && has_leading_spaces
           let b:statusline_tab_warning = ' [mixed-indenting]'
       elseif has_leading_tabs
           let b:statusline_tab_warning = ' [tabbed-indenting]'
       else
           let b:statusline_tab_warning = ''
       endif
   endif
   return b:statusline_tab_warning
endfunction

" Colorscheme
set termguicolors
"let g:tokyonight_style = 'night'
"let g:tokyonight_enable_italic = 1
"let g:tokyonight_disable_italic_comment = 0
"let g:tokyonight_transparent_background = 0
"let g:tokyonight_menu_selection_background = 'visual'
"let g:tokyonight_cursor = 'auto'
"let g:tokyonight_current_word = 'grey_background'
"colorscheme tokyonight
let g:zitchdog_style = 'grape'
colorscheme zitchdog

" Statusline
let g:currentmode={
      \ 'n'  : 'nor ',
      \ 'v'  : 'vis ',
      \ 'V'  : 'vil ',
      \ "\<C-V>" : 'vib ',
      \ 'i'  : 'ins ',
      \ 'R'  : 'rep ',
      \ 'Rv' : 'vir ',
      \ 'c'  : 'com ',
      \ 't'  : 'ter '
      \}

set statusline=
set statusline+=%#lualine_a_normal#
set statusline+=\ %{tolower(g:currentmode[mode()])}
set statusline+=%{&spell?'[SPELL]':''}
set statusline+=%#WarningMsg#
set statusline+=%{&paste?'[PASTE]':''}
set statusline+=%#lualine_b_normal#
set statusline+=\ %F
set statusline+=%{&modified?'\ \uf068':''}
set statusline+=%{&readonly?'\ \uf023':''}
set statusline+=%=
set statusline+=%=
set statusline+=%#lualine_c_normal#
set statusline+=%{&filetype!=''?''.&filetype.'\ ':'none\ '}
set statusline+=%#WarningMsg#
set statusline+=%{&bomb?'[BOM]':''}
set statusline+=%#lualine_a_normal#
set statusline+=[%l/%L]
set statusline+=\ col:%2c
set statusline+=%#WarningMsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%{StatuslineTabWarning()}

" Essential mappings
inoremap <silent> jk <Esc>
nnoremap ; :
xnoremap ; :
nnoremap Y y$

" Leader mappings
nnoremap <silent> <leader>w :update<CR>
nnoremap <silent> <leader>q :x<CR>
nnoremap <silent> <leader>Q :qa<CR>
nnoremap <silent> <leader><Space> :call StripTrailingWhitespaces()<CR>
nnoremap <silent><expr> <Leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
nnoremap <leader>v `[V`]
nnoremap <silent> <leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :silent update $MYVIMRC <bar> source $MYVIMRC <bar> echomsg "Nvim config successfully reloaded!"<cr>

" Movement mappings
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> ^ g^
nnoremap <silent> 0 g0
nnoremap H ^
xnoremap H ^
nnoremap L g_
xnoremap L g_
nnoremap <Tab> %
xnoremap $ g_

" Window mappings
nnoremap <silent> <M-h> <C-w>
nnoremap <silent> <M-l> <C-w>>
nnoremap <silent> <M-j> <C-W>-
nnoremap <silent> <M-k> <C-W>+
nnoremap <silent> <M-left> <C-w>h
nnoremap <silent> <M-right> <C-w>l
nnoremap <silent> <M-down> <C-w>j
nnoremap <silent> <M-up> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick fix/location list
nnoremap [l :lprevious<CR>zv
nnoremap ]l :lnext<CR>zv
nnoremap [L :lfirst<CR>zv
nnoremap ]L :llast<CR>zv
nnoremap [q :cprevious<CR>zv
nnoremap ]q :cnext<CR>zv
nnoremap [Q :cfirst<CR>zv
nnoremap ]Q :clast<CR>zv
nnoremap<silent> \x :windo lclose <bar> cclose<CR>
nnoremap <silent> \d :bprevious <bar> bdelete #<CR>

" Text manipulation
nnoremap <leader>p m`o<ESC>p``
nnoremap <leader>P m`O<ESC>p``
nnoremap <expr> oo 'm`' . v:count1 . 'o<Esc>``'
nnoremap <expr> OO 'm`' . v:count1 . 'O<Esc>``'
nnoremap <silent> <Space><Space> a<Space><ESC>h
xnoremap < <gv
xnoremap > >gv
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc

" Insert mode mappings
inoremap <silent> <c-u> <Esc>viwUea
inoremap <silent> <c-t> <Esc>b~lea
inoremap <expr> <cr> ((pumvisible())?("\<C-Y>"):("\<cr>"))
inoremap <expr> <esc> ((pumvisible())?("\<C-e>"):("\<esc>"))
inoremap <expr> <tab> pumvisible()?"\<C-n>":"\<tab>"
inoremap <S-Tab> <ESC><<i

" Search and replace
vnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>
nnoremap <C-H> :%s/
xnoremap <C-H> :s/

" Command mode
nnoremap q; q:

" Terminal
if exists(':tnoremap')
   tnoremap <ESC> <C-><C-n>
endif

" Function keys
nnoremap <silent> <F11> :set spell!<cr>
inoremap <silent> <F11> <C-O>:set spell!<cr>

" Clear highlighting
if maparg('<C-L>', 'n') ==# ''
 nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Arrow key warnings
nnoremap <up> :echoerr "Don't use arrow keys, use HJKL instead bud!"<CR>
nnoremap <down> :echoerr "Don't use arrow keys, use HJKL instead bud!"<CR>
nnoremap <right> :echoerr "Don't use arrow keys, use HJKL instead bud!"<CR>
nnoremap <left> :echoerr "Don't use arrow keys, use HJKL instead bud!"<CR>

" Additional mappings
nnoremap Q :wq<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>/ I#<esc>
nnoremap <C-a> ggVG
nnoremap <C-n> :call ToggleFileExplorer()<CR>
nnoremap <C-t> :terminal<CR>
nnoremap <leader>ss :split<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>c :close<CR>
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap <leader>d m`"ay`"aP``
vnoremap <leader>d ygvP
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>f gg=G<C-o>
nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>e :set spell!<CR>
nnoremap <leader>r :set relativenumber!<CR>
nnoremap <leader>i :set list!<CR>
nnoremap <leader>g :tjump<CR>
nnoremap K :!python -m pydoc<space><c-r><c-w><CR>
nnoremap <leader>x :!%:p<CR>
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>n :tabnext<CR>
nnoremap <leader>p :tabprevious<CR>
nnoremap <leader>tc :tabclose<CR>

" Auto commands
if exists('##CmdLineEnter')
   augroup dynamic_smartcase
       autocmd!
       autocmd CmdLineEnter : set nosmartcase
       autocmd CmdLineLeave : set smartcase
   augroup END
endif

augroup text_file_width
   autocmd!
   autocmd BufNewFile,BufRead *.md,*.MD,*.markdown setlocal textwidth=79
augroup END

if exists('##TermOpen')
   augroup term_settings
       autocmd!
       autocmd TermOpen * setlocal norelativenumber nonumber
       autocmd TermOpen * startinsert
   augroup END
endif

augroup accurate_syn_highlight
   autocmd!
   autocmd BufEnter *.py,*.js :syntax sync fromstart
augroup END

augroup non_utf8_file_warn
   autocmd!
   autocmd BufRead * if &fileencoding != 'utf-8' && expand('%:e') != 'gz'
               \ | unsilent echomsg 'File not in UTF-8 format!' | endif
augroup END

augroup vimfile_setting
   autocmd!
   autocmd FileType vim setlocal foldmethod=expr foldlevel=0 foldlevelstart=-1
   \ foldexpr=VimFolds(v:lnum) foldtext=MyFoldText()
   \ keywordprg=:help formatoptions-=o formatoptions-=r
augroup END

augroup number_toggle
   autocmd!
   autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number | set relativenumber | endif
   autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &number | set norelativenumber | endif
augroup END

augroup check_trailing_space
   autocmd!
   autocmd CursorHold,BufWritePost * unlet! b:statusline_trailing_space_warning
       \ | let &statusline=&statusline
augroup END

augroup check_mixed_tabs
   autocmd!
   autocmd CursorHold,BufWritePost * unlet! b:statusline_tab_warning
       \ | let &statusline=&statusline
augroup END
