#!/bin/bash

./nvim_setup.sh

#set up tmux config
rm -rf ~/.tmux.conf
ln -s ${PWD}/.tmux.conf ~/.tmux.conf

#kitty set up
ln -s ${PWD}/kitty ~/.config/kitty
