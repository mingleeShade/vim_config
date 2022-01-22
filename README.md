1.  初次安装，运行./install.sh，会自动检测安装 vim-plug

2.  安装完，第一次打开vim之后，执行:VundleInstall，安装vundle管理的插件

3.  自动格式化需要安装astyle
    可以选择编译安装:https://github.com/timonwong/astyle-mirror，使用具体参考https://github.com/timonwong/astyle-mirror/tree/master/doc/astyle.html
    此外还依赖于autoformat插件（可以由vim-plug），autoformat插件的配置在astylerc文件中

4.  c++库文件补全参考：http://vim.wikia.com/wiki/C++_code_completion

5.  nvim 插件管理：https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
