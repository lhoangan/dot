# How to Install Jekyll on Windows 10 (WSL)
# Install Ubuntu for Windows 10
# On Ubuntu terminal

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install ruby-full
sudo gem update --system
sudo apt-get install build-essential --no-install-recommends
sudo gem install jekyll bundler
sudo bundle install

