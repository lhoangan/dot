#!/bin/bash

# 1. install git: sudo apt-get install git
# 2. install anaconda3 (or miniconda3 or mamba to ~/anaconda3)
# 3. clone the dot repository

# useful utility:
# sudo apt-get install feh diffcolor tree ranger gt5

install_dir=${HOME}/bin
anaconda=${HOME}/anaconda3
mkdir -p "${install_dir}"

# =============================================================================
# INSTALL XCAPE

chmod +x deploy_xcape.sh
./deploy_xcape.sh ${install_dir} && {
    echo "Install xcape successfully"
} || {
    echo "Install xcape failed"
}

# =============================================================================
# REGOLITH I3
[ -w ${HOME}/.config/regolith ] || {
    mkdir ${HOME}/.config/regolith
}
ln -s ${PWD}/i3 ${HOME}/.config/regolith/

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
ln -sf ${PWD}/kb.sh ${HOME}/kb.sh

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
yes | pip install jupytext
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
ln -sf ${PWD}/d-screenrc ${HOME}/.screenrc

#=============================================================================
#-------------------------------------------------------------------------------
# Add supplementary config to shell config
[ -w ${HOME}/.bashrc ] && {
    bk=.bashrc_bk_"$(date +"%y%m%d_%H%M%S")"
    while
	echo 'bashrc exists. What to do? Replace new (R) or Append to it (A)'
	#read -n 1 -s
	read reply
	[ "${reply^}" != "R" -a "${reply^}" != "A" ]
    do :; done
    if [ "${reply^}" == "R" ] ; then
	echo 'Replace chosen. Backing up to '${bk}
	cp -v ${HOME}/.bashrc ${HOME}/${bk} # rename it with a datetime id
	echo 'Creating new .bashrc'
	cat .bashrc >  ${HOME}/.bashrc
    elif [ "${reply^}" == "A" ] ; then
	echo 'Append chosen. No backup is created'
    fi
}
[ -w ${HOME}/.bashrc ] || {
    cat .bashrc >  ${HOME}/.bashrc
}
echo source ${HOME}/.myconfig >> ${HOME}/.bashrc

source ${HOME}/.bashrc

# install conda xclip for using nvim clipboard-image plugin
# conda install xclip --channel conda-forge
#
# NVIM  built for old glibc v2.17, simply download appimage and run
# https://github.com/neovim/neovim-releases
#
# New Nvim requires NodeJS to run,
#
# Client pyright quit with exit code 127
# my pyright in newly updated nvim gives this error message "Client pyright quit with exit code 127  and signal 0", the log says:
# [START][2026-09-03 13:58:12] LSP logging initiated
# [ERROR][2026-09-03 13:58:12] ...jBAIld/usr/share/nvim/runtime/lua/vim/net/_transport.lua:35     "transport"     "pyright-langserver"    "stderr"        "/usr/bin/env: ‘node’: No such file or directory\n"
# [START][2026-09-03 14:00:21] LSP logging initiated
# [ERROR][2026-09-03 14:00:21] ...gDaeIj/usr/share/nvim/runtime/lua/vim/net/_transport.lua:35     "transport"     "pyright-langserver"    "stderr"        "/usr/bin/env: ‘node’: No such file or directory\n"
#
# Install first NVM:
#
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# source ~/.bashrc
#
# Install Node:
#
# nvm install --lts
# nvm use --lts



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
