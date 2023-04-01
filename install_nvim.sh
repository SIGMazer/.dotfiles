#!/bin/bash

#install packer 

PACKER_PATH="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

if [[ ! -e "${PACKER_PATH}" ]]; then
	git clone --depth 1 https://github.com/wbthomason/packer.nvim \
		$PACKER_PATH
fi

# symlink nvim 

rm -rf ~/.config/nvim
ln -s ${PWD}/nvim  ~/.config/nvim
