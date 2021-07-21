# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc
# zsh:  .zshrc (always executed) -> .bashrc

##### Fig (Pre) #####

[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh

##### Bash #####

# Load bash-completion
if [[ "$(basename "${SHELL}")" == "bash" && -x "$(command -v brew)" && -s "$(brew --prefix)/etc/bash_completion" ]]; then
    source "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
alias reload="exec ${SHELL}"


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

# Jokes
alias please="sudo"
alias yeet="rm -rf"

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


##### Java #####

while read -r DIR; do
    export JAVA_HOME="${DIR}"
done <<< "$(find /Library/Java/JavaVirtualMachines/*/Contents -type d -name Home 2> /dev/null)"


##### MySQL #####

# Set path environment variables
if [[ -x "$(command -v brew)" ]]; then
    while read -r DIR; do
        if [[ -d "${DIR}/bin" ]]; then
            export PATH="${DIR}/bin:${PATH}"
        fi
    done <<< "$(find "$(brew --prefix)/opt" -maxdepth 1 -name "mysql-client*")"
fi


##### Node.js #####

# Set path environment variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


##### Python #####

while read -r DIR; do
    export PATH="${DIR}:${PATH}"
done <<< "$(find ~/Library/Python -type d -name bin 2> /dev/null)"


##### Everything Else #####

while read -r FILE; do
    source "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".*.bash")"

##### Fig (Post) #####

[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
