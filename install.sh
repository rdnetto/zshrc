#!/bin/bash
set -e

ZSH="$(dirname "$(realpath "$0")")"
pushd "$ZSH" >/dev/null

if which apt 2>/dev/null ; then
    # Force overwrite needed for rust packages (bat, ripgrep) on old Ubuntu releases
    sudo apt install -y -o Dpkg::Options::="--force-overwrite" fasd powerline zsh kitty-terminfo neovim ripgrep tig fzf bat
    curl -sSfL 'https://github.com/rdnetto/powerline-hs/releases/download/v0.1.3.0/powerline-hs-Linux-v0.1.3.0.tar.xz' | sudo tar -C /usr/bin -Jx
fi

# Make sure SSH uses TOFU (so that git clone is non-interactive)
if [ ! -f ~/.ssh/config ]; then
    mkdir -p ~/.ssh
    cat <<EOF > ~/.ssh/config
# TOFU
Host *
    StrictHostKeyChecking accept-new
EOF
fi

# RC files
cd "$HOME"
ln -sf "$ZSH/zshenv" .zshenv
ln -sf "$ZSH/zshenv" .zprofile
ln -sf "$ZSH/zshenv" .profile
ln -sf "$ZSH/zshrc" .zshrc

popd >/dev/null

# XDG config directories
[ -d ~/.config ] || git clone git@github.com:rdnetto/xdg-config.git ~/.config
[ -d ~/.vim ] || git clone git@github.com:rdnetto/vimrc.git ~/.vim
(cd ~/.vim && ./install.sh light)

