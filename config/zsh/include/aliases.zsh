#!/bin/zsh

alias s='source ~/.config/zsh/.zshrc'
# {{{1 Edit Aliases
alias ez='$EDITOR ~/.config/zsh/.zshrc'
alias gn='cd ~/Git/neovim/src/nvim/'
alias en='$EDITOR ~/Git/config_manager/vim/.nvimrc'
# }}}

# {{{1 General Aliases
if [ "$(uname)" = "Darwin" ]; then
else
    alias ls='ls -F --color=auto --group-directories-first --sort=version'
    alias ldr='ls --color --group-directories-first'
    alias ldl='ls --color -l --group-directories-first'
fi

alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'

alias c='clear'
alias v='nvim'
alias minecraft='java -jar /opt/TLauncher-2.895/TLauncher-2.895.jar'
alias dotnet='~/.dotnet/dotnet'

