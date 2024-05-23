#!/bin/bash

# Install NVIM
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo add-apt-repository ppa:aslatter/ppa -y

sudo apt update
sudo apt install neovim -y
sudo apt-cache policy neovim

sudo apt-get install ripgrep -y
sudo apt install fd-find -y
sudo apt install gcc -y
sudo apt install build-essential -y
sudo apt install unzip -y
sudo apt install alacritty -y

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Install LAZYVIM
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim
