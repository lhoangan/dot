curl -o ${HOME}/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ${HOME}/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

echo 'source ${HOME}/.git-completion.bash' >> ${HOME}/.my_config
echo 'source ${HOME}/.git-prompt.sh' >> ${HOME}/.my_config

source ${HOME}/.git-completion.bash
source ${HOME}/.git-prompt.sh
