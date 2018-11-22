" auto indent
"set ai
"set smartindent
set cindent
" show line number
set number
" expande tab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" no folding code
"set nofoldenable
" highlight search
set hlsearch
" enbale syntax highlight
"syntax on
" align function arguments
set cino+=(0
" filter the unwanted files
let NERDTreeIgnore=['\.o$', '\.lo$', '\.la$', 'tags', 'cscope.*']

if v:version >= 704
	set relativenumber
endif

"中文乱码
set fileencodings=ucs-bom,utf-8,gbk,big5,gb18030,latin1

" cscope
"set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocscopeverbose
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
function! UpdateCscope()
    :silent cs kill 0
    ":silent !find . -path ./robot/share/gpb -prune -o -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hpp" > cscope.files
    :silent !find . -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hpp" > cscope.files
    :silent !cscope -bkq -i cscope.files
    :silent cs add cscope.out
    :e
endfunction
map <F7> :call UpdateCscope()<CR>

"colorscheme default
"set background=light

set incsearch
set so=5

"设置不生成交换文件
set noswapfile

hi ModeMsg ctermfg=DarkGreen
"hi Search  ctermfg=DarkCyan

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
    syntax enable
endfunction

if !exists("autocommands_syntax")
    let autocommands_syntax = 1
    autocmd VimEnter * call AutoSyntax()
    autocmd BufReadPre * call AutoSyntax()
endif

function! TestFunc()
    if exists(':!astyle')
        echo 'exists astyle'
    else
        echo 'not exists astyle'
    endif
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

"autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

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
"map F :call ShowFuncName() <CR>

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

"在插入模式下光标移动
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"在命令行模式下光标移动
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
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

set tags+=tags
set tags+=~/.tags/cpp/tags "gcc版本库tags文件

set nocp
map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

hi PmenuSel ctermbg=green ctermfg=white

set backspace=indent,eol,start

"Bundle
set nocompatible
filetype off

"插件管理工具
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Chiel92/vim-autoformat'
call vundle#end()

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


"autoformat插件，代码格式化，需要安装首先需要安装astyle
let g:formatdef_allman = '"astyle --options=~/.astylerc"'
let g:formaters_cpp = ['allman']
let g:formaters_c = ['allman']
autocmd BufWritePre *.cpp,*.h,*.c,*.hpp :Autoformat

" OmniCppComplete
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

"-----------------------美化标签栏-----------------------
"定义颜色
hi SelectTabLine term=Bold cterm=Bold gui=Bold ctermbg=None
hi SelectPageNum cterm=None ctermfg=Red ctermbg=None
hi SelectWindowsNum cterm=None ctermfg=DarkCyan ctermbg=None

hi NormalTabLine cterm=Underline ctermfg=Black ctermbg=LightGray
hi NormalPageNum cterm=Underline ctermfg=DarkRed ctermbg=LightGray
hi NormalWindowsNum cterm=Underline ctermfg=DarkMagenta ctermbg=LightGray

function! MyTabLabel(n)
    let label = ''
    let buflist = tabpagebuflist(a:n)
    for bufnr in buflist
        if getbufvar(bufnr, "&modified")
            let label = '+'
            break
        endif
    endfor

    let winnr = tabpagewinnr(a:n)
    let name = bufname(buflist[winnr - 1])
    if name == ''
        "为没有名字的文档设置个名字
        if &buftype == 'quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[No Name]'
        endif
    else
        "只取文件名
        let name = fnamemodify(name, ':t')
    endif

    let label .= name
    return label
endfunction

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " 选择高亮
        let hlTab = ''
        let select = 0
        if i + 1 == tabpagenr()
            let hlTab = '%#SelectTabLine#'
            " 设置标签页号 (用于鼠标点击)
            let s .= hlTab . "[%#SelectPageNum#%T" . (i + 1) . hlTab
            let select = 1
        else
            let hlTab = '%#NormalTabLine#'
            " 设置标签页号 (用于鼠标点击)
            let s .= hlTab . "[%#NormalPageNum#%T" . (i + 1) . hlTab
        endif

        " MyTabLabel() 提供标签
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '

        "追加窗口数量
        let wincount = tabpagewinnr(i + 1, '$')
        if wincount > 1
            if select == 1
                let s .= "%#SelectWindowsNum#" . wincount
            else
                let s .= "%#NormalWindowsNum#" . wincount
            endif
        endif
        let s .= hlTab . "]"
    endfor

    " 最后一个标签页之后用 TabLineFill 填充并复位标签页号
    let s .= '%#TabLineFill#%T'

    " 右对齐用于关闭当前标签页的标签
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction
set tabline=%!MyTabLine()
