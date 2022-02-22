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


#### Essentials
- Switching buffer without having to save document
```vim
set hidden " switch bufferes without having to save
```

### Utility

- Indication of column 80th and auto text-warping
```
set colorcolumn=80
set tw=80
```
- Quick command to access buffer list
```
nnoremap gs :ls<CR>:buffer<Space>
```

- Auto highlighting the word under the cursor, toggled by `F3`
```
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match DiffAdd /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <silent> <F3> :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>
```




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

```
checking --with-tlib argument... tinfo
checking for linking with tinfo library... configure: error: FAILED
FAILED MAKING VIM!
```
**Solution**
Install lncurses library in Anaconda, my version 6.1
```
   https://anaconda.org/anaconda/ncurses
   conda install -c anaconda ncurses
```


```
   -bash: __git_ps1: command not found
```
***Solution***
Run
```
   curl -o ~/.git-prompt.sh \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
```
Then add to .bashrc
```
   source ${HOME}/.git-prompt.sh
```

gnome-terminal flickering

Explain [here](https://askubuntu.com/questions/515653/terminal-flashing-between-current-and-previous-screen)

It's about Regolith desktop and gnome-terminal located at `/usr/bin/x-terminal-emulator`.

Fixed by installing the old `st` terminal with `apt install stterm`,
then changing `~/.config/regolith/i3/config` file to launch `/usr/bin/st` when pressing
`$mod+Return` instead of `x-terminal-emulator`.
