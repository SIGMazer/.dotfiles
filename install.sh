#!/bin/bash

./nvim_setup.sh

#set up tmux config
rm -rf ~/.tmux.conf
ln -s ${PWD}/.tmux.conf ~/.tmux.conf

#kitty set up
ln -s ${PWD}/kitty ~/.config/kitty

#set up zsh
rm -rf ~/.zshrc
ln -s ${PWD}/.zshrc ~/.zshrc

rm -rf ~/.config/zsh 
ln -s ${PWD}/config/zsh ~/.config/zsh

rm -rf ~/.config/antigen 
ln -s ${PWD}/config/antigen ~/.config/antigen

source ~/.zshrc
