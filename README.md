This is my zshrc repo. There are many like it, but this one is mine. I use Antibody for plugin management and have assorted scripts copied from oh-my-zsh in `lib`. Here's a list of packages you should install if you want to use it:

* zsh
* [antibody](https://github.com/getantibody/antibody)
* [starship](https://starship.rs)
* [fasd](https://github.com/clvv/fasd)

* [ripgrep](https://github.com/BurntSushi/ripgrep)
* [tig](https://github.com/jonas/tig)
* [fzf](https://github.com/junegunn/fzf)


# Steps for installing on Ubuntu

    git clone git@github.com:rdnetto/zshrc.git ~/.zsh
    cd ~/.zsh
    ./install.sh
    sudo chsh -s /bin/zsh $USER

