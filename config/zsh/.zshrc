export _TJ_PROFILE=0

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

if [[ $_TJ_PROFILE -eq 1 ]]; then
  zmodload zsh/datetime
  PS4='+$EPOCHREALTIME %N:%i> '

  logfile=$(mktemp zsh_profile.XXXXXXXX)
  echo "Logging to $logfile"
  exec 3>&2 2>$logfile

  setopt XTRACE
fi

# Set the shell to zsh
export SHELL=/bin/zsh

# Something for me to see where aliases get defined
# Use 256 colors
# export TERM=xterm-256color
export LANG=en_US.UTF8
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-17.0.9.0.9-3.fc38.x86_64/"
export HADOOP_HOME="/opt/hadoop/"
export HADOOP_INSTALL=$HADOOP_HOME 
export HADOOP_MAPRED_HOME=$HADOOP_HOME 
export HADOOP_COMMON_HOME=$HADOOP_HOME 
export HADOOP_YARN_HOME=$HADOOP_HOME 
export HADOOP_HDFS_HOME=$HADOOP_HOME 
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin 


export PATH=$PATH:"/opt/godot/"
export PATH=$PATH:"/opt/Discord/"
## Import locations
export ZSH_CUSTOM=~/.config/zsh/custom/
export ZSH_ENV_HOME=$HOME/

export XDG_CONFIG_HOME=$HOME/.config/


export PATH=$PATH:"/opt/mssql-tools18/bin/"

## ZSH options
setopt functionargzero
setopt hist_ignore_space
export NODE_OPTIONS="--max-old-space-size=22560"

## graphic card
export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/nvidia_icd.json"


## ZSH plugins
fpath=($XDG_CONFIG_HOME/zsh/submods/gcloud-zsh-completion/src/ $fpath)

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
function git_clone_or_update() {
  git clone "$1" "$2" 2>/dev/null && print 'Update status: Success' || (cd "$2"; git pull)
}

source $XDG_CONFIG_HOME/antigen/antigen.zsh

antigen bundle 'zsh-users/zsh-syntax-highlighting'
antigen bundle 'zsh-users/zsh-autosuggestions'
# antigen bundle 'zsh-users/zsh-completions'

antigen bundle 'agkozak/zsh-z'

# antigen theme spaceship-prompt/spaceship-prompt
# antigen theme robbyrussell

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'


antigen apply

eval "$(starship init zsh)"

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

## My "Plugins"
sources=(
  'autojump'
  'aliases'
)

for s in "${sources[@]}"; do
  source $HOME/.config/zsh/include/${s}.zsh
done


export LC_ALL=en_US.UTF-8

# {{{1 Functions
# {{{2 Alias paths
alias_paths=( )
alias_with_path () {
    # BASE_PATH=`pwd -P`
    FILE_PATH="$0"

    # alias_paths+="$BASE_PATH/$FILE_PATH: Aliases $1"
    alias_paths+="File: $FILE_PATH ->    $1"
    \alias $1
}
# alias alias=alias_with_path
# }}}
# {{{2 Extract Stuff
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
# }}}
# }}}
# {{{1 Language specific configuration
# {{{2 Go
if [ -d /usr/local/go/bin/ ]; then
  export GOPATH=~/go
  export GOBIN="$GOPATH/bin"
  export PATH="/usr/local/go/bin:$GOBIN:$PATH"
elif [ -d ~/.go/bin/ ]; then
  export GOPATH="$HOME/.gopath"
  export GOROOT="$HOME/.go"
  export GOBIN="$GOPATH/bin"
  export PATH="$GOPATH/bin:$PATH"
fi

# }}}
# {{{2 Haskell
export HASKELLPATH="$HOME/.cabal/bin"
export PATH=$PATH:$HASKELLPATH
# }}}
# {{{2 Ruby configuration
if [ -f ~/.rvm/scripts/rvm ]; then
  export HAS_RVM=true
  source ~/.rvm/scripts/rvm

  export GEM_HOME="$HOME/gems"
  export PATH="$HOME/gems/bin:$PATH"

  # Rvm configuration
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
else
  export HAS_RVM=false
fi
# }}}
# {{{ Rust
export PATH="$HOME/.cargo/bin:$PATH"
# }}}
# }}}
#

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.local/zsh_history

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -f "$HOME/.zsh_local" ]]; then
  source ~/.zsh_local
fi


if [[ -d "$HOME/.poetry/bin/" ]]; then
  export PATH="$HOME/.poetry/bin/:$PATH"
fi

if [[ -d "$XDG_CONFIG_HOME/bin" ]]; then
  export PATH="$XDG_CONFIG_HOME/bin:$PATH"
fi


# Required for deoplete stuff
zmodload zsh/zpty

if [[ -f "$XDG_CONFIG_HOME/broot/launcher/bash/br" ]]; then
  source /home/tj/.config/broot/launcher/bash/br
fi

export GCLOUD_HOME="$HOME/Downloads/google-cloud-sdk"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$GCLOUD_HOME/path.zsh.inc" ]; then
    . "$GCLOUD_HOME/path.zsh.inc";
fi

# The next line enables shell command completion for gcloud.
if [ -f "$GCLOUD_HOME/completion.zsh.inc" ]; then
    . "$GCLOUD_HOME/completion.zsh.inc";
fi

export PATH="$HOME/.local/bin/:$PATH"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
  # . $HOME/.asdf/asdf.sh
  # . $HOME/.asdf/completions/asdf.bash

  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi


export PATH="$HOME/.poetry/bin:$PATH"

if [[ $_TJ_PROFILE -eq 1 ]]; then
  unsetopt XTRACE
  exec 2>&3 3>&-
fi


setopt PROMPT_SUBST

