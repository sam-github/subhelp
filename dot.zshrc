# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle :compinstall filename $HOME/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob prompt_subst
unsetopt nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

export PATH=".:./node_modules/.bin:$HOME/bin:/usr/local/bin:$PATH"
export PS1='%n@%m:%~ %# '

alias v="vim"
alias l="ls -l"
alias ls="ls -aF"
alias la='ls -a'
alias lo='libreoffice'
alias t=todo.sh
alias recur=". ~/.current"
alias realias=". $0"
alias volume=pavucontrol

# Git prompt
source ~/.git-prompt.sh

# * or + after branch
GIT_PS1_SHOWDIRTYSTATE=y
# $ after branch
GIT_PS1_SHOWSTASHSTATE=y
# % after branch
GIT_PS1_SHOWUNTRACKEDFILES=y
#
GIT_PS1_SHOWUPSTREAM=verbose

# export PS1='%n@%m:%~$(__git_ps1 " (%s)") %# '
export PS1='%2~$(__git_ps1 " (%s)") %# '

# Enable node repl history
export NODE_REPL_HISTORY_FILE=~/.node-histfile

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### No vagrant tests for strong-pm
export SKIP_VAGRANT=y

# Oracle Instantclient
# wget http://ci.strongloop.com/packer-assets/instantclient-basiclite-linux.x64-12.1.0.2.0.zip
# wget http://ci.strongloop.com/packer-assets/instantclient-sdk-linux.x64-12.1.0.2.0.zip

export OCI_HOME=/usr/local/lib/instantclient_12_1
export ORACLE_HOME=$OCI_HOME
export OCI_LIB_DIR=$OCI_HOME
export OCI_INC_DIR=$OCI_HOME/sdk/include
export OCI_INCLUDE_DIR=$OCI_INC_DIR

### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

### current/local setup

. ~/.current
