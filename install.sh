#!/bin/bash

#检查是系统是debian还是centos
Debian=`lsb_release -d | grep "Debian" | wc -l`
echo IsDebian=${Debian}

Param=$1
if [[ $Param == "init" ]];then
    git clone git@github.com:gmarik/Vundle.vim.git vim/bundle/Vundle.vim/
    if [ Debian -eq 1 ]; then
        sudo apt-get install ctags
    else
        sudo yum install ctags
    fi
fi

if [[ $Param == "clear" ]];then
    rm ~/.vim/ -rf
    rm ~/.vimrc
    rm ~/.astylerc
fi

VimDir=~/.vim/
if [ ! -d $VimDir ]; then
    echo "$VimDir not exists, will be create"
    mkdir $VimDir
else
    echo "$VimDir exists."
fi

cp -f vimrc ~/.vimrc
cp -rf vim/* ~/.vim
cp -f astylerc ~/.astylerc
