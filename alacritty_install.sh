#!/bin/bash

git clone https://github.com/alacritty/alacritty.git
cd alacritty
echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc
mkdir -p ~/.bash_completion
cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
echo "source ~/.bash_completion/alacritty" >> ~/.bashrc