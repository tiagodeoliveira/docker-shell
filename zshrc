export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8

export ZSH=/root/.oh-my-zsh

ZSH_THEME="agnoster"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" 

[ ! -z "$(ls -A /keys)" ] && eval `ssh-agent -s` && ssh-add /keys/*

git config --global user.email "tiago@tiago.sh"
git config --global user.name "Tiago Rodrigues de Oliveira"
git config --global push.default simple
