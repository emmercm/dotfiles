# bash: .bash_profile (macOS Default) -> .profile (Ubuntu Default) -> .bashrc
# zsh:  .zshrc (always executed) -> .bashrc

##### Bash #####

# Load bash-completion
if [[ "$(basename "${SHELL}")" == "bash" && -x "$(command -v brew)" && -s "$(brew --prefix)/etc/bash_completion" ]]; then
    source "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
alias reload=". ~/.bashrc"


##### Misc #####

# Navigation helpers
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Colorize various commands
alias ls="command ls $(if ls --color &> /dev/null; then echo "--color"; else echo "-G"; fi)"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls shortcuts
ll() {
    ls -alF
}
lsd() {
    ls -l "$@" | grep --color=never '^d'
}
lsf() {
    ls -l "$@" | grep --color=never '^-'
}

# macOS aliases
while read -r FILE; do
    source "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".macos.bash")"


##### Git #####

# Short alias
alias g="git"
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g
fi

# Git config aliases
for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
    alias g${al}="git ${al}"
    complete_func=_git_$(__git_aliased_command ${al})
    function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
done

# Get the most recent versions from Git tags
# @param {number=} $1 Number of versions to show
gvs() {
    git tag --sort=-version:refname | grep -E '^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' | head -${1:-10}
}

# Get the most recent version from Git tags
alias gv="gvs 1"


##### Golang #####

# Set path environment variables
if [[ -x "$(command -v go)" ]]; then
    if [[ ! -d "${GOROOT}" ]]; then
        export GOROOT=$(realpath "$(which go)" | sed 's/\/bin\/go$//')
    fi

    export GOPATH=$(go env GOPATH)
    if [[ ! -d "${GOPATH}" ]]; then
        mkdir "${GOPATH}"
        mkdir "${GOPATH}/bin"
        mkdir "${GOPATH}/src"
    fi
    export PATH=$PATH:$(go env GOPATH)/bin
fi


##### MySQL #####

# Set path environment variables
if [[ -d "$(brew --prefix)/opt/mysql-client/bin" ]]; then
    export PATH="$(brew --prefix)/opt/mysql-client/bin:${PATH}"
fi


##### Node.js #####

# Set path environment variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


##### Python #####

while read -r DIR; do
    export PATH="${DIR}:${PATH}"
done <<< "$(find ~/Library/Python -type d -name bin)"


##### Everything Else #####

while read -r FILE; do
    source "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".*.bash")"
