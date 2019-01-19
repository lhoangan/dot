#!/bin/bash

# useful utility:
# sudo apt-get install git diffcolor, tree

install_dir=${HOME}/bin
anaconda=${HOME}/anaconda2

mkdir -p "${install_dir}"
# =============================================================================
# INSTALL BASH_IT
#./install_bashit.sh

# ============================================================================
# SHELL CONFIGS
[ -w ${HOME}/.myconfig ] && {
    bk=.myconfig_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .myconfig file. Backing up to '${bk}
    mv -v ${HOME}/.my_config ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .myconfig'
ln -sf ${PWD}/.myconfig ${HOME}/

#-------------------------------------------------------------------------------  
# Add supplementary config to shell config
[ -w ${HOME}/.bashrc ] && {
    bk=.bashrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .bashrc file. Backing up to '${bk}
    mv -v ${HOME}/.bashrc ${HOME}/${bk} # rename it with a datetime id
}

echo 'Creating new .bashrc'
cp -v .bashrc ${HOME}
echo source ${HOME}/.myconfig >> ${HOME}/.bashrc

#-------------------------------------------------------------------------------  
# link .inputrc to ${HOME}
[ -w ${HOME}/.inputrc ] && {
    bk=.inputrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .inputrc file. Backing up to '${bk}
    mv -v ${HOME}/.inputrc ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .inputrc'
ln -sf ${PWD}/.inputrc ${HOME}/

#-------------------------------------------------------------------------------  
# link .dircolors to ${HOME}
[ -w ${HOME}/.dircolors ] && {
    bk=.dircolors_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .dircolors file. Backing up to '${bk}
    mv -v ${HOME}/.dircolors ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .dircolors'
ln -sf ${PWD}/.dircolors ${HOME}/

#-------------------------------------------------------------------------------  
# link .myprompt to ${HOME}
[ -w ${HOME}/.myprompt ] && {
    bk=.myprompt_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .myprompt file. Backing up to '${bk}
    mv -v ${HOME}/.myprompt ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .myprompt'
ln -sf ${PWD}/.myprompt ${HOME}/
echo source ${HOME}/.myprompt >> ${HOME}/.bashrc

# =============================================================================
# INSTALL VIM

# check if anaconda is available in /home/anaconda2
if [ ! -d ${anaconda} ]; then
    echo "CANNOT FIND "${anaconda}". Install ANACONDA into "$(dirname ${HOME})" and try again"
    exit
fi


# TODO: check if vim is available, install if needed or build from scratch
echo 'INSTALL VIM.....'
./install_vim.sh "${install_dir}" ${anaconda}/bin/python-config ${anaconda}/lib

# 1. Download vim-plug, a plugin manager, into ${HOME}/.vim/autoload
# check if a folder named .vim is already existed in the home dir
[ -w ${HOME}/.vim ] && {
    bk=.vim_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .vim directory. Backing up to '${bk}
    mv -v ${HOME}/.vim ${HOME}/${bk} # rename it with a datetime id
}
# detailed can be found here: https://github.com/junegunn/vim-plug
curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 2. copy .vimrc from dot folder to home folder
# copy vim config to home folders
[ -w ${HOME}/.vimrc ] && {
    bk=.vimrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .vimrc file. Backing up to '${bk}
    mv -v ${HOME}/.vimrc ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .vim and .vimrc to '${HOME}
ln -sf ${PWD}/.vimrc ${HOME}/
cp -vr .vim/colors ${HOME}/.vim
cp -vb PaperColor.vim ${HOME}/.vim/colors/

# install vim plugins
vim +PlugInstall +qall


# ============================================================================
# TMUX CONFIGS
# TODO: check if tmux available, install if needed (or build from source?)
[ -w ${HOME}/.tmux.conf ] && {
    bk=.tmux.conf_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .tmux.conf file. Backing up to '${bk}
    mv -v ${HOME}/.tmux.conf ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .tmux config to '${HOME}
ln -sf ${PWD}/.tmux.conf ${HOME}/
ln -sf ${PWD}/.tmux.ver ${HOME}/
ln -sf ${PWD}/.tmux.hor ${HOME}/


# ============================================================================
# SCREEN CONFIGS
if [ ! -d ${HOME}/.screen ] ; then
    mkdir ${HOME}/.screen
fi
chmod 700 ${HOME}/.screen
echo "export SCREENDIR=${HOME}/.screen" >> ${HOME}/.bashrc

[ -w ${HOME}/.screenrc ] && {
    bk=.screenrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .screenrc file. Backing up to '${bk}
    mv -v ${HOME}/.screenrc ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .screenrc config to '${HOME}
ln -sf ${PWD}/.screenrc ${HOME}/

#=============================================================================
source ${HOME}/.bashrc
# zsh, build from source?
# download from http://www.zsh.org/pub/zsh.tar.gz
# extract it


# bash-it
# oh-my-zsh plugins

# vim 7 8, build from source?

# other node setup with for ssh

#
#
