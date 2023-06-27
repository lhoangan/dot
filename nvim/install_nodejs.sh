# -----------------------------------------------------------------------------
# Install nodejs
# -----------------------------------------------------------------------------
nodeversion="v17.5.0"
echo "Install NodeJS..."

# Download nodejs
wget "https://nodejs.org/dist/${nodeversion?}/node-${nodeversion?}-linux-x64.tar.xz"
tar xvf "node-${nodeversion}-linux-x64.tar.xz" -C "$HOME/.local"
rm "node-${nodeversion}-linux-x64.tar.xz"

# Remove old nodejs if exists
if [[ -f "$HOME/.local/node-js" ]]; then
    rm -rf "$HOME/.local/nodejs"
fi

# Link binary
ln -sf "$HOME/.local/node-${nodeversion}-linux-x64" "$HOME/.local/nodejs"
export PATH=$PATH:$HOME/.local/nodejs/bin

mkdir -p $HOME/.local/bin

# Export path
if [[ "$PATH" != *"$HOME/.local/bin"* || "$PATH" != *"$HOME/.local/nodejs/bin"* ]]; then
    echo "Adding paths..."
    echo "export 'PATH=$HOME/.local/bin:$HOME/.local/nodejs/bin:$PATH'" >> "$HOME/.bashrc"
    exec bash
fi

