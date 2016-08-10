" vim: foldlevel=0 sts=4 sw=4 smarttab et ai textwidth=0
" adapt settings from sites:
"  * http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
"  * https://github.com/amix/vimrc

" skip initialization for vim-tiny or vim-small
if !1 | finish | endif

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux = !s:is_windows && !s:is_cygwin && !s:is_darwin

if !s:is_windows
    " using bash shell (considering fish is not POSIX-compatible)
    if &shell =~# 'fish$'
        set shell=/bin/bash
    endif
endif

if s:is_windows
    let s:config_root = expand('~/vimfiles')
else
    let s:config_root = expand('~/.vim')
endif
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
if s:is_windows
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif



"""""""""""""""
" Key Mapping "
"""""""""""""""

" use ',' instead of '\' as <Leader>
let mapleader = ','
let maplocalleader = ','
let g:mapleader = ','

" remove highlight with pressing ESC twice or <leader><cr>
nmap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
nmap <silent> <Leader><cr> :noh<cr>

" Remap VIM 0 to first non-blank character
" map 0 ^

" Makke easier movement between display lines
nnoremap j      gj
nnoremap <Down> g<Down>
nnoremap k      gk
nnoremap <Up>   g<Up>
" Restore the original function of , and <Tab>
nnoremap <Leader>, ,
nnoremap <Leader><Tab> <Tab>
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

