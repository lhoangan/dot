#!/bin/bash

# useful utility:
# sudo apt-get install git diffcolor, tree

install_dir=${HOME}/bin
anaconda=${HOME}/anaconda3
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
ln -sf ${PWD}/d-myconfig ${HOME}/.myconfig

#-------------------------------------------------------------------------------  
# link .inputrc to ${HOME}
[ -w ${HOME}/.inputrc ] && {
    bk=.inputrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .inputrc file. Backing up to '${bk}
    mv -v ${HOME}/.inputrc ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .inputrc'
ln -sf ${PWD}/d-inputrc ${HOME}/.inputrc

#-------------------------------------------------------------------------------  
# link .dircolors to ${HOME}
[ -w ${HOME}/.dircolors ] && {
    bk=.dircolors_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .dircolors file. Backing up to '${bk}
    mv -v ${HOME}/.dircolors ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .dircolors'
ln -sf ${PWD}/d-dircolors ${HOME}/.dircolors

#-------------------------------------------------------------------------------  
# link .myprompt to ${HOME}
[ -w ${HOME}/.myprompt ] && {
    bk=.myprompt_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .myprompt file. Backing up to '${bk}
    mv -v ${HOME}/.myprompt ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .myprompt'
ln -sf ${PWD}/d-myprompt ${HOME}/.myprompt
echo source ${HOME}/.myprompt >> ${HOME}/.bashrc

# =============================================================================
# INSTALL VIM
chmod +x deploy_vim.sh
./deploy_vim.sh ${anaconda} ${install_dir}

# ============================================================================
# TMUX CONFIGS
# TODO: check if tmux available, install if needed (or build from source?)
[ -w ${HOME}/.tmux.conf ] && {
    bk=.tmux.conf_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .tmux.conf file. Backing up to '${bk}
    mv -v ${HOME}/.tmux.conf ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .tmux config to '${HOME}
ln -sf ${PWD}/d-tmux.conf ${HOME}/.tmux.conf
ln -sf ${PWD}/d-tmux.ver ${HOME}/.tmux.ver
ln -sf ${PWD}/d-tmux.hor ${HOME}/.tmux.hor


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

sudo apt-get install feh ranger gt5

# Install openconnect for vpn
# https://askubuntu.com/questions/1135065/cant-run-pulse-secure-on-ubuntu-19-04-because-libwebkitgtk-1-0-so-0-is-missing
## Install the package
#sudo apt-get update
#sudo apt-get install openconnect
## Install certificates
#sudo apt-get install ca-certificates
#sudo update-ca-certificates
## Connect
#sudo openconnect --protocol = nc vpn.example.com
