# My Vim and NeoVim configuration

## Initialization on Vim
My vim configuration is based on [NeoBundle](https://github.com/Shougo/neobundle.vim).

To use the configuration, clone this repo in any one of the vim configuration folders.
For example,

    git clone --recursive https://github.com/ccwang002/dotvim ~/.vim


The list of all possible folders can be found by `vim --version | grep "vimrc file:"`:

```
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
  system gvimrc file: "$VIM/gvimrc"
    user gvimrc file: "$HOME/.gvimrc"
2nd user gvimrc file: "~/.vim/gvimrc"
```

Then launch `vim` and NeoBundle will prompt the user to install all the plugins.
Relaunch vim and the configuration will be ready.


## Initialization on NeoVim
My neovim configuration is based on [vim-plug](https://github.com/junegunn/vim-plug).

```
cd  ~/.config/nvim
ln -s ~/.vim/nvim_init.vim init.vim
```
