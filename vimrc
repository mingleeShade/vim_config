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
    :!cscope -bkq -i cscope.files
    :cs add cscope.out
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
set statusline=%F%=[%{&ff}\ %Y\ %{&fenc}][Line:%l/%L,Column:%c][%p%%]
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
autocmd VimEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

function! DebugPring(str)
"    echo a:str
"    sleep 1
endfunction

autocmd VimEnter * call DebugPring("VimEnter")
autocmd BufNewFile * call DebugPring("BufNewFile")
autocmd BufRead * call DebugPring("BufRead")
autocmd BufWrite * call DebugPring("BufWrite")
autocmd BufWinEnter * call DebugPring("BufWinEnter")
autocmd BufWinLeave * call DebugPring("BufWinLeave")
autocmd InsertEnter * call DebugPring("InsertEnter")
autocmd InsertLeave * call DebugPring("InsertLeave")
autocmd VimLeavePre * call DebugPring("VimLeavePre")
"记住上次打开的位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

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
"inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"在命令行模式下光标移动
"cnoremap <C-h> <Left>
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

let numFlag = 1
function! SetNum()
    if g:numFlag == 1
        let g:numFlag = 0
        set nonu
        set norelativenumber
        echo "number of line off"
    else
        let g:numFlag = 1
        set nu
        set relativenumber
        echo "number of line on"
    endif
endfunction
map <C-n> :call SetNum() <CR>

set tags+=tags
set tags+=~/.tags/cpp/tags "gcc版本库tags文件

set nocp
function! SelectTagsFunc()
    if filereadable('.project_vimrc') "判断文件是否存在
        :source .project_vimrc
        :call ProjectGenerateTags()
    else
        :call DefaultGenerateTags()
    endif
    ":silent !ctags --langdef=MYLUA --langmap=MYLUA:.lua --regex-MYLUA="/^.*\s*function\s*(\w+):(\w+).*$/\2/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*[0-9]+.*$/\1/e/" --regex-MYLUA="/^.*\s*function\s*(\w+)\.(\w+).*$/\2/f/" --regex-MYLUA="/^.*\s*function\s*(\w+)\s*\(.*$/\1/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*\{.*$/\1/e/" --regex-MYLUA="/^\s*module\s+\"(\w+)\".*$/\1/m,module/" --regex-MYLUA="/^\s*module\s+\"[a-zA-Z0-9._]+\.(\w+)\".*$/\1/m,module/" --languages=MYLUA --excmd=number -R -o luatags .
    ":silent !cat luatags >> tags
    ":silent !rm -f luatags
    :e
endfunction

"将此方法拷贝到对应的项目的.project_vimrc中
"function! ProjectGenerateTags()
"    :silent !ctags -R --languages=c++ --c++-kinds=+p --fields=+iaS  --exclude=thirdparty --exclude=unreal --exclude=lib --exclude=.git --exclude=boost --links=no.
"endfunction

function! DefaultGenerateTags()
    :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --links=no .
endfunction
map <F8> :call SelectTagsFunc()<CR>

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
Plugin 'tpope/vim-fugitive'
Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'chrisbra/csv.vim'
call vundle#end()


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


"autoformat插件，代码格式化，首先需要安装astyle
let g:formatdef_allman = '"astyle --options=~/.astylerc"'
let g:formaters_cpp = ['allman']
let g:formaters_c = ['allman']
"autocmd BufWritePre *.cpp,*.h,*.c,*.hpp :Autoformat

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

"highlight ErrorLog ctermfg=Red ctermbg=None guifg=Red guibg=None
"highlight WarnLog ctermfg=Yellow ctermbg=None guifg=Yellow guibg=None
"match ErrorLog /^\[ERROR.*$/
"match WarnLog /^\[WARN.*$/
"autocmd BufWinEnter *.log* match ErrorLog /^\[ERROR.*$/
"autocmd VimEnter *.log* match ErrorLog /^\[ERROR.*$/
"autocmd BufRead *.log* match ErrorLog /^\[ERROR.*$/
"autocmd InsertEnter *.log* match ErrorLog /^\[ERROR.*$/
"autocmd InsertLeave *.log* match ErrorLog /^\[ERROR.*$/
"autocmd BufWinEnter *.log* match WarnLog /^\[WARN.*$/
"autocmd VimEnter *.log* match WarnLog /^\[WARN.*$/
"autocmd BufRead *.log* match WarnLog /^\[WARN.*$/
"autocmd InsertEnter *.log* match WarnLog /^\[WARN.*$/

"缩进对齐线
"let g:indent_guides_enable_on_vim_startup = 1 "添加行，vim启动时启用
let g:indent_guides_start_level = 1           "添加行，开始显示对齐线的缩进级别
let g:indent_guides_guide_size = 1            "添加行，对齐线的宽度，（1字符）
let g:indent_guides_tab_guides = 0            "添加行，对tab对齐的禁用

"设置可显示的隐藏字符$
set list lcs=eol:$,tab:>-,trail:~,extends:>,precedes:<
set nolist

"设置折叠方式为手工折叠，zf70j,可以折叠当前光标之下的70行，使用help fold-manual 查看帮助信息，zo 展开折叠
set foldmethod=manual
"设置折叠配色
hi Folded guibg=black guifg=grey40 ctermfg=grey ctermbg=darkgrey
hi FoldColumn guibg=black guifg=grey20 ctermfg=4 ctermbg=7

