#!/bin/bash

install_dir=$HOME/bin

mkdir -p "${install_dir}"
# =============================================================================
# INSTALL ZSH

# ============================================================================
# SHELL CONFIGS
cp .my_config $HOME/
source $HOME/.my_config
# Add suplementary config to shell config
[ -w ~/.zshrc ] && {
    #cat .my_config >> $HOME/.zshrc
    echo source $HOME/.my_config >> $HOME/.zshrc
} || {
    #cat .my_config >> $HOME/.bashrc
    echo source $HOME/.my_config >> $HOME/.bashrc
}

# =============================================================================
# INSTALL VIM 
# TODO: check if vim is available, install if needed or build from scratch
./install_vim.sh "${install_dir}" $HOME/anaconda2/bin/python-config

# 1. Download vim-plug, a plugin manager, into $HOME/.vim/autoload
# check if a folder named .vim is already existed in the home dir
[ -w $HOME/.vim ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv $HOME/.vim $HOME/.vim_bk_"${dt}" # rename it with a datetime id
}
# detailed can be found here: https://github.com/junegunn/vim-plug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 2. copy .vimrc from dot folder to home folder
# check if .vimrc is already existed in the home dir
[ -w $HOME/.vimrc ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv $HOME/.vimrc $HOME/.vimrc_bk_"${dt}" # rename it with a datetime id
}

# copy vim config to home folders
cp .vimrc $HOME/
cp -r .vim/colors $HOME/.vim

# install vim plugins
vim +PlugInstall +qall



# ============================================================================
# TMUX CONFIGS
# TODO: check if tmux available, install if needed (or build from source?)
[ -w $HOME/.tmux.conf ] && {
    dt=$(date +"%y%m%d_%H%M%S")
    mv $HOME/.tmux.conf $HOME/.tmux.conf_bk_"${dt}" # rename it with a datetime id
}
# copy my config
cp .tmux.conf $HOME/
cp .tmux.ver $HOME/
cp .tmux.hor $HOME/

# zsh, build from source?
# download from http://www.zsh.org/pub/zsh.tar.gz
# extract it


# bash-it
# oh-my-zsh plugins

# vim 7 8, build from source?

# other node setup with for ssh

#
#
