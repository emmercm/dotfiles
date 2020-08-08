# Only use oh-my-zsh with zsh
if [[ "$(basename "${SHELL}")" != "zsh" ]]; then
    return 0
fi


# Install oh-my-zsh
ZSH=${ZSH:-~/.oh-my-zsh}
if [[ ! -d "${ZSH}" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# Install Antigen
if [[ ! -s "${ZSH}/antigen.zsh" ]]; then
    curl -L git.io/antigen > "${ZSH}/antigen.zsh"
fi

# Load Antigen
. "${ZSH}/antigen.zsh"


##### Antigen Config #####

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
antigen bundle aws
antigen bundle brew
antigen bundle command-not-found
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle golang
antigen bundle node
antigen bundle npm
antigen bundle nvm
antigen bundle osx
antigen bundle pip
antigen bundle pipenv
antigen bundle redis-cli
antigen bundle vagrant
antigen bundle virtualenv

# Syntax highlighting bundle
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done
antigen apply
