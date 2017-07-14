#!/bin/bash

# =============================================================================
# INSTALL VIM 

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
# Add suplementary config to shell config
[ -w ~/.zshrc] && {
    cat .config >> ~/.zshrc
} || {
    cat .config >> ~/.bashrc
}

# .bashrc and .zshrc
# alias for ssh
# alias for mapping capLock to Escape
# alias for invert screen color. Require installing xcalib
#
# zsh, build from source?
# download from http://www.zsh.org/pub/zsh.tar.gz
# extract it


# bash-it
# oh-my-zsh plugins

# vim 7 8, build from source?

# vim plugin

# alias ssh with ssh -X
# other node setup with for ssh


# change computer caplock to escape

# install tmux? from source?

# setup with some map keys
# plugin for vim: displaying doc title in full, color for insert/normal, git diff
#
# some plugin for vim buffer http://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
#
#
#
