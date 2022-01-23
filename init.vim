" NVIM 配置
" @author: minglee
"
" 使用安装步骤
" 1. 安装 neovim,
"   1.1 命令行安装：
"       $ sudo apt-get install neovim
"   1.2 源码安装(安装指引：https://github.com/neovim/neovim/wiki/Building-Neovim)
"       安装前置软件，具体参看：https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
"       $ git clone https://github.com/neovim/neovim.git
"       $ cd neovim/
"       $ make CMAKE_BUILD_TYPE=RelWithDebInfo
"       $ sudo make install
"
" 2. 拷贝当前文件到 ~/.config/nvim/ 目录下，重新打开 nvim
"
" 3. 安装包管理器：plug.vim (init.vim 生效后再次打开 nvim 自动安装)
"
" 4. 通过 plug.vim 安装 coc.vim (init.vim 生效后再次打开 nvim 自动安装)
"
" 5. (可选) 安装 ctags 和 cscope
"
" 6. 使用 coc-clangd 进行 c++ 补全 (coc-clangd github 地址：https://github.com/clangd/coc-clangd)
"   6.1 通过 coc.vim 安装 coc-clangd (默认已经在 本配置中，init.vim 生效后再次打开 nvim 自动安装)
"   6.2 通过 使用 CocCommand clangd-install 安装最新的 clangd
"   6.3 安装 bear，并通过 "$ bear make -j4" 命令在工程根目录生成 compile_commands.json
"       6.3.1 bear 可以直接通过 "$ apt-get install bear" 安装，也可以通过源码安装，源码地址为：https://github.com/rizsotto/Bear

" 检查plug.vim是否安装下载
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    echo "plug.vim not exist, now download it!"
    :silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"<=========基础设置==========

"----------缩进相关----------
" c风格智能缩进
set cindent
" 缩进长度
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" 详细定制c风格缩进，参见":help cinoptions-values"
" 括号缩进定制
set cino+=(0
" case大括号缩进
set cino+=l1
" C++作用域，public、private等的缩进
set cino+=g0
"----------缩进相关----------

"----------颜色主题----------
" 设置颜色主题
"colorscheme default
" 设置背景颜色
"set background=light

" 语法高亮
syntax on
"----------颜色主题----------

"----------其他----------
" 搜索高亮
set hlsearch
" 搜索时自动显示匹配位置并高亮匹配字符串
set incsearch

" 鼠标设置开启
set mouse=a

" 设置默认不折叠
"set nofoldenable

" 设置状态栏
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%F%=[%{&ff}\ %Y\ %{&fenc}][Line:%l/%L,Column:%c][%p%%]
" 设置何时显示状态栏
set laststatus=2

" 行号
set number
set relativenumber

" 补全菜单显示设置
set completeopt=menu,menuone

" 设置光标上下最少保留的屏幕行数
set scrolloff=5

" 设置不生成交换文件
set noswapfile

" 设置帮助文档默认语言为中文
set helplang=cn

" 设置文件编码
set fileencodings=ucs-bom,utf-8,gbk,big5,gb18030,latin1

" 可以针对特定文件载入查插件文件
filetype plugin on
" 可以针对特定的文件类型载入缩进文件
filetype indent on

" 设置退格键行为：允许自动缩进上退格，允许换行符上退格，允许在插入开始的位置上退格
set backspace=indent,eol,start

" 打开文件类型识别
filetype on

" 设置可显示的隐藏字符$
set list lcs=eol:$,tab:>-,trail:~,extends:>,precedes:<
set nolist
"----------其他----------

"==========基础设置=========>


"<=========扩展功能==========

" 在c语言环境中快捷键显示函数名称
function! ShowFuncName()
    let lnum = line(".")
    let col = col(".")
    echohl ModeMsg
    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
    echohl None
    call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfunction
map ,f :call ShowFuncName() <CR>

" 记住上次打开的位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 长行移动
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" 在插入模式下光标移动
"inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" 设置 诸如 "-- INSERT --" 这样的 'showme' 类型的消息颜色
hi ModeMsg ctermfg=DarkGreen
" 设置搜索模式的高亮
"hi Search  ctermfg=DarkCyan
" 设置弹出菜单选中项的高亮方式
hi PmenuSel ctermbg=green ctermfg=white

" 高亮多余的空格
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd VimEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" 快速输入对应的大括号
inoremap {<CR> {<CR>}<ESC>O

" 跳转快捷键调整
nmap <C-]> g<C-]>

" 鼠标切换快捷键设置
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

" 行号切换快捷键设置
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

"-----------------------美化标签栏-----------------------
" 定义颜色
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
        " 为没有名字的文档设置个名字
        if &buftype == 'quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[No Name]'
        endif
    else
        " 只取文件名
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

" 设置折叠方式为手工折叠，zf70j,可以折叠当前光标之下的70行，
" 使用help fold-manual 查看帮助信息，zo 展开折叠
set foldmethod=manual
" 设置折叠配色
hi Folded guibg=black guifg=grey40 ctermfg=grey ctermbg=darkgrey
hi FoldColumn guibg=black guifg=grey20 ctermfg=4 ctermbg=7
"==========扩展功能=========>


"<=========插件安装==========

call plug#begin('~/.config/nvim/plugged')

" 配色插件
Plug 'theniceboy/vim-deus'

" 代码geshi格式化
Plug 'Chiel92/vim-autoformat'

" 缩进对齐线
Plug 'nathanaelkane/vim-indent-guides'

