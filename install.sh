#!/bin/bash

Param=$1
if [[ $Param == "init" ]];then
    git clone git@github.com:gmarik/Vundle.vim.git vim/bundle/Vundle.vim/
    sudo yum install ctags
fi

if [[ $Param == "clear" ]];then
    rm ~/.vim/ -rf
    rm ~/.vimrc
    rm ~/.astylerc
fi

cp -f vimrc ~/.vimrc
cp -rf vim/* ~/.vim
cp -f astylerc ~/.astylerc