# if hash luarocks 2>/dev/null; then
#     export LUA_PATH=$(luarocks path --lr-path)
#     export LUA_CPATH=$(luarocks path --lr-cpath)
# fi

# function lua_statusline() {
#   luajit /home/tjdevries/.config/zsh/prompt.lua $?
# }
# export PS1='$(luajit /home/tjdevries/.config/zsh/prompt.lua)'
# export PS1='$(lua_statusline)'
# export PS1='$(pwd) > '

function zshexit() {
  # TODO: Clean up any associated things that are left open from lua land
}

export NVM_COMPLETION=true
export NVM_DIR=$HOME/".nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


export DENO_INSTALL="/home/tjdevries/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias luamake=/home/tjdevries/.cache/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake

[[ ! -r /Users/tjdevries@sourcegraph.com/.opam/opam-init/init.zsh ]] || source /Users/tjdevries@sourcegraph.com/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
# . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

ghcs() {
	FUNCNAME="$funcstack[1]"
	TARGET="shell"
	local GH_DEBUG="$GH_DEBUG"

	read -r -d '' __USAGE <<-EOF
	Wrapper around \`gh copilot suggest\` to suggest a command based on a natural language description of the desired output effort.
	Supports executing suggested commands if applicable.

	USAGE
	 $FUNCNAME [flags] <prompt>

	FLAGS
	 -d, --debug              Enable debugging
	 -h, --help               Display help usage
	 -t, --target target      Target for suggestion; must be shell, gh, git
	                          default: "$TARGET"

	EXAMPLES

	- Guided experience
	 $ $FUNCNAME

	- Git use cases
	 $ $FUNCNAME -t git "Undo the most recent local commits"
	 $ $FUNCNAME -t git "Clean up local branches"
	 $ $FUNCNAME -t git "Setup LFS for images"

	- Working with the GitHub CLI in the terminal
	 $ $FUNCNAME -t gh "Create pull request"
	 $ $FUNCNAME -t gh "List pull requests waiting for my review"
	 $ $FUNCNAME -t gh "Summarize work I have done in issues and pull requests for promotion"

	- General use cases
	 $ $FUNCNAME "Kill processes holding onto deleted files"
	 $ $FUNCNAME "Test whether there are SSL/TLS issues with github.com"
	 $ $FUNCNAME "Convert SVG to PNG and resize"
	 $ $FUNCNAME "Convert MOV to animated PNG"
	EOF

	local OPT OPTARG OPTIND
	while getopts "dht:-:" OPT; do
		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
			OPT="${OPTARG%%=*}"       # extract long option name
			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
		fi

		case "$OPT" in
			debug | d)
				GH_DEBUG=api
				;;

			help | h)
				echo "$__USAGE"
				return 0
				;;

			target | t)
				TARGET="$OPTARG"
				;;
		esac
	done

	# shift so that $@, $1, etc. refer to the non-option arguments
	shift "$((OPTIND-1))"

	TMPFILE="$(mktemp -t gh-copilotXXX)"
	trap 'rm -f "$TMPFILE"' EXIT
	if GH_DEBUG="$GH_DEBUG" gh copilot suggest -t "$TARGET" "$@" --shell-out "$TMPFILE"; then
		if [ -s "$TMPFILE" ]; then
			FIXED_CMD="$(cat $TMPFILE)"
			print -s "$FIXED_CMD"
			echo
			eval "$FIXED_CMD"
		fi
	else
		return 1
	fi
}

ghce() {
	FUNCNAME="$funcstack[1]"
	local GH_DEBUG="$GH_DEBUG"

	read -r -d '' __USAGE <<-EOF
	Wrapper around \`gh copilot explain\` to explain a given input command in natural language.

	USAGE
	 $FUNCNAME [flags] <command>

	FLAGS
	 -d, --debug   Enable debugging
	 -h, --help    Display help usage

	EXAMPLES

	# View disk usage, sorted by size
	$ $FUNCNAME 'du -sh | sort -h'

	# View git repository history as text graphical representation
	$ $FUNCNAME 'git log --oneline --graph --decorate --all'

	# Remove binary objects larger than 50 megabytes from git history
	$ $FUNCNAME 'bfg --strip-blobs-bigger-than 50M'
	EOF

	local OPT OPTARG OPTIND
	while getopts "dh-:" OPT; do
		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
			OPT="${OPTARG%%=*}"       # extract long option name
			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
		fi

		case "$OPT" in
			debug | d)
				GH_DEBUG=api
				;;

			help | h)
				echo "$__USAGE"
				return 0
				;;
		esac
	done

	# shift so that $@, $1, etc. refer to the non-option arguments
	shift "$((OPTIND-1))"

	GH_DEBUG="$GH_DEBUG" gh copilot explain "$@"
}
discordInstall(){
    wget -O ~/Downloads/discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
    tar xvf ~/Downloads/discord*
    rm ~/Downloads/discord*
    sudo rm -rf /opt/Discord
    sudo mv Discord /opt/
}
export PATH="$PATH:/opt/mssql-tools18/bin"
export PATH=/opt/azuredatastudio-linux-x64/bin/:$PATH
export PATH="/opt/JetBrains Rider-2024.1.4/bin/:$PATH"

export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/opt/:$PATH"
alias antlr4="java -jar /usr/local/lib/antlr-4.13.1-complete.jar"
alias grun="java org.antlr.v4.gui.TestRig"


. "$HOME/.local/bin/env"

export PATH=$PATH:/home/sigmazer/.spicetify
export PATH=$PATH:"/opt/fasm/"
export PATH=$PATH:"/opt/Steam/"

export PATH=$PATH:'/var/lib/flatpak/app/fr.handbrake.ghb/x86_64/stable/active/export/bin'
export PATH=$PATH:/usr/local/go/bin

