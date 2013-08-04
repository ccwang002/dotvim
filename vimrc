" vim: foldlevel=0 sts=4 sw=4 smarttab et ai textwidth=0
" adapt settings from sites:
"  * http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
"  * https://github.com/amix/vimrc 
if !&compatible
    " disable vi compatible features
    set nocompatible
endif

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

" set lines of histroy to remember
set history=100

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()



"""""""""""""""
" Key Mapping " 
"""""""""""""""

" use ',' insted of '\' as <Leader>
let mapreader = ','
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
map <leader>ss :setlocal spell!<cr>

"global syntax highlightling
map <c-s> :syntax sync fromstart<cr>



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
    \     "build": {
    \         "windows"   : "make -f make_mingw32.mak",
    \         "cygwin"    : "make -f make_cygwin.mak",
    \         "mac"       : "make -f make_mac.mak",
    \         "unix"      : "make -f make_unix.mak",
    \ }}

    """""""""""""""""""
    " Style / Display "
    """""""""""""""""""
    " color themes
    NeoBundle "michalbachowski/vim-wombat256mod"

    NeoBundle "bling/vim-airline"
    "let g:airline_powerline_fonts = 1
    let g:airline_theme='powerlineish'
   
    NeoBundleLazy "skammer/vim-css-color", {
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
    nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
    nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
    let s:hooks = neobundle#get_hooks("unite.vim")
    function! s:hooks.on_source(bundle)
        " start unite in insert mode
        let g:unite_enable_start_insert = 1
         
        " use vimfiler to open directory
        call unite#custom_default_action("source/bookmark/directory", "vimfiler")
        call unite#custom_default_action("directory", "vimfiler")
        call unite#custom_default_action("directory_mru", "vimfiler")
        autocmd MyAutoCmd FileType unite call s:unite_settings()
        function! s:unite_settings()
            imap <buffer> <Esc><Esc> <Plug>(unite_exit)
            nmap <buffer> <Esc> <Plug>(unite_exit)
            nmap <buffer> <C-n> <Plug>(unite_select_next_line)
            nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
        endfunction
    endfunction

    NeoBundleLazy "Shougo/vimfiler", {
        \ "depends": ["Shougo/unite.vim"],
        \ "autoload": {
        \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
        \   "mappings": ['<Plug>(vimfiler_switch)'],
        \   "explorer": 1,
        \ }}
    nnoremap <C-b> :VimFilerExplorer -winminwidth=25<CR>
    " close vimfiler automatically when there are only vimfiler open
    autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
    let s:hooks = neobundle#get_hooks("vimfiler")
    function! s:hooks.on_source(bundle)
        let g:vimfiler_as_default_explorer = 1
        let g:vimfiler_enable_auto_cd = 1
        let g:vimfiler_force_overwrite_statusline=0 
        let g:vimfiler_explorer_columns="size"

        " ignore swap, backup, temporary files
        let g:vimfiler_ignore_pattern = '^\(.git\|.DS_Store\|\.\|.*\.pyc\)$'
        " Like Textmate icons.
        let g:vimfiler_tree_leaf_icon = ' '
        let g:vimfiler_tree_opened_icon = '▾'
        let g:vimfiler_tree_closed_icon = '▸'
        let g:vimfiler_file_icon = '-'
        let g:vimfiler_marked_file_icon = '*'
    
        " vimfiler specific key mappings
        autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
        function! s:vimfiler_settings()
            " u to go up
            nmap <buffer> u <Plug>(vimfiler_switch_to_parent_directory)
            " use R to refresh
            nmap <buffer> R <Plug>(vimfiler_redraw_screen)
            " overwrite C-l ignore <Plug>(vimfiler_redraw_screen)
            nmap <buffer> <C-l> <C-w>l
            " overwrite C-j ignore <Plug>(vimfiler_switch_to_history_directory)
            nmap <buffer> <C-j> <C-w>j
        endfunction
    endfunction

    " vim-fugitive use `autocmd` a lost so cannot be loaded with Lazy
    NeoBundle "tpope/vim-fugitive"

    """""""""""""""""""
    " Editing Support "
    """""""""""""""""""
    NeoBundle 'vim-scripts/Align'

    NeoBundle 'vim-scripts/YankRing.vim'
    let s:hooks = neobundle#get_hooks("YankRing.vim")
    function! s:hooks.on_source(bundle)
        let yankring_history_file = ".yankring_history"
    endfunction

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

        endfunction
        function! s:hooks.on_post_source(bundle)
            NeoCompleteEnable
        endfunction

    else
        echo "Error: Cannot Load NeoComplete"
        echo "NeoComplete requires Lua support and VIM > 7.3.885"
        echo 'To enable Neocomplete, recompile Vim with "lua" support'
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

    NeoBundleLazy "sjl/gundo.vim", {
        \ "autoload": {
        \   "commands": ['GundoToggle'],
        \}}
    let s:hooks = neobundle#get_hooks('gundo.vim')
    function! s:hooks.on_post_source(bundle)
        nnoremap <c-g> :GundoToggle<CR>
    endfunction

    """""""""""""""
    " Programming "
    """""""""""""""

    " NeoBundle: install missing plugins
    " all bundles should be inserted before this line
    NeoBundleCheck

    unlet s:hooks
endif


""""""""""""""""""
" Tab and indent "
""""""""""""""""""

filetype plugin indent on

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines



"""""""""""""
" Searching "
"""""""""""""

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

cnoremap <expr> /
      \ getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
      \ getcmdtype() == '?' ? '\?' : '?'



""""""""""""""""""
" User Interface "
""""""""""""""""""

" turn on wild menu
set wildmenu 

" always show current position
set ruler

" show line number
set number 

" use mouse for navigation
set mouse=a

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" color theme
colorscheme wombat256mod


set laststatus=2                    " always display statusline
