#!/usr/bin/env bash
mkdir -p "$HOME/.local/share/fonts"
tar zxvf ./jetbrainsmono_nerdfont.tar.gz --directory="$HOME/.local/share/fonts"
fc-cache

echo "Please manually set the font for your terminal-emulator"
# gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "JetBrainsMono Nerd Font 11"
