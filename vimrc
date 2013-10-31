" vim: foldlevel=0 sts=4 sw=4 smarttab et ai textwidth=0
" adapt settings from sites:
"  * http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
"  * https://github.com/amix/vimrc

" disable vi compatible features
set nocompatible

" skip initialization for vim-tiny or vim-small
if !1 | finish | endif

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux = !s:is_windows && !s:is_cygwin && !s:is_darwin

let s:config_root = expand('~/.vim')
let s:bundle_root = s:config_root . '/bundle'

" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END



"""""""""""
" General "
"""""""""""

" set lines of history to remember
set history=100

" :w!! sudo saves the file
" (useful for handling the permission-denied error)
cmap w!! w !sudo tee % > /dev/null

command -nargs=? W w <args>

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd MyAutoCmd BufWrite *.py :call DeleteTrailingWS()
autocmd MyAutoCmd BufWrite *.coffee :call DeleteTrailingWS()



"""""""""""""""
" Key Mapping "
"""""""""""""""

" use ',' instead of '\' as <Leader>
let mapleader = ','
let g:mapleader = ','

" remove highlight with pressing ESC twice or <leader><cr>
nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
nmap <silent> <Leader><cr> :noh<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" Select till a end of a line
vnoremap v $h

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>ss :setlocal spell!<cr>
" Shortcuts using <leader>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=

" pressing ,pp will toggle and untoggle paste mode
" vim does not handle auto-indent in paste mode
nnoremap <leader>pp :set invpaste<CR>

" global syntax highlighting
nnoremap <c-s> :syntax sync fromstart<cr>

" show hidden symbols
nnoremap <leader>. :set invlist<CR>

"""""""""""
" Plugins "
"""""""""""

let s:noplugin = 0
let s:neobundle_root = s:bundle_root . "/neobundle.vim"
if !isdirectory(s:neobundle_root) || v:version < 702
    let s:noplugin = 1
