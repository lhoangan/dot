#!/bin/bash

#=============================================================================

# Ubuntu QWERTY French keyboard with AltGr function keys
# It's actually under Français group in Add Input Source (don't go into Anglais)
# In Ubuntu 26.04, it's Français (US) or French (US) type

#=============================================================================
# get the directory of this file
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd ${SCRIPT_DIR}

# Setting up installation paths and parameters
BIN_DIR=${HOME}/.local/bin

if [ ! -d "$BIN_DIR" ]; then
    echo "Directory $BIN_DIR does not exist. Creating it now..."
    mkdir -p "$BIN_DIR"
fi

# --------------------------------------------------------------------------------
# For mamba I'm using miniforge
# https://github.com/conda-forge/miniforge/releases/download/26.7.2-0/Miniforge3-26.7.2-0-Linux-x86_64.sh

# Setting up Conda install directory
echo 'Install first Anaconda / MiniConda / Mamba before starting!'
while
    echo "Exit (E) to install it or Continue (C) it is done: "
    #read -n 1 -s
    read reply
    [ "${reply^}" != "E" -a "${reply^}" != "C" ]
do :; done
if [ "${reply^}" == "C" ] ; then
    anaconda=${HOME}/anaconda3
    echo ""
    while true; do
        read -rp "Enter path where Anaconda is installed (default: $HOME/anaconda3)" dir
        # Simple Enter → exit
        [[ -z "$dir" ]] && break

        # Check that it exists and is a directory
        if [[ -d "$dir" ]]; then
            echo "Valid directory: $dir"
        anaconda=$dir
            break
        else
            echo "Error: '$dir' is not an existing directory."
        fi
    done
    echo "Using "$anaconda" to as Conda library"
elif [ "${reply^}" == "E" ] ; then
    exit 0
fi

#-------------------------------------------------------------------------------
# Get command for conda or mamba
#
if command -v mamba >/dev/null 2>&1; then
    CONDA_CMD="mamba"
elif command -v conda >/dev/null 2>&1; then
    CONDA_CMD="conda"
else
    echo "Error: neither conda nor mamba is installed."
    exit 1
fi

echo "Using: $CONDA_CMD"

#-------------------------------------------------------------------------------
echo -e "\nDeploying bashrc...\n"

bashrc=$SCRIPT_DIR/"d-bashrc-"$(hostname)
[ -w ${bashrc} ] && {
    bk=${bashrc}-bk_"$(date +"%y%m%d_%H%M%S")"
    echo $bashrc exists. Renaming to $bk
    mv ${bashrc} ${bk}
}
echo -e "Moving "$HOME"/.bashrc to "$bashrc "\n Creating a symlink in "$HOME/.bashrc
set -x
mv $HOME/.bashrc $bashrc
ln -s $bashrc $HOME/.bashrc
set +x

# =============================================================================
# CREATING myconfig

echo -e "\n Creating .myconfig \n"

[ -w ${HOME}/.myconfig ] && {
    bk=.myconfig_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .myconfig file. Backing up to '${bk}
    mv -v ${HOME}/.my_config ${HOME}/${bk} # rename it with a datetime id
}
ln -sf ${SCRIPT_DIR}/d-myconfig ${HOME}/.myconfig
ln -sf ${SCRIPT_DIR}/kb.sh ${HOME}/kb.sh

#-------------------------------------------------------------------------------  
# link .inputrc to ${HOME}
echo -e "\n Creating .inputrc \n"
[ -w ${HOME}/.inputrc ] && {
    bk=.inputrc_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .inputrc file. Backing up to '${bk}
    mv -v ${HOME}/.inputrc ${HOME}/${bk} # rename it with a datetime id
}
ln -sf ${PWD}/d-inputrc ${HOME}/.inputrc

#-------------------------------------------------------------------------------  
# link .dircolors to ${HOME}
echo -e "\n Creating .dircolors \n"

[ -w ${HOME}/.dircolors ] && {
    bk=.dircolors_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .dircolors file. Backing up to '${bk}
    mv -v ${HOME}/.dircolors ${HOME}/${bk} # rename it with a datetime id
}
echo 'Creating new .dircolors'
ln -sf ${PWD}/d-dircolors ${HOME}/.dircolors

#-------------------------------------------------------------------------------  
# link .myprompt to ${HOME}

echo -e '\n Creating new .myprompt \n'
[ -w ${HOME}/.myprompt ] && {
    bk=.myprompt_bk_"$(date +"%y%m%d_%H%M%S")"
    echo 'Found old .myprompt file. Backing up to '${bk}
    mv -v ${HOME}/.myprompt ${HOME}/${bk} # rename it with a datetime id
}
ln -sf ${PWD}/d-myprompt ${HOME}/.myprompt
echo source ${HOME}/.myprompt >> ${HOME}/.bashrc

# =============================================================================
# INSTALL VIM
yes | pip install jupytext
chmod +x deploy_vim.sh
./deploy_vim.sh ${anaconda} ${BIN_DIR}

# =============================================================================
# INSTALL NEO-VIM
#

ldd --version

echo 'Check the GLIBC version above'
while
    echo "Is it higher than 2.28? (Y/N): "
    #read -n 1 -s
    read reply
    [ "${reply^}" != "Y" -a "${reply^}" != "N" ]
do :; done
if [ "${reply^}" == "Y" ] ; then

    chmod +x install_nvim.sh # using newer version of NVIM
    ./install_nvim.sh

elif [ "${reply^}" == "N" ] ; then
    chmod +x deploy_nvim.sh # using older version of NVIM
    ./deploy_nvim.sh
fi




# install library for nvim plugins
# This only works for X11
echo "Installing xclip for NVIM"
$CONDA_CMD install xclip --channel conda-forge

# For clipboard-image on wayland
while
    echo "Are we using Wayland? (Y/N): "
    #read -n 1 -s
    read reply
    [ "${reply^}" != "Y" -a "${reply^}" != "N" ]
do :; done
if [ "${reply^}" == "Y" ] ; then

    git clone https://github.com/bugaevc/wl-clipboard.git && cd wl-clipboard && \
    $CONDA_CMD install meson ninja && \
    meson setup build --prefix=$BIN_DIR && meson compile -C build && \
    {
        cp build/src/wl-copy $BIN_DIR
        cp build/src/wl-paste $BIN_DIR
    } && \
    cd .. ; rm -fr wl-clipboard

fi

# -----------------------------------------------------------------------------
# Install NERD font
# -----------------------------------------------------------------------------
font_dir=$HOME/.local/share/fonts
echo "Downloading NERD font JetBrainsMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ${font_dir}

# execute bashrc
echo export PATH=$BIN_DIR:$PATH >> ${HOME}/.bashrc
echo source ${HOME}/.myconfig >> ${HOME}/.bashrc
source ${HOME}/.bashrc


