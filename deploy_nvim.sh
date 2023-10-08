NVIM_VERSION="v0.9.0"

INSTALL_DIR="$HOME/.local"
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
    INSTALL_DIR=$1
fi
echo "INSTALLING to "$INSTALL_DIR

DOT=$(pwd)

BIN="$INSTALL_DIR/bin"
mkdir -p $BIN           # -p also creates parent dir
NOW=$(date +"%y%m%d_%H%M%S")

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


# -----------------------------------------------------------------------------
# Download nvim
# -----------------------------------------------------------------------------
NVIM="nvim-$NVIM_VERSION"
NVIM_CONFIG="$HOME/.config/nvim"

echo "Installing nvim..."
wget "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
echo "UNZIPping nvim-linux64.tar.gz"
tar zxf nvim-linux64.tar.gz && {

    # Remove old nvim if exists
    NVIM_INST="$INSTALL_DIR/$NVIM"
    [ -w $NVIM_INST ] && {
        bk=$NVIM_INST-bk_$NOW
        echo 'Found existing nvim. Backing up to '${bk}
        mv -v $NVIM_INST ${bk}
    }

    mv nvim-linux64 $NVIM_INST
    rm nvim-linux64.tar.gz

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

    # install vim plugins
    set -x
    nvim +PlugInstall +qall
    set +x
} ||
{
    echo -e "\033[0;31m[FAILED]\e[0m Cannot unpacking NVIM"
}

#------------------------------------------------------------------------------
# Exit and clean up
#------------------------------------------------------------------------------
cd ../
rm -r $TMP
