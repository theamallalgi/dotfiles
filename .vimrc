" .vimrc - Vim Config File

set encoding=utf-8
scriptencoding utf-8

" Performance settings
set lazyredraw
set ttyfast
set regexpengine=1
set synmaxcol=500
set updatetime=800
set ttimeout
set ttimeoutlen=10

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

" Disable unused built-in plugins
let g:loaded_netrwPlugin      = 1
let g:loaded_2html_plugin     = 1
let g:loaded_matchit          = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_vimballPlugin    = 1
let g:loaded_tarPlugin        = 1
let g:loaded_zipPlugin        = 1
let g:loaded_gzip             = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_spellfile_plugin  = 1

" Variables
let mapleader = ' '

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
set wildmode=longest:full,full
set wildoptions=pum
set wildignorecase
set completeopt+=menuone
set completeopt-=preview
set pumheight=15
set complete=.,w,b,u,t,],i,k
set dictionary+=/usr/share/dict/words
set path+=**
set path-=/usr/include

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
else
    if !isdirectory($HOME . '/.local/share/nvim/undo')
        call mkdir($HOME . '/.local/share/nvim/undo', 'p', 0700)
    endif
    set undodir=~/.local/share/nvim/undo
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
set formatoptions=tcqjlmM
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

" FUNCTIONS

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

" COLORSCHEME

set termguicolors
let g:zitchdog_style = 'grape'
colorscheme zitchdog

" STATUSLINE

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

" OMNI COMPLETION

augroup omniCompletion
    autocmd!
    autocmd FileType html,htmldjango    setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css,scss,less      setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType javascript,jsx     setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType typescript,tsx     setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType json               setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType sh,bash,zsh        setlocal omnifunc=syntaxcomplete#Complete
    autocmd FileType conf,config        setlocal omnifunc=syntaxcomplete#Complete
    autocmd FileType python             setlocal omnifunc=python3complete#Complete
augroup END

inoremap <silent> <C-Space> <C-x><C-o>

" LINTING (via :make)

augroup lintOnFiletype
    autocmd!
    autocmd FileType sh,bash,zsh    setlocal makeprg=bash\ -n\ %
    autocmd FileType python         setlocal makeprg=python\ -m\ py_compile\ %
    autocmd FileType javascript,jsx setlocal makeprg=node\ --check\ %
augroup END

" FORMATTING

augroup formatByFiletype
    autocmd!
    autocmd FileType html,css,scss,less,javascript,jsx,typescript,tsx,json
        \ nnoremap <buffer> <leader>F :silent !prettier --write %<CR>:edit!<CR>
    autocmd FileType sh,bash,zsh
        \ nnoremap <buffer> <leader>F :silent !shfmt -w -i 4 -ci %<CR>:edit!<CR>
    autocmd FileType python
        \ nnoremap <buffer> <leader>F :silent !black %<CR>:edit!<CR>
    autocmd FileType conf,config,toml,yaml
        \ nnoremap <buffer> <leader>F gg=G<C-o>
augroup END

" ctags generation
nnoremap <leader>ct :silent !ctags -R --exclude=.git --exclude=node_modules .<CR>

" LARGE FILE GUARD

augroup largeFile
    autocmd!
    autocmd BufReadPre * if getfsize(expand('<afile>')) > 2 * 1024 * 1024
        \| setlocal eventignore+=FileType
        \| setlocal noswapfile bufhidden=unload undolevels=-1
        \| syntax off
        \| endif
augroup END

" MAPPINGS

" Essential
inoremap <silent> jk <Esc>
nnoremap ; :
xnoremap ; :
nnoremap Y y$

" Leader - file ops
nnoremap <silent> <leader>w :update<CR>
nnoremap <silent> <leader>q :q!<CR>
nnoremap <silent> <leader>Q :qa<CR>
nnoremap <silent> <leader>s :w<CR>
nnoremap <silent> <leader>c :close<CR>
nnoremap <silent> <leader><BS> :call StripTrailingWhitespaces()<CR>
nnoremap <silent><expr> <Leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
nnoremap <leader>v `[V`]
nnoremap <silent> <leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>ev :edit $MYVIMRC<CR>
nnoremap <silent> <leader>sv :silent update $MYVIMRC <bar> source $MYVIMRC <bar> echomsg "Config reloaded!"<CR>

