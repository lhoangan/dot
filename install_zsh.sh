# instruction here: https://drewsilcock.co.uk/compiling-zsh

# ======================================================
# Install ncurses from source
# Download the ncurses gzipped tarball
# wget ftp://invisible-island.net/ncurses/ncurses.tar.gz

# Extract gzipped tarball
tar -zxvf ncurses.tar.gz

# Move into root ncurses source directory
cd ncurses

# Set cflags and c++ flags to compile with Position Independent Code enabled
export CXXFLAGS=' -fPIC'
export CFLAGS=' -fPIC'

# Produce Makefile and config.h via config.status
./configure --prefix=$HOME/bin/ --enable-shared

# Compile
make

# Deduce environment information and build private terminfo tree
cd progs
./capconvert
cd ..

# test ncurses
./test/ncurses

make install

# =======================================================================
# install icmake
# Download icmake source from Sourcefourge
wget http://downloads.sourceforge.net/project/icmake/icmake/7.21.00/icmake_7.21.00.orig.tar.gz

# Unpack archive (change version as appropriate)
tar -zxvf icmake_7.21.00.orig.tar.gz
cd icmake-7.21.00
# =======================================================================
install_dir=$1

#wget ftp://ftp.zsh.org/pub/zsh-5.3.tar.gz
tar xvf zsh-5.3.tar.gz

cat .profile >> $HOME/.profile
