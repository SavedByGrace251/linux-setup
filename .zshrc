# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source /home/linuxbrew/.linuxbrew/Cellar/antigen/2.2.3/share/antigen/antigen.zsh
antigen init ~/.antigenrc

eval "$(oh-my-posh init zsh --config ~/.local/themes/my-theme.omp.json)"

export UUID=02330bd0-ae90-4fca-b9e3-469c9c1a7861