" trim trailing white spaces
nnoremap <leader>dw :call DeleteTrailingWS()<CR>


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
        " disable vi compatible features
        set nocompatible
    endif
    call neobundle#begin(s:bundle_root)

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

    NeoBundle "vim-airline/vim-airline"
    NeoBundle "vim-airline/vim-airline-themes"
    let g:airline_theme = 'powerlineish'


    """"""""""""""""""""""""""
    " Syntax / Indent / Omni "
    """"""""""""""""""""""""""
    " Collection of languange packs for Vim
    NeoBundle "sheerun/vim-polyglot"
    let g:polyglot_disabled = ['css', 'tex', 'plaintex']

    " syntax for CSS3
    NeoBundleLazy 'hail2u/vim-css3-syntax', {
        \ 'on_ft': ['css'] }

    NeoBundleLazy "ap/vim-css-color", {
        \ 'on_ft': [
        \       'html', 'djangohtml',
        \       'css', 'stylus', 'less', 'scss',
        \       'javascript', 'coffee', 'coffeescript'
        \ ] }

    " syntax for Rust
    NeoBundleLazy 'rust-lang/rust.vim', {
        \ 'on_ft': [
        \       'rust',
        \ ] }


    """""""""""""""""""
    " File Management "
    """""""""""""""""""
    NeoBundleLazy "Shougo/unite.vim", {
        \ "on_cmd": ['Unite', 'UniteWithBufferDir'] }

    NeoBundle 'Shougo/unite-outline'

    NeoBundle 'Shougo/neomru.vim'
    nnoremap [unite] <Nop>
    nmap U [unite]
    nmap <Leader>u [unite]
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
    nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
    nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
    nnoremap <silent> [unite]h :<C-u>Unite history/yank<CR>
    nnoremap <silent> [unite]j :<C-u>Unite jump<CR>
    nnoremap <silent> [unite]k :<C-u>Unite mapping<CR>
    nnoremap <silent> [unite]m :<C-u>Unite neomru/file neomru/directory<CR>
    nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
    nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
    let s:hooks = neobundle#get_hooks("unite.vim")
    function! s:hooks.on_source(bundle)
        " start unite in insert mode
        let g:unite_enable_start_insert = 1

        " To track long mru history.
        let g:neomru#file_mru_limit = 3000
        let g:neomru#directory_mru_limit = 3000

        " Time to update MRU list (now for evey half minute)
        let g:neomru#update_interval = 30

        " Enable yank history
        let g:unite_source_history_yank_enable = 1

        " Unite grep setting
        let g:unite_source_grep_max_candidates = 200
        if executable('ag')
            " Use ag in unite grep source.
            let g:unite_source_grep_command = 'ag'
            let g:unite_source_grep_default_opts =
                        \ '-i --vimgrep --hidden --ignore ' .
                        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
            let g:unite_source_grep_recursive_opt = ''
        elseif executable('pt')
            " Use pt in unite grep source.
            " https://github.com/monochromegane/the_platinum_searcher
            let g:unite_source_grep_command = 'pt'
            let g:unite_source_grep_default_opts = '--nogroup --nocolor'
            let g:unite_source_grep_recursive_opt = ''
        elseif executable('ack-grep')
            " Use ack in unite grep source.
            let g:unite_source_grep_command = 'ack-grep'
            let g:unite_source_grep_default_opts =
                        \ '-i --no-heading --no-color -k -H'
            let g:unite_source_grep_recursive_opt = ''
        endif

        autocmd MyAutoCmd FileType unite call s:unite_settings()
        function! s:unite_settings()
            imap <buffer> <Esc><Esc> <Plug>(unite_exit)
            nmap <buffer> <Esc> <Plug>(unite_exit)
            nmap <buffer> <C-n> <Plug>(unite_select_next_line)
            nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
        endfunction
    endfunction

    " Vimfiler
    NeoBundleLazy 'Shougo/vimfiler.vim', {
        \ 'on_cmd': ['VimFilerBufferDir']
        \ }
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_tree_leaf_icon = ' '
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
    let g:vimfiler_file_icon = '-'
    let g:vimfiler_marked_file_icon = '*'
    nnoremap <Leader>b :VimFilerBufferDir -explorer<CR>
    nnoremap <Leader>f :VimFilerBufferDir<CR>
    nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
    " Use mouse to open file
    autocmd MyAutoCmd FileType vimfiler
                \ nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_edit_file)
    " Open selected files in tab
    autocmd MyAutoCmd FileType vimfiler
                \ nnoremap <silent><buffer><expr> gt vimfiler#do_action('tabopen')
    " Auto exit if no other buffer left
    "autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') |
    "            \ q | endif


    """""""""""""""""""
    " Editing Support "
    """""""""""""""""""
    " General FileType setting by EditorConfig
    NeoBundle 'editorconfig/editorconfig-vim'

    " For better wrapping
    NeoBundle 'vim-jp/autofmt'

    " For text/code alignment
    NeoBundleLazy 'junegunn/vim-easy-align', {
            \ 'on_map': '<Plug>(EasyAlign)',
            \ 'on_cmd': ['EasyAlign', 'LiveEasyAlign'],
            \ }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    " NeoComplete requires Vim 7.3.885 or above and lua suppor
    NeoBundleLazy 'Shougo/neocomplete.vim', {
        \ 'depends' : 'Shougo/context_filetype.vim',
        \ 'disabled' : !has('lua'),
        \ 'vim_version' : '7.3.885',
        \ 'on_i': 1,
        \ }
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

        " Settings with clang_complete
        if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns.c =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
        let g:neocomplete#force_omni_input_patterns.cpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
        let g:neocomplete#force_omni_input_patterns.objc =
              \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
        let g:neocomplete#force_omni_input_patterns.objcpp =
              \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

        " Settings with vimtex_complete
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns.tex =
                    \ '\v\\%('
                    \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                    \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
                    \ . '|hyperref\s*\[[^]]*'
                    \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                    \ . '|%(include%(only)?|input)\s*\{[^}]*'
                    \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                    \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
                    \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
                    \ . ')'
    endfunction
    function! s:hooks.on_post_source(bundle)
        NeoCompleteEnable
    endfunction

    NeoBundleLazy "Shougo/neosnippet.vim", {
            \ "depends": ["Shougo/neosnippet-snippets", "honza/vim-snippets"],
            \ "on_i": 1
            \ }
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
        let g:neosnippet#snippets_directory = s:bundle_root . '/vim-snippets/snippets'
    endfunction

    " HTML & CSS
    NeoBundleLazy "mattn/emmet-vim", { 'on_ft': ['html', 'htmldjango'] }

    " Multi-cursor editing
    NeoBundleLazy "terryma/vim-multiple-cursors", { 'on_i': 1 }

    " History
    NeoBundleLazy 'mbbill/undotree', { 'on_cmd': ['UndotreeToggle'] }
    nnoremap <Leader>z :UndotreeToggle<CR>

    " Folding
    NeoBundle 'Konfekt/FastFold'
    let g:fastfold_savehook = 1
    let g:fastfold_fold_command_suffixes = []

    " Tex/LaTeX
    NeoBundleLazy "lervag/vimtex", { 'on_ft': ['tex', 'plaintex'] }
    let s:hooks = neobundle#get_hooks("vimtex")
    function! s:hooks.on_source(bundle)
        let g:vimtex_latexmk_enable = 0
    endfunction

    " Snakemake
    NeoBundle "ccwang002/vim-snakemake"


    """""""""""""""
    " Programming "
    """""""""""""""
    NeoBundleLazy 'majutsushi/tagbar', {
        \ 'on_cmd': ['TagbarToggle'] }
    nnoremap <TAB> :TagbarToggle<CR>
    let g:tagbar_width=32
    let g:tagbar_autofocus=1
    let g:tagbar_compact=1
    let g:tagbar_sort=0


    " Linter for various languages
    NeoBundleLazy "scrooloose/syntastic", {
        \ 'on_i': 1,
        \ }
    let s:hooks = neobundle#get_hooks("syntastic")
    function! s:hooks.on_source(bundle)
        " Setting for Python Linter
        let g:syntastic_python_checkers = ['flake8']
        let g:syntastic_python_flake8_args =
                    \ "--ignore=E302,E402,W293,W302,W391,W291" .
                    \ "--max-complexity=12"
            "W302,W291 trailing whitespace
            "E302 expected 2 blank lines
            "E402 module level import not at top of file
            "W293 blank line contains whitespace
            "W391 blank line at end of file

        " Setting for C Linter
        let g:syntastic_c_compiler = 'clang'
        let g:syntastic_c_compiler_options = '-std=c99'

        " Setting for C++ Linter
        let g:syntastic_cpp_compiler = 'clang++'
        let g:syntastic_cpp_compiler_options = '-std=c++11'

        " Setting for HTML(5) Linter
        " Use tidy-html5
        let g:syntastic_html_tidy_exec='/usr/local/bin/tidy'
        let g:syntastic_html_tidy_ignore_errors = [
                    \ "<style> isn't allowed in <section>",
                    \ "trimming empty <div>",
                    \ "trimming empty <span>",
                    \ ]
        let g:syntastic_html_tidy_blocklevel_tags = [
                    \ "svg",
                    \ ]
        let g:syntastic_html_tidy_inline_tags = [
                    \ "rect",
                    \ ]

        let g:syntastic_javascript_checkers = ['eslint']

        " Setting for rst Linter
        let s:rst_accepted_dir_type =
                    \ '\(' .
                    \ 'index\|glossary\|' .
                    \ 'seealso\|todo\|toctree\|' .
                    \ 'literalinclude\|' .
                    \ 'auto.*' .
                    \ '\)'
        let s:rst_accepted_text_role =
                    \ '\(ref\|term\|command\|file\|py:[a-z]*\|meth\|class\|func\)'
        let s:rst_def_substitution = '\(version\|today\)'
        let g:syntastic_rst_rst2pseudoxml_quiet_messages = {
                    \ "regex":
                    \ '\(' .
                    \ 'Unknown directive type "' . s:rst_accepted_dir_type . '"\|' .
                    \ 'Unknown interpreted text role "' . s:rst_accepted_text_role . '"\|' .
                    \ 'Undefined substitution referenced: "' . s:rst_def_substitution . '"' .
                    \ '\)',
                    \ }

        let g:syntastic_auto_loc_list = 1
        let g:syntastic_loc_list_height = 5
        let g:syntastic_mode_map = {
                    \ 'mode': 'active',
                    \ 'passive_filetypes': ["tex"] }

        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
    endfunction


    """"""""""""""""""""
    " End of NeoBundle "
    """"""""""""""""""""
    call neobundle#end()
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