else
    if has('vim_starting')
        execute "set runtimepath+=" . s:neobundle_root
    endif
    call neobundle#rc(s:bundle_root)

    " let NeoBundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'

    " enable async process via vimproc
    NeoBundle "Shougo/vimproc", {
        \ "build": {
        \    "windows"   : "make -f make_mingw32.mak",
        \    "cygwin"    : "make -f make_cygwin.mak",
        \    "mac"       : "make -f make_mac.mak",
        \    "unix"      : "make -f make_unix.mak",
    \ }}

    """""""""""""""""""
    " Style / Display "
    """""""""""""""""""
    " color themes
    NeoBundle "michalbachowski/vim-wombat256mod"

    NeoBundle "bling/vim-airline"
    "let g:airline_powerline_fonts = 1
    let g:airline_theme='powerlineish'

    NeoBundleLazy "ap/vim-css-color", {
        \ "autoload": {
        \   "filetypes": ["html", "css", "less", "sass", "javascript", "coffee", "coffeescript", "djantohtml"],
        \ }}

    """"""""""""""""""""""""""
    " Syntax / Indent / Omni "
    """"""""""""""""""""""""""
    " syntax /indent /filetypes for git
    NeoBundleLazy 'tpope/vim-git', {'autoload': {
        \ 'filetypes': 'git' }}

    " syntax for CSS3
    NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload': {
        \ 'filetypes': 'css' }}

    " syntax for HTML5
    NeoBundleLazy 'othree/html5.vim', {'autoload': {
        \ 'filetypes': ['html', 'djangohtml'] }}

    " syntax /indent /omnicomplete for LESS
    NeoBundleLazy 'groenewege/vim-less.git', {'autoload': {
        \ 'filetypes': 'less' }}

    " syntax for SASS
    NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload': {
        \ 'filetypes': 'sass' }}

    NeoBundleLazy 'hynek/vim-python-pep8-indent', {'autoload': {
        \ "filetypes": ["python", "python3", "djangohtml"],
        \ }}

    """""""""""""""""""
    " File Management "
    """""""""""""""""""
    NeoBundle "thinca/vim-template"
    autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
    function! s:template_keywords()
        silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
        silent! %s/<+FILENAME+>/\=expand('%:r')/g
    endfunction
    autocmd MyAutoCmd User plugin-template-loaded
        \    if search('<+CURSOR+>')
        \ |      silent! execute 'normal! "_da>'
        \ |  endif

    NeoBundleLazy "Shougo/unite.vim", {
        \ "autoload": {
        \     "commands": ["Unite", "UniteWithBufferDir"]
        \ }}

    NeoBundleLazy 'Shougo/unite-outline', {
        \ "autoload": {
        \     "unite_sources": ["outline"],
        \ }}

    nnoremap [unite] <Nop>
    nmap U [unite]
    nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap <silent> [unite]m :<C-u>Unite file_mru directory_mru<CR>
    nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
    nnoremap <silent> [unite]k :<C-u>Unite mapping<CR>
    nnoremap <silent> [unite]h :<C-u>Unite history/yank<CR>
    let s:hooks = neobundle#get_hooks("unite.vim")
    function! s:hooks.on_source(bundle)
        " start unite in insert mode
        let g:unite_enable_start_insert = 1

        " To track long mru history.
	    let g:unite_source_file_mru_long_limit = 3000
	    let g:unite_source_directory_mru_long_limit = 3000

        " Time to update MRU list (now for evey 1 minute)
        let g:unite_source_mrc_update_interval = 60

        " Enable yank history
        let g:unite_source_history_yank_enable = 1

        " use vimfiler to open directory
        "call unite#custom_default_action("source/bookmark/directory", "vimfiler")
        "call unite#custom_default_action("directory", "vimfiler")
        "call unite#custom_default_action("directory_mru", "vimfiler")
        autocmd MyAutoCmd FileType unite call s:unite_settings()
        function! s:unite_settings()
            imap <buffer> <Esc><Esc> <Plug>(unite_exit)
            nmap <buffer> <Esc> <Plug>(unite_exit)
            nmap <buffer> <C-n> <Plug>(unite_select_next_line)
            nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
        endfunction
    endfunction

    " NERDTree
    NeoBundleLazy 'scrooloose/nerdtree', {
                \ 'autoload' : {
                \      "commands": ["NERDTreeToggle"],
                \ }}
    nnoremap <c-b> :NERDTreeToggle<cr>
    " change NERDTree to folder of current file
    nnoremap <Leader>cd :NERDTree %:p:h<cr>
    let s:hooks = neobundle#get_hooks("nerdtree")
    function! s:hooks.on_post_source(bundle)
        let g:NERDTreeDirArrows=1
        let g:NERDTreeMouseMode=1
        let g:NERDTreeChDirMode=2
        let g:NERDTreeMinimalUI=1
        let g:NERDTreeWinSize=32
    endfunction
    " close NERDTree automatically when there are only NERDTree open
    autocmd MyAutoCmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    " Vimfiler (good but for now use NERDTree)
    "NeoBundleLazy "Shougo/vimfiler", {
    "    \ "depends": ["Shougo/unite.vim"],
    "    \ "autoload": {
    "    \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
    "    \   "mappings": ['<Plug>(vimfiler_switch)'],
    "    \   "explorer": 1,
    "    \ }}
    "nnoremap <C-b> :VimFilerExplorer -winminwidth=32<CR>
    "" close vimfiler automatically when there are only vimfiler open
    "autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
    "let s:hooks = neobundle#get_hooks("vimfiler")
    "function! s:hooks.on_source(bundle)
    "    let g:vimfiler_as_default_explorer = 1
    "    let g:vimfiler_enable_auto_cd = 1
    "    let g:vimfiler_force_overwrite_statusline=0
    "    let g:vimfiler_explorer_columns="size"
    "
    "    " ignore dot files and folders
    "    let g:vimfiler_ignore_pattern = '^\.'
    "    " Like Textmate icons.
    "    let g:vimfiler_tree_leaf_icon = ' '
    "    let g:vimfiler_tree_opened_icon = '▾'
    "    let g:vimfiler_tree_closed_icon = '▸'
    "    let g:vimfiler_file_icon = '-'
    "    let g:vimfiler_marked_file_icon = '*'
    "
    "    " vimfiler specific key mappings
    "    autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
    "    function! s:vimfiler_settings()
    "        " u to go up
    "        nmap <buffer> u <Plug>(vimfiler_switch_to_parent_directory)
    "        " use R to refresh
    "        nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    "        " overwrite C-l ignore <Plug>(vimfiler_redraw_screen)
    "        nmap <buffer> <C-l> <C-w>l
    "        " overwrite C-j ignore <Plug>(vimfiler_switch_to_history_directory)
    "        nmap <buffer> <C-j> <C-w>j
    "    endfunction
    "endfunction

    " vim-fugitive use `autocmd` a lost so cannot be loaded with Lazy
    NeoBundle "tpope/vim-fugitive"

    """""""""""""""""""
    " Editing Support "
    """""""""""""""""""
    NeoBundle 'vim-scripts/Align'

    "NeoBundle 'vim-scripts/YankRing.vim'
    "let yankring_history_file = ".yankring_history"
    "let g:yankring_replace_n_pkey = '<Leader>p'
    "let g:yankring_replace_n_nkey = '<Leader>n'

    " NeoComplete
    if has('lua') && v:version > 703 || (v:version == 703 && has('patch885'))
        NeoBundleLazy "Shougo/neocomplete.vim", {
            \ "autoload": {
            \   "insert": 1,
            \ }}
        let s:hooks = neobundle#get_hooks("neocomplete.vim")
        function! s:hooks.on_source(bundle)
            let g:acp_enableAtStartup = 0
            let g:neocomplete#enable_smart_case = 1
            let g:neocomplete#auto_completion_start_length = 3
            let g:neocomplete#sources#syntax#min_keyword_length = 3
            let g:neocomplete#max_list = 20

            " prevent cursor trigger autopop in insert mode
            let g:neocomplete#enable_insert_char_pre = 1
            " trigger after some time
            "let g:neocomplete#enable_cursor_hold_i = 1

            " <CR>: close popup and save indent.
            inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
            function! s:my_cr_function()
                "return neocomplete#smart_close_popup() . "\<CR>"
                " For no inserting <CR> key.
                return pumvisible() ? neocomplete#close_popup() : "\<CR>"
            endfunction

            " <TAB>: completion.
            inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

            " <C-h>, <BS>: close popup and delete backword char.
            inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y>  neocomplete#close_popup()
            inoremap <expr><C-e>  neocomplete#cancel_popup()

            " Close popup by <Space>.
            "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

            " trigger popup manually
            inoremap <expr><C-f> neocomplete#start_manual_complete()

            " toggle autocomplete mode
            inoremap <C-g> <C-O>:NeoCompleteToggle<CR>
            nnoremap <C-g> :NeoCompleteToggle<CR>

        endfunction
        function! s:hooks.on_post_source(bundle)
            NeoCompleteEnable
        endfunction

    else
        echo "Error: Cannot Load NeoComplete"
        echo "NeoComplete requires Lua support and Vim > 7.3.885"
        echo 'To enable Neocomplete, upgrade and compile Vim with "lua" support'
    endif

    NeoBundleLazy "Shougo/neosnippet.vim", {
            \ "depends": ["honza/vim-snippets"],
            \ "autoload": {
            \   "insert": 1,
            \ }}
    let s:hooks = neobundle#get_hooks("neosnippet.vim")
    function! s:hooks.on_source(bundle)
        " Plugin key-mappings.
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " SuperTab like snippets behavior.
        imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: pumvisible() ? "\<C-n>" : "\<TAB>"
        smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: "\<TAB>"

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " Enable snipMate compatibility feature.
        let g:neosnippet#enable_snipmate_compatibility = 1

        " Tell Neosnippet about the other snippets
        let g:neosnippet#snippets_directory=s:bundle_root . '/vim-snippets/snippets'
    endfunction

    NeoBundle "mattn/emmet-vim", { 'autoload': {
        \ "filetypes": ['html', 'htmldjango']}}

    NeoBundle "terryma/vim-multiple-cursors"

    NeoBundleLazy "sjl/gundo.vim", {
        \ "autoload": {
        \     "commands": ['GundoToggle'],
        \}}
    nnoremap <Leader>z :GundoToggle<CR>

    """""""""""""""
    " Programming "
    """""""""""""""
    NeoBundle 'majutsushi/tagbar', {
        \ "autoload": {
        \     "commands": ['TagbarToggle'],
        \ },
        \ "build": {
        \     "mac": "brew install ctags",
        \ }}
    nnoremap <TAB> :TagbarToggle<CR>
    let g:tagbar_width=32
    let g:tagbar_autofocus=1
    let g:tagbar_compact=1
    let g:tagbar_sort=0

    NeoBundle "scrooloose/syntastic", {
        \ "build": {
        \     "mac": "pip-3.3 install flake8 && npm -g install coffeelint",
        \     "unix": "sudo pip-3.3 install flake8 && sudo npm -g install coffeelint",
        \ }}
    
    " Setting for Python Linter
    let g:syntastic_python_flake8_args="--ignore=E302,W293,W302,W391,W291 --max-complexity 12"
        "W302,W291 trailing whitespace
        "E302 expected 2 blank lines
        "W293 blank line contains whitespace
        "W391 blank line at end of file

    " Setting for C++ Linter
    let g:syntastic_cpp_include_dirs = [
                \ '/usr/local/Cellar/r/3.0.1/R.framework/Headers',
                \ '/usr/local/Cellar/r/3.0.1/R.framework/Resources/library/Rcpp/include',
                \ ]

    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_auto_loc_list=1
    let g:syntastic_loc_list_height=5
    "let g:syntastic_python_checker='pylint' " pylint is heavy
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_mode_map={'mode': 'active',
                         \ 'passive_filetypes': ["tex"] }

    " jQuery
    NeoBundleLazy "jQuery", {'autoload': {
                \ 'filetypes': ['coffee', 'coffeescript', 'javascript', 'html', 'djangohtml'] }}

    " CoffeeScript
    NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload': {
                \ 'filetypes': ['coffee', 'coffeescript'] }}
    " HTML & CSS
    NeoBundleLazy 'mattn/zencoding-vim', {'autoload': {
        \ 'filetypes': ['html', 'djangohtml'] }}

    """"""""""
    " Python "
    """"""""""
    NeoBundleLazy "lambdalisue/vim-django-support", {
        \ "autoload": {
        \     "filetypes": ["python", "python3", "djangohtml"]
        \ }}
    NeoBundleLazy "jmcantrell/vim-virtualenv", {
        \ "autoload": {
        \     "filetypes": ["python", "python3", "djangohtml"]
        \ }}
    "NeoBundleLazy "davidhalter/jedi-vim", {
    "    \ "autoload": {
    "    \     "filetypes": ["python", "python3", "djangohtml"],
    "    \     "build": {
    "    \         "mac": "pip install jedi",
    "    \         "unix": "pip install jedi",
    "    \     }
    "    \ }}
    "let s:hooks = neobundle#get_hooks("jedi-vim")
    "function! s:hooks.on_source(bundle)
    "    let g:jedi#auto_vim_configuration = 0
    "    let g:jedi#popup_select_first = 0
    "    let g:jedi#show_function_definition = 1
    "    let g:jedi#rename_command = '<Leader>r'
    "    let g:jedi#goto_command = '<Leader>g'
    "    let g:jedi#autocompletion_command = "<C-d>"
    "endfunction

    """"""""""
    " Pandoc "
    """"""""""
    NeoBundleLazy "vim-pandoc/vim-pandoc", {
          \ "autoload": {
          \     "filetypes":
          \         ["pandoc", "markdown", "textile"],
          \ }}
    let s:hooks = neobundle#get_hooks("vim-pandoc")
    function! s:hooks.on_source(bundle)
        " let g:pandoc_no_spans = 1
        let g:pandoc_no_empty_implicits = 1
        let g:pandoc_no_folding = 1
    endfunction

    NeoBundleLazy "lambdalisue/shareboard.vim", {
          \ "autoload": {
          \   "commands": ["SbFtPreview", "SbFtCompile", "ShareboardPreview", "ShareboardCompile"],
          \ },
          \ "build": {
          \   "mac": "pip install shareboard",
          \   "unix": "sudo pip install shareboard",
          \ }}
    function GetFileType(...)
        " filetype can be given through argument or guess by file extension
        let ft_tmp = a:0? a:1 : expand("%:e")
        " if no ft_tmp obtained, end with an error
        if ft_tmp == ''
            throw "No filetype found!"
        elseif ft_tmp =~? 'md\|mkd\|markdown'   " uniform markdown file extension
            let forced_ft = "markdown"
        else
            let forced_ft = ft_tmp
        endif
        return forced_ft
    endfunction

    function SbFtPreview(...)
        let ft_tmp =  a:0 ? GetFileType(a:1) : GetFileType()
        let g:shareboard_command = expand('~/.vim/shareboard/command.sh ' . ft_tmp . ' --mathjax')
        ShareboardPreview
    endfunction
    function SbFtCompile(...)
        let ft_tmp =  a:0 ? GetFileType(a:1) : GetFileType()
        let cmd = "!cat % | ~/.vim/shareboard/command.sh " . ft_tmp . ' --mathjax' . " > " . expand("%:r") . ".html &"
        silent! execute cmd
        redraw!
    endfunction
    function SbFtStatic(...)
        let ft_tmp =  a:0 ? GetFileType(a:1) : GetFileType()
        "copy css file
        "let cp_cmd = "!cp ~/.vim/shareboard/css/combined.css " . expand("%:p:h")
        "silent! execute cp_cmd
        let cmd = "!cat % | ~/.vim/shareboard/command.sh " . ft_tmp . ' --self-contained --webtex' . " > " . expand("%:r") . ".static.html"
        silent! execute cmd
        redraw!
    endfunction
    function! s:shareboard_settings()
        nnoremap <buffer>[shareboard] <Nop>
        nmap <buffer><Leader> [shareboard]
        nnoremap <buffer><silent> [shareboard]v :call SbFtPreview()<CR>
        nnoremap <buffer><silent> [shareboard]c :call SbFtCompile()<CR>
        nnoremap <buffer><silent> [shareboard]s :call SbFtStatic()<CR>
    endfunction
    autocmd MyAutoCmd FileType rst,text,pandoc,markdown,textile call s:shareboard_settings()
    let s:hooks = neobundle#get_hooks("shareboard.vim")
    function! s:hooks.on_source(bundle)
        let g:shareboard_use_default_mapping = 0
        if s:is_linux || s:is_darwin
            let g:shareboard_host = "0.0.0.0"
        endif
    endfunction

    """"""""""""""""""""
    " End of NeoBundle "
    """"""""""""""""""""
    " ALL bundles should be inserted BEFORE this line
    NeoBundleCheck " check and install missing bundles
    unlet s:hooks
