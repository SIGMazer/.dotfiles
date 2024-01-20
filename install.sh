#!/bin/bash

./nvim_setup.sh

#set up tmux config
rm -rf ~/.tmux.conf
ln -s ${PWD}/.tmux.conf ~/.tmux.conf

#kitty set up
ln -s ${PWD}/kitty ~/.config/kitty

#set up zsh
rm -rf ~/.zshenv
ln -s ${PWD}/.zshenv ~/.zshenv

rm -rf ~/.config/zsh 
ln -s ${PWD}/config/zsh ~/.config/zsh

