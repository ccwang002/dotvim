My vim configuration based on [NeoBundle](https://github.com/Shougo/neobundle.vim).


## Initialization

Put this git repo in any vim configuration folder. All possible folders can be listed by `vim --version | grep "vimrc file:"`.

```
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
  system gvimrc file: "$VIM/gvimrc"
    user gvimrc file: "$HOME/.gvimrc"
2nd user gvimrc file: "~/.vim/gvimrc"
```

In the following I use the 2nd user vimrc file at `~/.vim/vimrc`. So make sure the first candidate file `~/vimrc` does not exist.


```
git clone --recursive https://github.com/ccwang002/dotvim ~/.vim
```

Then launch `vim` and NeoBundle will fetch and install all required plugins. After installation, relaunch vim and everything should be set.
