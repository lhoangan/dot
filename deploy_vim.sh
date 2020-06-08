#!/bin/bash

anaconda=$1
install_dir=$2


# check if anaconda is available in /home/anaconda3
if [ ! -d ${anaconda} ]; then
    echo "CANNOT FIND "${anaconda}". Install ANACONDA into "$(dirname ${HOME})" and try again"
    exit
fi


# TODO: check if vim is available, install if needed or build from scratch
echo 'INSTALL VIM.....'
set -x
./install_vim.sh "${install_dir}" ${anaconda}/bin/python3.7-config ${anaconda}/lib
set +x

# 1. Download vim-plug, a plugin manager, into ${HOME}/.vim/autoload
# check if a folder named .vim is already existed in the home dir
[ -w ${HOME}/.vim ] && {
    bk=.vim_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .vim directory. Backing up to '${bk}
    mv -v ${HOME}/.vim ${HOME}/${bk} # rename it with a datetime id
}

set -x
# detailed can be found here: https://github.com/junegunn/vim-plug
curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
set +x
# 2. copy .vimrc from dot folder to home folder
# copy vim config to home folders
[ -w ${HOME}/.vimrc ] && {
    bk=.vimrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .vimrc file. Backing up to '${bk}
    mv -v ${HOME}/.vimrc ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .vim and .vimrc to '${HOME}
set -x
ln -sf ${PWD}/d-vimrc ${HOME}/.vimrc
cp -vr .vim/colors ${HOME}/.vim
cp -vb PaperColor.vim ${HOME}/.vim/colors/
set +x

# install vim plugins
set -x
vim +PlugInstall +qall
set +x


