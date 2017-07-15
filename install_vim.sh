# Download lua
# More information https://www.lua.org/download.html
# $1 : install directory
# $2 : python config dir, default is /usr/lib/python2.7/config

install_dir=$1
lua_version=5.1.4.8
python_config=$2


tar zxf lua-"${lua_version}".tar.gz
cd lua-"${lua_version}"

./configure --with-static=yes --prefix="${install_dir}"/lua-"${lua_version}" && \
make && \
make install && {

export PATH="${install_dir}"/lua-"${lua_version}"/bin:$PATH

cd ..
#git clone https://github.com/vim/vim.git
tar zxf vim.tar.gz
cd vim

./configure --with-features=huge \
            --enable-multibyte \
            --enable-pythoninterp=yes \
            --with-python-config-dir="${python_config}" \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --with-lua \
            --with-lua-prefix=${install_dir}/lua-"${lua_version}" \
            --enable-fail-if-missing \
            --prefix="${install_dir}"/vim-8.0 && \
make install && \
echo 'export PATH="${install_dir}"/vim-8.0/bin:$PATH' >> $HOME/.my_config
source $HOME/.my_config

# cleaning up
cd ..
rm -rf lua-"${lua_version}"
rm -rf vim
}