"""""""""""
" Folding "
"""""""""""
nnoremap <leader>zt zfat


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


""""""""""""
" Encoding "
""""""""""""
set encoding=utf8               " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac            " Use Unix as the standard file type


""""""""""""""""""
" User Interface "
""""""""""""""""""
set ruler               " always show current position
set number              " show line number
syntax on               " highlight syntax
set laststatus=2        " always display statusline
set mouse=a             " use mouse for navigation
" Newer xterm  knows the extended mouse mode, including tmux, screen
set ttymouse=xterm2
set scrolloff=0                         " minimum line above/below the cursor
set whichwrap+=<,>,[,],b,s,~
set backspace=eol,start,indent          " Configure backspace so it acts as it should act

set linebreak
let &showbreak = '+++ '
set breakat=\ ;:,!?
set cpoptions+=n                " use linenumber column for wrapping
set report=0                    " report for number of lines being changed everytime
set wrap                        " turn up wrapping
set textwidth=0                 " never add a newline for some number of chars
set formatoptions+=j            " make joining comments easier
set formatexpr=autofmt#japanese#formatexpr()

set showmatch                       " Show matching brackets when text indicator is over them
set matchpairs& matchpairs+=<:>     " add <>
set matchtime=2                     " How many tenths of a second to blink when matching brackets

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" color theme
set t_Co=256
set t_ut=
colorscheme wombat256mod

