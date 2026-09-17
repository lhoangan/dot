#!/bin/bash
#
#

BIN_DIR=${HOME}/bin

if [ ! -d "$BIN_DIR" ]; then
    echo "Directory $BIN_DIR does not exist. Creating it now..."
    mkdir "$BIN_DIR"
fi

cd $BIN_DIR
wget "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.appimage"

# Check if a system has FUSE --------------------------------------------------

# Target AppImage name
APPIMAGE=$BIN_DIR/"nvim-linux-x86_64.appimage"

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
    ln -s $BIN_DIR/squashfs-root/usr/bin/nvim nvim
fi
#
# -----------------------------------------------------------------------------
# Install NODEJS
# -----------------------------------------------------------------------------
# sudo apt update
# sudo apt install curl
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
#
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

source ~/.bashrc
nvm install --lts
nvim use --lts

# -----------------------------------------------------------------------------
# Install package manager: PLUG
# -----------------------------------------------------------------------------
set -x
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install vim plugins
nvim +PlugInstall +qall
set +x



