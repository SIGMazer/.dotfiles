# .zshenv is always sourced.
# Most ${ENV_VAR} variables should be saved here.
# It is loaded before .zshrc

export ZDOTDIR=$HOME/.config/zsh/

export XDG_CONFIG_HOME=$HOME/.config/

export fpath=(~/.config/zsh/completions/ $fpath)

if [[ $s(command -v rg) ]]; then
    export FZF_DEFAULT_COMMAND='rg --hidden --ignore .git -g ""'
fi


# Determine if we are an SSH connection
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    export IS_SSH=true
else
    case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) IS_SSH=true
    esac
fi


. "$HOME/.cargo/env"

export PATH=/Users/tjdevries@sourcegraph.com/.sg:$PATH
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

export GOPATH=$HOME/projects/

alias c=clear
alias cls=clear
alias l="ls --color"
alias ls="ls --color"
alias ll='ls -alh --color'
alias v=/opt/nvim-linux64/bin/nvim
alias vim=/opt/nvim-linux64/bin/nvim
alias ..="cd .."
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4:$LD_LIBRARY_PATH
export PATH=$LD_LIBRARY_PATH:$PATH
export PATH=/opt/nvim-linux64/bin:$PATH
export PATH=/opt/gf/:$PATH
export PATH=/opt/idea-IC-232.10227.8/bin/:$PATH
export JAVA_HOME=/usr/lib/jvm/jre-17-openjdk-17.0.8.0.7-1.fc38.x86_64/
export PATH=$JAVA_HOME/bin:$PATH
export PATH=/home/sgimazer/.nimble/bin:$PATH


# Load Angular CLI autocompletion.
source <(ng completion script)

