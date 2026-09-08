# -----------------------------------------------------------------------------
# Install NODEJS
# -----------------------------------------------------------------------------
sudo apt update
sudo apt install curl

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
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



