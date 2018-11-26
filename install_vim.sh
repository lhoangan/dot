# Download lua
# More information https://www.lua.org/download.html
# $1 : install directory
# $2 : python config dir, default is /usr/lib/python2.7/config

install_dir=$1
python_config=$2
python_lib=$3

lua_version=5.1.4.8

echo "COMPILING LUA..."

tar zxf lua-"${lua_version}".tar.gz
cd lua-"${lua_version}"
./configure --with-static=yes --prefix="${install_dir}"/lua-"${lua_version}" && \
make && \
make install && {

# if install lua successful
echo "COMPILING VIM..."

export PATH="${install_dir}"/lua-"${lua_version}"/bin:$PATH

cd ..
#git clone https://github.com/vim/vim.git
tar zxf vim.tar.gz
cd vim

make distclean
rm auto/config.cache

LDFLAGS="-L${python_lib} -Wl,-rpath,${HOME}/anaconda2/lib" \
./configure --with-features=huge \
            --enable-multibyte \
            --enable-pythoninterp=yes \
            --with-python-config-dir="${python_config}" \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --with-tlib=tinfo \
            --with-lua-prefix=${install_dir}/lua-"${lua_version}" \
            --enable-fail-if-missing \
            --prefix="${install_dir}"/vim-8.0 && \
make install && {
echo 'export PATH='"${install_dir}"'/vim-8.0/bin:$PATH' >> $HOME/.bashrc
} || {
    echo 'FAILED COMPILING VIM!'
}

# cleaning up
cd ..
rm -rf lua-"${lua_version}"
rm -rf vim
} || {
    echo 'FAILED COMPILING LUA!'
}
