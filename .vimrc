" auto indent
"set ai
"set smartindent
set cindent
" show line number
set number
" expande tab
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
" no folding code
set nofoldenable
" highlight search
set hlsearch
" enbale syntax highlight
"syntax on
" align function arguments
set cino+=(0
" filter the unwanted files
let NERDTreeIgnore=['\.o$', '\.lo$', '\.la$', 'tags', 'cscope.*']
set cscopequickfix=s-,c-,d-,i-,t-,e-

"colorscheme pencil
"set background=light

set incsearch
set so=5

"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%F%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2
set completeopt=menu,menuone

set helplang=cn

" Ctags
let Tlist_Exist_OnlyWindow = 1
let Tlist_Show_One_File = 1

" auto launch NERDTree
function! AutoNERDTree()
    if 0 == argc()
        NERDTree
    end
endfunction

autocmd VimEnter * call AutoNERDTree()

" auto syntax on"
function! AutoSyntax()
    syntax on
endfunction

if !exists("autocommands_syntax")
    let autocommands_syntax = 1
    autocmd VimEnter * call AutoSyntax()
    autocmd BufReadPre * call AutoSyntax()
endif

function! TestFunc(pos)
    echo "we at " a:pos
    sleep 1
endfunction

"""""""test"""""""
"augroup TestAutoCommand
"    autocmd!
"    autocmd InsertEnter * call TestFunc("insert enter")
"augroup END

"autocmd TestAutoCommand CursorMovedI * call TestFunc("test call")

" ident 2 spaces when doing ruby
"autocmd FileType rb setlocal shiftwidth=2 tabstop=2

" shotcut for taglist
nnoremap <C-l> :TlistToggle<cr>
vnoremap <C-l> :TlistToggle<cr>

" auto update tags
function! UpdateTags()
    " only update the tags when we've created one
    if !filereadable("tags")
        return
    endif

    " use the path relative to pwd
    let _file = expand("%")
    let _cmd = 'ctags --append "' . _file . '"'
    let _ret = system(_cmd)
    unlet _cmd
    unlet _file
    unlet _ret
endfunction

autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

" easy copy to/paste from system clipboard
"nnoremap <C-y> "+y
"vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gp

" show function names in c
function! ShowFuncName()
    let lnum = line(".")
    let col = col(".")
    echohl ModeMsg
    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
    echohl None
    call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfunction
map ,f :call ShowFuncName() <CR>
map <F6> :NERDTree<CR>

" highlight unwanted spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" shotcuts for fuzzyfinder
map ff <esc>:FufFile **/<cr>
map ft <esc>:FufTag<cr>
"map <silent> <c-\> :FufTag! <c-r>=expand('<cword>')<cr><cr>

" hight lines longer than 80 characters
"if exists('+colorcolumn')
"  set colorcolumn=150
"else
"  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>150v.\+', -1)
"endif

" show current function name
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map F :call ShowFuncName() <CR>

" make hjkl movements accessible from insert mode via the <Alt> modifier key
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
" quick input closing bracket
inoremap {<CR> {<CR>}<ESC>O
nmap <C-]> g<C-]>

filetype plugin on
filetype indent on
" gofmt .go source files when they are saved
"autocmd FileType go autocmd BufWritePre <buffer> Fmt

set mouse=a
let mouseFlag = 1
function! SetMouse()
    if g:mouseFlag == 1
        let g:mouseFlag = 0
        set mouse=
        echo "mouse off"
    else
        let g:mouseFlag = 1
        set mouse=a
        echo "mouse on"
    endif
endfunction
map <C-k> :call SetMouse() <CR>

"set tags+=/home/minglee/workspace/lyingdragon_1_5/warcraft/tags
"set tags+=/home/minglee/mobileCode/lyingdragon_1_5/warcraft/tags
set tags+=/usr/include/c++/4.4/tags
set tags+=/usr/include/boost/tags
set tags+=/usr/local/include/redfox/tags
set tags+=tags
"set tags+=/home/minglee/card/warcraft_card/tags
"set tags+=/home/minglee/update_card/warcraft_card/tags
"set tags+=/home/minglee/card/warcraft_card/card_lb/tags

set nocp
map <F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

hi PmenuSel ctermbg=green ctermfg=white

set backspace=indent,eol,start

"Bundle
set nocompatible
filetype off

set rtp+=~/.vim/vundle/
call vundle#rc()

"Bundle 'Valloric/YouCompleteMe'

"YouCompleteMe
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"let g:ycm_key_list_select_completion=['c-n']
"let g:ycm_key_list_select_completion=['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
"let g:ycm_key_list_previous_completion=['<Up>']
"let g:ycm_confirm_extra_conf=0

"let g:ycm_collect_identifiers_from_tags_files=1
"let g:ycm_min_num_of_chars_for_completion=2
"let g:ycm_cache_omnifunc=0
"let g:ycm_seed_identifiers_with_syntax=1

"let g:ycm_complete_in_comments=1
"let g:ycm_complete_in_strings=1
"let g:ycm_collect_identifiers_from_comments_and_strings=0
"let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'

"nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