set nolist
set listchars=tab:»\ ,trail:·
set display=lastline    " always show part of the long line


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

" system clipboard integration
if s:is_darwin
    if $TMUX == ''
        set clipboard=unnamed
    endif
elseif s:is_linux
    set clipboard=unnamedplus
elseif s:is_windows
    set clipboard=unnamed
endif


"""""""""""""""""""""""""""""
" Language Specific Setting "
"""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTag

" Python
autocmd FileType python,python3
    \ setlocal tw=80 omnifunc=pythoncomplete#Complete completeopt-=preview
autocmd MyAutoCmd BufWrite *.py :call DeleteTrailingWS()

" Pandoc (markdown, ...)
autocmd FileType pandoc,markdown setlocal conceallevel=0

" C
autocmd FileType c setlocal conceallevel=0 noexpandtab

" TeX
" By default detect .tex files as LaTeX files
let g:tex_flavor = "latex"
autocmd FileType tex,plaintex setlocal conceallevel=0
" Use vimtex's TOC for outline
autocmd FileType tex,plaintex nnoremap <buffer> [unite]O :<C-u>Unite vimtex_toc<CR>
autocmd FileType tex,plaintex nnoremap <buffer> [unite]l :<C-u>Unite vimtex_labels<CR>
let g:tagbar_type_tex = {
    \ 'ctagstype' : 'latex',
    \ 'kinds'     : [
        \ 's:sections',
        \ 'e:needcheck + todo:0:0',
        \ 'g:graphics:1:0',
        \ 'l:labels:1:0',
        \ 'r:refs:1:0',
        \ 'p:pagerefs:1:0'
    \ ],
    \ 'sort'      : 0,
\ }

" HTML
function! GetHTMLFold(lnum)
    let n = a:lnum
    if getline(n) =~? '\v\<section'
        return '1'
    elseif getline(n) =~? '\v\<style'
        return 'a1'
    elseif getline(n-1) =~? '\v(\<\/style\>\<\/section\>)|(\<\/section\>)'
        return '0'
    elseif getline(n) =~? '\v\<\/style\>'
        return 's1'
    endif
    return '='
endfunction

autocmd FileType html,htmldjango
    \ setlocal foldmethod=expr foldexpr=GetHTMLFold(v:lnum) ts=2 sw=2
    \ omnifunc=htmlcomplete#CompleteTags

" Coffeescript
autocmd MyAutoCmd BufWrite *.coffee :call DeleteTrailingWS()



""""""""""""""""
" GUI settings "
""""""""""""""""

" Transparency in MacVim
function! ToggleGuiTransp()
    if &transparency > 0
        let g:current_gui_transp = &transparency
        set transparency=0
    else
        let &transparency=g:current_gui_transp
    endif
endfunction

if has('gui_running')
    if s:is_darwin
        set gfn=Inconsolata:h18
        let g:current_gui_transp=20
        call ToggleGuiTransp()
        nmap <D-u> :call ToggleGuiTransp()<CR>
    elseif s:is_windows
        set guifont=Inconsolata_for_Powerline:h16
        set guifontwide=MS_Gothic:h16
        if has('kaoriya')
            set ambiwidth=auto
        endif
        " Hide menu and toolbar
        set guioptions-=m
        set guioptions-=T
    elseif has("gui_gtk2")
        set guifont=Inconsolata\ for\ Powerline\ 16
        set guioptions-=m
        set guioptions-=T
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