endif


""""""""""""""""""
" Tab and indent "
""""""""""""""""""

filetype plugin indent on


set expandtab           " Use spaces instead of tabs
set smarttab            " Be smart when using tabs ;)
set shiftwidth=4        " 1 tab == 4 spaces
set tabstop=4

set autoindent          " Auto indent
set smartindent         " Smart indent
set copyindent



"""""""""""""
" Searching "
"""""""""""""
set ignorecase          " Ignore case when searching
set smartcase           " When searching try to be smart about cases
set hlsearch            " Highlight search results
set incsearch           " Makes search act like search in modern browsers
set lazyredraw          " Don't redraw while executing macros (good performance config)
set magic               " For regular expressions turn magic on

cnoremap <expr> /
      \ getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
      \ getcmdtype() == '?' ? '\?' : '?'



""""""""""""""""""
" User Interface "
""""""""""""""""""

set ruler               " always show current position
set number              " show line number
syntax on               " highlight syntax
set laststatus=2        " always display statusline
set mouse=a             " use mouse for navigation
"set showcmd            " show command on statusline
set scrolloff=4                         " minimum line above/below the cursor
set whichwrap+=<,>,[,],b,s,~
set backspace=eol,start,indent          " Configure backspace so it acts as it should act

set linebreak
let &showbreak = '+++ '
set breakat=\ ;:,!?
set cpoptions+=n

