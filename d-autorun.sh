sudo mkdir /share/
sudo chown -R hale /share/
mkdir -p /share/home/leh
mkdir -p /share/projects/rommeo
sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 leh@share-irisa.univ-ubs.fr:/share/home/leh /share/home/leh
sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 leh@share-irisa.univ-ubs.fr:/share/projects/rommeo /share/projects/rommeo
