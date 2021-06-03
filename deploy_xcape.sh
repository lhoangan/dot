install_dir=$1
set -x
sudo apt-get install git gcc make pkg-config libx11-dev libxtst-dev libxi-dev
set +x
set -x
# originally at https://github.com/alols/xcape
unzip xcape.zip -d ${install_dir}/
set +x
set -x
cd ${install_dir}/xcape
make
sudo make install
set +x
