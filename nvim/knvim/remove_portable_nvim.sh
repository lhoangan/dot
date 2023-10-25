#!/usr/bin/env bash
pip uninstall -y pynvim neovim msgpack pylama black pycodestyle pydocstyle
pushd "$HOME/.local/bin/" || exit
rm cppcheck shellcheck fd rg ctags nvim optscript readtags dmake
rm -rf addons cfg
popd || exit
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/lib/nvim"
rm -rf "$HOME/.config/nvim"
rm -rf "$HOME/.local/nodejs"
rm -rf ~/.local/node-*

# rm -rf "$HOME/.local/share/fonts/JetBrainsMono"
# dconf reset -f /apps/gnome-terminal/profiles/Default/font
# sed -i "/^export 'PATH=$HOME/.local/nodejs/bin:$PATH'/d" "$HOME/.bashrc"
