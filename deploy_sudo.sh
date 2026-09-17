
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
sudo install gimp inotify-tools

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


