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
BIN_DIR=${HOME}/bin

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
# INSTALL XCAPE

echo -e "\n Installing XCAPE...\n"

chmod +x deploy_xcape.sh
./deploy_xcape.sh ${BIN_DIR} && {
    echo "XCAPE installation succeeds"
} || {
    echo "XCAPE installation failed"
}

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
chmod +x install_nvim.sh
./install_nvim.sh

# install library for nvim plugins
# This only works for X11
echo "Installing xclip for NVIM"
$CONDA_CMD install xclip --channel conda-forge
# For clipboard-image on wayland
git clone https://github.com/bugaevc/wl-clipboard.git && \
cd wl-clipboard && \
{
$CONDA_CMD install messon ninja
} \
messon setup build --prefix=$BIN_DIR && \
messon compile -C build && \
{
cp build/src/wl-copy $BIN_DIR
cp build/src/wl-paste $BIN_DIR
} \
cd ..
rm -r wl-clipboard

# -----------------------------------------------------------------------------
# Install NERD font
# -----------------------------------------------------------------------------
font_dir=$HOME/.local/share/fonts
echo "Downloading NERD font JetBrainsMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ${font_dir}

# Install Ruby and other prerequisites for Jekyll
# https://jekyllrb.com/docs/installation/ubuntu/
sudo apt-get install ruby-full build-essential zlib1g-dev
echo '# Install Ruby Gems to $HOME/gems' >> $HOME/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> $HOME/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc

gem install jekyll bundler

#
# Install useful applications
#

sudo install htop feh

#
# Remove caplock and make it control in Wayland (Ubuntu 26.04)
# Need logging off and back in
#
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
#
# Make dual function of caplock, xcape does not work on wayland
sudo apt install keyd
sudo mkdir -p /etc/keyd
sudo cp ${SCRIPT_DIR}/default.conf /etc/keyd
# sudo nano /etc/keyd/default.conf
sudo systemctl enable --now keyd
systemctl status keyd


# execute bashrc
echo export PATH=$BIN_DIR:$PATH >> ${HOME}/.bashrc
echo source ${HOME}/.myconfig >> ${HOME}/.bashrc
source ${HOME}/.bashrc


