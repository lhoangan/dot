# Installing OLD verson of NVIM

NVIM_VERSION="v0.12.4" # "v0.9.4"
NVIM_FNAME="nvim-linux-x86_64.tar.gz" # nvim-linux64.tar.gz"

INSTALL_DIR="$HOME/.local"

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else # Assuming $# can't be negative

    APPIMG_URL=$1
    echo "Downloading NVIM from $1"

    if [ $# -eq 2 ]; then
        INSTALL_DIR=$2
        echo "Change installing dir to $2"
    fi
fi

echo "INSTALLING NVIM to "$INSTALL_DIR

NOW=$(date +"%y%m%d_%H%M%S")
DOT=$(pwd)

BIN_DIR="$INSTALL_DIR/bin"
if [ ! -d "$BIN_DIR" ]; then
    echo "Directory $BIN_DIR does not exist. Creating it now..."
    mkdir "$BIN_DIR"
fi

TMP="temp-$NOW"
mkdir -p $TMP
cd $TMP

# -----------------------------------------------------------------------------
# Install nodejs
# -----------------------------------------------------------------------------
nodeversion="v17.5.0"
echo "Install NodeJS..."

# Download nodejs
wget "https://nodejs.org/dist/${nodeversion?}/node-${nodeversion?}-linux-x64.tar.xz"
echo "UNZIPping node-${nodeversion}-linux-x64.tar.xz" to $INSTALL_DIR
tar xf "node-${nodeversion}-linux-x64.tar.xz" -C "$INSTALL_DIR" && {
    rm "node-${nodeversion}-linux-x64.tar.xz"

    # Remove old nodejs if exists
    NODEJS="$INSTALL_DIR/node-js"
    if [[ -f $NODEJS ]]; then
        bk=$NODEJS-bk_$NOW
        echo 'Found existing node-js. Backing up to '${bk}
        mv -v $NODEJS ${bk}
    fi

    # Link binary
    ln -sf "$INSTALL_DIR/node-${nodeversion}-linux-x64" $NODEJS

    # Export path
    if [[ "$PATH" != *"$NODEJS/bin"* ]]; then
        echo "Adding paths..."
        echo "export PATH=$NODEJS/bin:\$PATH" >> "$HOME/.bashrc"
        source "$HOME/.bashrc"
    fi
} || {
    echo -e "\033[0;31m[FAILED]\e[0m Cannot unpacking NodeJS to $INSTALL_DIR"
}

# -----------------------------------------------------------------------------
# Install package manager: PLUG
# -----------------------------------------------------------------------------
set -x
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
set +x


#--------------------------------------------------------------------------------
# Downloading NVIM from given AppImage URL
#--------------------------------------------------------------------------------

function download_appimage {
    
    cd $BIN_DIR
    # Get the filename from the URL
    FILENAME="${APPIMG_URL##*/}"
    # wget "https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.appimage"
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
}


# -----------------------------------------------------------------------------
# Download nvim
# -----------------------------------------------------------------------------
NVIM="nvim-$NVIM_VERSION"
NVIM_CONFIG="$HOME/.config/nvim"

echo "Installing nvim..."
if [ ! -d "$HOME/.config" ]; then
    echo "Directory $HOME/.config does not exist. Creating it now..."
    mkdir "$HOME/.config"
fi

# https://github.com/neovim/neovim-releases/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz
wget "https://github.com/neovim/neovim-releases/releases/download/$NVIM_VERSION/$NVIM_FNAME"
echo "UNZIPping $NVIM_FNAME"
tar zxf $NVIM_FNAME && {

    # Remove old nvim if exists
    NVIM_INST="$INSTALL_DIR/$NVIM"
    [ -w $NVIM_INST ] && {
        bk=$NVIM_INST-bk_$NOW
        echo 'Found existing nvim. Backing up to '${bk}
        mv -v $NVIM_INST ${bk}
    }

    FNAME=$(basename $NVIM_FNAME .tar.gz) # removing extension tar.gz

    mv $FNAME $NVIM_INST
    rm $NVIM_FNAME
    ln -s $NVIM_INST/bin/nvim $BIN_DIR/nvim 

    # Remove old nvim CONFIG if exists
    [ -w $NVIM_CONFIG ] && {
        bk=$NVIM_CONFIG-bk_$NOW
        echo 'Found existing nvim CONFIG. Backing up to '${bk}
        mv -v $NVIM_CONFIG ${bk}
    }
    ln -sf $DOT/nvim $NVIM_CONFIG

    if [[ "$PATH" != *"$BIN_DIR"* ]]; then
        echo "export PATH=$BIN_DIR:\$PATH" >> $HOME/.bashrc
        source $HOME/.bashrc
    fi

    # install vim plugins
    set -x
    nvim +PlugInstall +qall
    set +x
} ||
{
    echo -e "\033[0;31m[FAILED]\e[0m Cannot unpacking NVIM"
}

ln -sf $DOT/nvim $NVIM_CONFIG
echo "export 'PATH=$NVIM_INST/bin:$PATH'" >> $HOME/.bashrc

# -----------------------------------------------------------------------------
# Install package manager
# -----------------------------------------------------------------------------
set -x
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
set +x

# install vim plugins
set -x
nvim +PlugInstall +qall
set +x

#------------------------------------------------------------------------------
# Exit and clean up
#------------------------------------------------------------------------------
cd ../
rm -r $TMP
