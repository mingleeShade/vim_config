#!/bin/bash

Init=$1
if [[ $Init == "init" ]];then
    git clone https://github.com/gmarik/Vundle.vim.git vim/bundle/Vundle.vim/
fi

cp -f vimrc ~/.vimrc
cp -rf vim/* ~/.vim
cp -f astylerc ~/.astylerc