" Leader - toggles
nnoremap <leader>tw :set wrap!<CR>
nnoremap <leader>te :set spell!<CR>
nnoremap <leader>tr :set relativenumber!<CR>
nnoremap <leader>ti :set list!<CR>
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" Leader - splits
nnoremap <leader>ss :split<CR>
nnoremap <leader>vs :vsplit<CR>

" Leader - tabs
nnoremap <leader>t  :tabnew<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>tc :tabclose<CR>

" Leader - misc
nnoremap <leader>f  gg=G<C-o>
nnoremap <leader>ff gg=G<C-o>
nnoremap <leader>g  :tjump<CR>
nnoremap <leader>x  :!%:p<CR>
nnoremap <leader>p  m`o<ESC>p``
nnoremap <leader>P  m`O<ESC>p``
nnoremap <leader>d  m`"ay`"aP``
nnoremap <leader>/  I#<esc>

" Movement
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

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resize
nnoremap <silent> <M-h> <C-w>
nnoremap <silent> <M-l> <C-w>>
nnoremap <silent> <M-j> <C-W>-
nnoremap <silent> <M-k> <C-W>+
nnoremap <silent> <M-left>  <C-w>h
nnoremap <silent> <M-right> <C-w>l
nnoremap <silent> <M-down>  <C-w>j
nnoremap <silent> <M-up>    <C-w>k

" Quickfix / location list
nnoremap [l :lprevious<CR>zv
nnoremap ]l :lnext<CR>zv
nnoremap [L :lfirst<CR>zv
nnoremap ]L :llast<CR>zv
nnoremap [q :cprevious<CR>zv
nnoremap ]q :cnext<CR>zv
nnoremap [Q :cfirst<CR>zv
nnoremap ]Q :clast<CR>zv
nnoremap <silent> \x :windo lclose <bar> cclose<CR>
nnoremap <silent> \d :bprevious <bar> bdelete #<CR>

" Text manipulation
nnoremap <expr> oo 'm`' . v:count1 . 'o<Esc>``'
nnoremap <expr> OO 'm`' . v:count1 . 'O<Esc>``'
nnoremap <silent> <Space><Space> a<Space><ESC>h
xnoremap < <gv
xnoremap > >gv
nnoremap c  "_c
nnoremap C  "_C
nnoremap cc "_cc

" Line moving
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Duplicate line/selection
vnoremap <leader>d ygvP

" Insert mode
inoremap <silent> <c-u> <Esc>viwUea
inoremap <silent> <c-t> <Esc>b~lea
inoremap <expr> <cr>  pumvisible() ? "\<C-Y>" : "\<cr>"
inoremap <expr> <esc> pumvisible() ? "\<C-e>" : "\<esc>"
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <S-Tab> <ESC><<i

" Smarter undo breaks in insert
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap , ,<C-g>u

" Search and replace
vnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>
nnoremap <C-H> :%s/
xnoremap <C-H> :s/

" Command mode
nnoremap q; q:
nnoremap Q :wq<CR>

" Python docs
nnoremap K :!python -m pydoc<space><c-r><c-w><CR>

" Misc
nnoremap <C-a> ggVG
nnoremap <C-n> :call ToggleFileExplorer()<CR>
nnoremap <C-t> :terminal<CR>

" Function keys
nnoremap <silent> <F11> :set spell!<CR>
inoremap <silent> <F11> <C-O>:set spell!<CR>

" Clear highlighting
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Arrow key warnings
nnoremap <up>    :echoerr "Use HJKL"<CR>
nnoremap <down>  :echoerr "Use HJKL"<CR>
nnoremap <right> :echoerr "Use HJKL"<CR>
nnoremap <left>  :echoerr "Use HJKL"<CR>

" Terminal
if exists(':tnoremap')
    tnoremap <ESC> <C-\><C-n>
endif

" AUTO COMMANDS

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
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave  * if &number | set norelativenumber | endif
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

" Highlight trailing spaces
highlight TrailingSpace ctermbg=NONE guibg=#201638

augroup trailing_space
    autocmd!
    autocmd BufEnter * if &buftype == '' | call matchadd('TrailingSpace', '\s\+$') | endif
augroup END
