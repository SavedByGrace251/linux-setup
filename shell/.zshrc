# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

if [ -f ~/.setup/.zsh_aliases ]; then
    . ~/.setup/.zsh_aliases
fi


if [ -f ~/.setup/.zsh_functions ]; then
    . ~/.setup/.zsh_functions
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval "$(fasd --init auto)"

source /home/linuxbrew/.linuxbrew/Cellar/antigen/2.2.3/share/antigen/antigen.zsh
antigen init ~/.setup/.antigenrc

eval "$(oh-my-posh init zsh --config ~/.setup/my-theme.omp.json)"


