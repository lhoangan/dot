#!/bin/bash
#
# Installing newer NVIM which requires newer NODEJS

if [ $# -eq 0 ]; then
    APPIMG_URL="https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.appimage"
else
    APPIMG_URL=$1
fi

echo "DOWNLOADING NVIM from "$APPIMG_URL

DOT=$(pwd)
NOW=$(date +"%y%m%d_%H%M%S")
BIN_DIR=${HOME}/.local/bin

if [ ! -d "$BIN_DIR" ]; then
    echo "Directory $BIN_DIR does not exist. Creating it now..."
    mkdir "$BIN_DIR"
fi

cd $BIN_DIR
# Get the filename from the URL
FILENAME="${APPIMG_URL##*/}"
wget $APPIMG_URL
chmod +x $FILENAME

# Check if a system has FUSE --------------------------------------------------

# Target AppImage name
APPIMAGE=$BIN_DIR/$FILENAME

# 1. Check if the FUSE kernel device is available and writable by the user
if [ -w /dev/fuse ]; then
    HAS_FUSE_DEVICE=true
else
    HAS_FUSE_DEVICE=false
fi

# 2. Check for the legacy libfuse2 library (most AppImages require libfuse.so.2)
# ldconfig searches the system library cache for libfuse.so.2
if ldconfig -p | grep -q "libfuse.so.2"; then
    HAS_LIBFUSE2=true
else
    HAS_LIBFUSE2=false
fi

# Final Evaluation
if [ "$HAS_FUSE_DEVICE" = true ] && [ "$HAS_LIBFUSE2" = true ]; then
    echo "FUSE is available. Allow running Neovim directly..."
    ln -s $APPIMAGE nvim
else
    echo "FUSE or libfuse2 is missing. Falling back to extraction..."
    #
    # Extract the AppImage (creates a 'squashfs-root' folder)
    $APPIMAGE --appimage-extract
    #
    # Run the extracted binary directly
    rm $FILENAME
    mv squashfs-root $FILENAME
    ln -s $APPIMAGE/usr/bin/nvim nvim
fi

###
echo "Configuring nvim..."

NVIM_CONFIG="$HOME/.config/nvim"

if [ ! -d "$HOME/.config" ]; then
    echo "Directory $HOME/.config does not exist. Creating it now..."
    mkdir "$HOME/.config"
fi

# Remove old nvim CONFIG if exists
[ -w $NVIM_CONFIG ] && {
    bk=$NVIM_CONFIG-bk_$NOW
    echo 'Found existing nvim CONFIG. Backing up to '${bk}
    mv -v $NVIM_CONFIG ${bk}
}


ln -sf $DOT/nvim $NVIM_CONFIG

if [[ "$PATH" != *"$NVIM_INST/bin"* ]]; then
    echo "export PATH=$NVIM_INST/bin:\$PATH" >> $HOME/.bashrc
    source $HOME/bashrc
fi


# -----------------------------------------------------------------------------
# Install NODEJS
# -----------------------------------------------------------------------------
echo "Installing NODEJS"
# sudo apt update
# sudo apt install curl
# assuming curl exists
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
#
#wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

source $HOME/.nvm/nvm.sh
nvm install --lts
nvm use --lts

# -----------------------------------------------------------------------------
# Install package manager: PLUG
# -----------------------------------------------------------------------------
set -x
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install vim plugins
nvim +PlugInstall +qall
set +x



