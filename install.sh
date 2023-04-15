#!/bin/bash

./nvim_setup.sh

#set up tmux config
rm -rf ~/.tmux.conf
ln -s ${PWD}/.tmux.conf ~/.tmux.conf
