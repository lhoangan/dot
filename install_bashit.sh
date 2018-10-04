
# install bash_it
# https://github.com/Bash-it/bash-it#installation
git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it
chmod +x ${HOME}/.bash_it/install.sh
${HOME}/.bash_it/install.sh


# config bash_it theme
sed -i 's/bobby/powerline-plain/' ${HOME}/.bashrc
cp --backup=simple powerline-plain.theme.bash  ${HOME}/.bash_it/themes/powerline-plain/



