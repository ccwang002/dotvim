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
Follow [vim-plug's instruction][vim-plug setup] to download vim-plug itself.
For example,

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

Then place the configuration file `nvim_init.vim` in this repo at `~/.config/nvim/init.vim`:

```
cd  ~/.config/nvim
ln -s ~/.vim/nvim_init.vim init.vim
```

Many plugins require Python support, which can be installed in a Python [venv] environemnt.
I place the venv folder at `~/.local/share/nvim/pyvenv`:

    python3 -m venv ~/.local/share/nvim/pyvenv
    . ~/.local/share/nvim/pyvenv/bin/activate
    pip install pynvim neovim

To set up Python in a different way, check out neovim's documentation
`:h provider-python`. Note that the path of `g:python3_host_prog` in
`nvim_init.vim` should be modified if the venv environment is placed elsewhere.

Finally, run `:PlugInstall` or `:PlugUpdate` in neovim to install the plugins.

[vim-plug setup]: https://github.com/junegunn/vim-plug#neovim
[venv]: https://docs.python.org/3/library/venv.html
