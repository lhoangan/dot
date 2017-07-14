#!/bin/bash

# =============================================================================
# INSTALL VIM 
# TODO: check if vim is available, install if needed or build from scratch
./install_vim.sh $HOME/my_pkgs $HOME/anaconda2/bin/python-config

# 1. Download vim-plug, a plugin manager, into ~/.vim/autoload
# check if a folder named .vim is already existed in the home dir
[ -w ~/.vim ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv ~/.vim ~/.vim_bk_"${dt}" # rename it with a datetime id
}
# detailed can be found here: https://github.com/junegunn/vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 2. copy .vimrc from dot folder to home folder
# check if .vimrc is already existed in the home dir
[ -w ~/.vimrc ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv ~/.vimrc ~/.vimrc_bk_"${dt}" # rename it with a datetime id
}

# copy vim config to home folders
cp .vimrc ~/
cp -r .vim/colors ~/.vim

# install vim plugins
vim +PlugInstall +qall


# ============================================================================
# SHELL CONFIGS
# Add suplementary config to shell config
[ -w ~/.zshrc ] && {
    cat .my_config >> ~/.zshrc
} || {
    cat .my_config >> ~/.bashrc
}

# ============================================================================
# TMUX CONFIGS
# TODO: check if tmux available, install if needed (or build from source?)
[ -w ~/.tmux.conf ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv ~/.tmux.conf ~/.tmux.conf_bk_"${dt}" # rename it with a datetime id
}
# copy my config
cp .tmux.conf ~/
cp .tmux.ver ~/
cp .tmux.hor ~/

# zsh, build from source?
# download from http://www.zsh.org/pub/zsh.tar.gz
# extract it


# bash-it
# oh-my-zsh plugins

# vim 7 8, build from source?

# other node setup with for ssh

#
#