" 文件目录浏览
Plug 'preservim/nerdtree'

" 补全插件 coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"==========插件安装=========>


"<=========插件设置==========
"----------NERDTree----------
" NERDTree: 目录插件
" 设置忽略的文件
let NERDTreeIgnore=['\.o$', '\.lo$', '\.la$', 'tags', 'cscope.*']

" 自动打开 NERDTree
function! AutoNERDTree()
    NERDTree
endfunction
autocmd VimEnter * call AutoNERDTree()

" 设置 NERDTree 快捷键
map <F6> :NERDTree<CR>
"----------NERDTree----------

"----------cscope----------
" cscope: 文件引用跳转插件
" 增加 cscope 数据库时，给出消息
set nocscopeverbose

" 设置是否使用 quickfix 窗口来线上cscope结果
"set cscopequickfix=s-,c-,d-,i-,t-,e-

" cscope 快捷键设置
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" 设置更新方法
function! UpdateCscope()
    :silent cs kill 0
    ":silent !find . -path ./robot/share/gpb -prune -o -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hpp" > cscope.files
    :silent !find . -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hpp" > cscope.files
    :!cscope -bkq -i cscope.files
    :cs add cscope.out
    :e
endfunction
map <F7> :call UpdateCscope()<CR>
"----------cscope----------

"----------ctags----------
" ctags: 标签跳转插件
" 自动动态更新tags
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
" 暂时不开启自动更新，更新未去重，而且卡
"autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

" 设置tag文件
set tags+=tags
set tags+=~/.tags/cpp/tags "gcc版本库tags文件

" 设置tags生成快捷键
function! SelectTagsFunc()
    if filereadable('.project_vimrc') "判断文件是否存在
        :source .project_vimrc
        :call ProjectGenerateTags()
    else
        :call DefaultGenerateTags()
    endif
    :e
endfunction
" 将此方法拷贝到对应的项目的.project_vimrc中
"function! ProjectGenerateTags()
"    :silent !ctags -R --languages=c++ --c++-kinds=+p --fields=+iaS  --exclude=thirdparty --exclude=unreal --exclude=lib --exclude=.git --exclude=boost --links=no.
"endfunction

function! DefaultGenerateTags()
    :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --links=no .
endfunction

map <F8> :call SelectTagsFunc()<CR>
"----------ctags----------

"----------taglist----------
" taglist: 提供源代码符号的结构化视图
" taglist设置
let Tlist_Exist_OnlyWindow = 1
let Tlist_Show_One_File = 1
" taglist 快捷键
nnoremap <C-l> :TlistToggle<cr>
vnoremap <C-l> :TlistToggle<cr>
"----------taglist----------

"----------fuf----------
" fuf: 提供文件的模糊查找方式
" 设置 fuzzyfinder 快捷键
map ff <esc>:FufFile **/<cr>
map ft <esc>:FufTag<cr>
"map <silent> <c-\> :FufTag! <c-r>=expand('<cword>')<cr><cr>
"----------fuf----------

"----------vim-indent-guides----------
" vim-indent-guides: 在vim中显示缩进线
" 缩进对齐线
"let g:indent_guides_enable_on_vim_startup = 1 "添加行，vim启动时启用
let g:indent_guides_start_level = 1           "添加行，开始显示对齐线的缩进级别
let g:indent_guides_guide_size = 1            "添加行，对齐线的宽度，（1字符）
let g:indent_guides_tab_guides = 0            "添加行，对tab对齐的禁用
"----------vim-indent-guides----------

"----------vim-indent-guides----------
"autoformat: 代码格式化，首先需要安装astyle
let g:formatdef_allman = '"astyle --options=~/.astylerc"'
let g:formaters_cpp = ['allman']
let g:formaters_c = ['allman']
"autocmd BufWritePre *.cpp,*.h,*.c,*.hpp :Autoformat
"----------vim-indent-guides----------

"----------coc----------
" coc: 补全插件
let g:coc_global_extensions = [
	\ 'coc-json',
	\ 'coc-vimlsp',
    \ 'coc-jedi',
    \ 'coc-clangd',
    \ 'coc-highlight',
    \ 'coc-python',
	\ 'coc-marketplace'
    \]

"========
" 使用coc-clangd 进行 c++ 代码补全
" coc-clangd github 网站：https://github.com/clangd/coc-clangd
" coc-clangd 需要 compile_commands.json 文件.
" compile_commands.json 的生成方式可以参考：https://clangd.llvm.org/installation.html#project-setup
" 通常 make 环境下，可以安装 bear 工具，使用诸如："$ bear make -j4" 命令的方式进行生成
"========

" 代码片段补全
"coc-snippets

" 字符集设置
"set encoding=utf-8
" 设置不保存备份文件
set nobackup
set nowritebackup


" TAB触发补全
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 设置主动触发快捷键
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Enter 键自动选中第一个补全项
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 函数跳转快捷键
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" 使用 K 来在预览窗口中显示文档
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" 保持光标不动时，高亮显示符号及其引用(目前不起效果, 先注释)
"autocmd CursorHold * silent call CocActionAsync('highlight')

" 使用 \rn 将符号重命名(目前不起效果，先注释).
"nmap <leader>rn <Plug>(coc-rename)

" 格式化选中的代码(需要lsp语言支持)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" 暂时不知道用途，后面看看
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>aw  <Plug>(coc-codeaction-selected)w
"----------coc----------

"==========插件设置=========>
