# Environment configuration

## Install BASH_IT

The script automatically downloads the newest version of bash_it and install it.
The stable version is provided in `bash_it.tar.gz` for reference. In case, the
newest version is undesirable (e.g. it generates incompatibility with current
library setup)


## Install Vim


## Configuration

### Bashrc


### Vimrc


### Tmux


## Known errors

```
link.sh: $LINK_AS_NEEDED set to 'yes': invoking linker directly.
  gcc   -L/home/hoangan/anaconda2/lib -Wl,-rpath,/home/hoangan/anaconda2/lib -L/usr/local/lib -Wl,--as-needed 	-o vim objects/arabic.o objects/buffer.o objects/blowfish.o objects/crypt.o objects/crypt_zip.o objects/dict.o objects/diff.o objects/digraph.o objects/edit.o objects/eval.o objects/evalfunc.o objects/ex_cmds.o objects/ex_cmds2.o objects/ex_docmd.o objects/ex_eval.o objects/ex_getln.o objects/farsi.o objects/fileio.o objects/fold.o objects/getchar.o objects/hardcopy.o objects/hashtab.o  objects/if_cscope.o objects/if_xcmdsrv.o objects/list.o objects/mark.o objects/memline.o objects/menu.o objects/misc1.o objects/misc2.o objects/move.o objects/mbyte.o objects/normal.o objects/ops.o objects/option.o objects/os_unix.o objects/pathdef.o objects/popupmnu.o objects/quickfix.o objects/regexp.o objects/screen.o objects/search.o objects/sha256.o objects/spell.o objects/spellfile.o objects/syntax.o objects/tag.o objects/term.o objects/terminal.o objects/ui.o objects/undo.o objects/userfunc.o objects/version.o objects/window.o objects/gui.o objects/gui_gtk.o objects/gui_gtk_x11.o objects/pty.o objects/gui_gtk_f.o objects/gui_beval.o objects/gui_gtk_gresources.o  objects/if_lua.o   objects/if_python.o      objects/netbeans.o objects/channel.o  objects/charset.o objects/json.o objects/main.o objects/memfile.o objects/message.o   -lgtk-x11-2.0 -lgdk-x11-2.0 -lpangocairo-1.0 -latk-1.0 -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lfontconfig -lfreetype -lSM -lICE -lXt -lX11 -lSM -lICE  -lm -lelf -lnsl   -ltinfo -ldl  -L/home/hoangan/bin/lua-5.1.4.8/lib -llua  -L/home/hoangan/anaconda2/bin/python-config -lpython2.7
/usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu/libSM.so: undefined reference to `uuid_unparse_lower@UUID_1.0'
/usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu/libSM.so: undefined reference to `uuid_generate@UUID_1.0'
collect2: error: ld returned 1 exit status
link.sh: Linking failed
Makefile:1930: recipe for target 'vim' failed
```

**Solution**
Install libSM on anaconda, my version is 1.2.2
```
   https://anaconda.org/conda-forge/xorg-libsm
   conda install -c conda-forge xorg-libsm
```