set showmatch                       " Show matching brackets when text indicator is over them
set matchpairs& matchpairs+=<:>     " add <>
set matchtime=2                     " How many tenths of a second to blink when matching brackets

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" color theme
set t_Co=256
colorscheme wombat256mod

set nofoldenable                " No folding

set nolist
set listchars=tab:»\ ,trail:␣

set display=lastline    " always show part of the long line

""""""""""""
" Encoding "
""""""""""""

set encoding=utf8               " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac            " Use Unix as the standard file type



"""""""""""""""
" Vim Editing "
"""""""""""""""

set hidden                      " hide buffer insted of closing to prevent Undo history
set switchbuf=useopen           " use opend buffer insted of create new buffer

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nowritebackup
set nobackup
set nowb
set noswapfile

" turn on wild menu
set wildmenu
set wildmode=longest:full
set wildoptions=tagfile

set report=0                    " report for number of lines being changed everytime

set wrap
set textwidth=0                 " never add a newline for some number of chars

" automatically create the directory if it does not exist
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" system clipboard integration
if s:is_darwin
    set clipboard=unnamed
elseif s:is_linux
    set clipboard=unnamedplus
endif



"""""""""""""""""""""""""""""
" Language Specific Setting "
"""""""""""""""""""""""""""""

" Python
autocmd FileType python,python3 setlocal tw=80

" Pandoc (markdown, ...)
autocmd FileType pandoc,markdown setlocal conceallevel=0

" C
autocmd FileType c setlocal conceallevel=0 noexpandtab

" TeX
autocmd FileType tex setlocal conceallevel=0

""""""""""""""""
" GUI settings "
""""""""""""""""

if has('gui_running')

    """"""""
    " Font "
    """"""""
    if has("mac") || has("macunix")
        set gfn=Inconsolata\ for\ Powerline:h18
    elseif has("win16") || has("win32")
        set gfn=Consolas:h18
    elseif has("linux")
        set gfn=Consolas\ 18
        set gfn=Inconsolata\ 18
    endif

    """""""""""""
    " Scrollbar "
    """""""""""""
    " Disable scrollbars
    " (real hackers don't use scrollbars for navigation!)
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L

    """"""""""""""""""
    " User Interface "
    """"""""""""""""""
    if has("gui_running")
        set guitablabel=%M\ %t
    endif

endif
