# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc
# zsh:  .zshrc (always executed) -> .bashrc

##### Fig (Pre) #####

. "$HOME/.fig/shell/bashrc.pre.bash"

##### Bash #####

# Load bash-completion
if [[ "$(basename $(ps -o comm= $$))" == "bash" && -x "$(command -v brew)" && -s "$(brew --prefix)/etc/bash_completion" ]]; then
    source "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
alias reload="exec $(ps -o comm= $$)"


##### Misc #####

# `which` but better
#   https://emmer.dev/blog/reliably-finding-files-in-path/
pinpoint() {
    while read -r DIR; do
        if [[ -f "${DIR}/$1" ]]; then
            echo "${DIR}/$1"
            return 0
        fi
    done <<< "$(echo "${PATH}" | tr ':' '\n')"
    return 1
}

# Don't be a savage
if [[ -x "$(command -v nano)" ]]; then
    export EDITOR=$(pinpoint nano)
fi

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
alias ll="ls -alF"
lsd() {
    ls -l "$@" | grep --color=never '^d'
}
lsf() {
    ls -l "$@" | grep --color=never '^-'
}

# Jokes
alias please="sudo"
alias yeet="rm -rf"

# Helpers
if [[ -x "$(command -v beep)" ]]; then
    alias beep="echo -ne '\007'"
fi

# macOS aliases
if [[ -s ~/.macos.bash ]]; then
    # shellcheck source=.macos.bash
    . ~/.macos.bash
fi


##### IDEs #####

if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi
if [[ -d "/Applications/VSCodium.app/Contents/Resources/app/bin" ]]; then
    export PATH="$PATH:/Applications/VSCodium.app/Contents/Resources/app/bin"
    alias code=codium
fi


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
        mkdir -p "${GOPATH}"
        mkdir "${GOPATH}/bin"
        mkdir "${GOPATH}/src"
    fi
    export PATH="$PATH:$(go env GOPATH)/bin"
fi


##### Java #####

while read -r DIR; do
    export JAVA_HOME="${DIR}"
done <<< "$(find /Library/Java/JavaVirtualMachines/*/Contents -type d -name Home 2> /dev/null | sort --version-sort)"


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

if [[ -d ~/grpc_tools ]]; then
    export PATH=~/grpc_tools:$PATH
fi
if [[ -d ~/grpc_tools/grpc/bins/opt ]]; then
    export PATH=~/grpc_tools/grpc/bins/opt:$PATH
fi


##### Everything Else #####

while read -r FILE; do
    source "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".*.bash")"

##### Fig (Post) #####

. "$HOME/.fig/shell/bashrc.post.bash"
