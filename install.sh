#!/bin/bash


# TODO: 目前先以最简单方式进行安装，后续再完善安装脚本  <29-01-22, lihaiming>
Usage()
{
    echo "./run.sh install  # Copy self config to ~/.config/nvim/."
    echo "./run.sh init     # Neovim first install."
    echo "./run.sh clear    # Clear Neovim config."
    echo "./run.sh sync     # Copy ~/.config/nvim/ to self config"
}

mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim
