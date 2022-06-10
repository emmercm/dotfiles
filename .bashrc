# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc
# zsh:  .zshrc (always executed) -> .bashrc

##### Fig (Pre) #####

. "$HOME/.fig/shell/bashrc.pre.bash"

##### Bash #####

# Load bash-completion
if [[ "$(basename "$(ps -o comm= $$)")" == "bash" && -x "$(command -v brew)" ]]; then
    if [[ ! -f "$(brew --prefix)/etc/bash_completion" ]]; then
        brew install zsh-completions
    fi
    . "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
reload() {
    exec "$(ps -o comm= $$)"
}


##### Misc #####

__bashrc_misc() {
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
        EDITOR=$(pinpoint nano)
        export EDITOR
    fi

    # Navigation helpers
    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias .....="cd ../../../.."

    # Colorize various commands
    # shellcheck disable=SC2139,SC2262
    alias ls="command ls $(if ls --color &> /dev/null; then echo "--color"; else echo "-G"; fi)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # ls shortcuts
    alias ll="ls -alF"
    lsd() {
        for DIR in "${@:-.}"/*; do
            if [[ -d "${DIR}" ]]; then
                echo "${DIR}"
            fi
        done
    }
    lsf() {
        for FILE in "${@:-.}"/*; do
            if [[ ! -d "${FILE}" ]]; then
                echo "${FILE}"
            fi
        done
    }

    # Jokes
    alias please="sudo"
    alias yeet="rm -rf"

    # Helpers
    if [[ -x "$(command -v beep)" ]]; then
        alias beep="echo -ne '\007'"
    fi
}
__bashrc_misc


##### IDEs #####

__bashrc_ides() {
    if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi
    if [[ -d "/Applications/VSCodium.app/Contents/Resources/app/bin" ]]; then
        export PATH="$PATH:/Applications/VSCodium.app/Contents/Resources/app/bin"
        alias code=codium
    fi
}
__bashrc_ides


##### Git #####

__bashrc_git() {
    # Short alias
    alias g="git"
    if [[ "$(basename "$(ps -o comm= $$)")" == "bash" ]] && type _git &> /dev/null; then
        complete -o default -o nospace -F _git g
    fi

    # Git config aliases
    for al in $(git --list-cmds=alias); do
        # shellcheck disable=SC2139
        alias g${al}="git ${al}"
        if type __git_aliased_command &> /dev/null; then
            complete_func=_git_$(__git_aliased_command ${al})
            type ${complete_func} &> /dev/null && __git_complete g${al} ${complete_func}
        fi
    done

    gupdate() {
        GIT_BRANCH=$(git branch --show-current)
        git stash --include-untracked
        if [[ $(git branch --list main) ]]; then
            git checkout main
        else
            git checkout master
        fi
        git pull
        git checkout "${GIT_BRANCH}"
        git stash pop
        # git merge origin/main
    }

    # Get the most recent versions from Git tags
    # @param {number=} $1 Number of versions to show
    gvs() {
        git tag --sort=-version:refname | grep -E '^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' | head -${1:-10}
    }

    # Get the most recent version from Git tags
    alias gv="gvs 1"
}
__bashrc_git


##### Golang #####

__bashrc_golang() {
    # Set path environment variables
    if [[ -x "$(command -v go)" ]]; then
        if [[ ! -d "${GOROOT}" ]]; then
            GOROOT=$(realpath "$(which go)" | sed 's/\/bin\/go$//')
            export GOROOT
        fi

        GOPATH=$(go env GOPATH)
        export GOPATH
        if [[ ! -d "${GOPATH}" ]]; then
            mkdir -p "${GOPATH}"
            mkdir "${GOPATH}/bin"
            mkdir "${GOPATH}/src"
        fi
        PATH="$PATH:$(go env GOPATH)/bin"
        export PATH
    fi
}
__bashrc_golang


##### Java #####

__bashrc_java() {
    while read -r DIR; do
        export JAVA_HOME="${DIR}"
    done <<< "$(find /Library/Java/JavaVirtualMachines/*/Contents -type d -name Home 2> /dev/null | sort --version-sort)"
}
__bashrc_java


##### MySQL #####

__bashrc_mysql() {
    # Set path environment variables
    if [[ -x "$(command -v brew)" ]]; then
        while read -r DIR; do
            if [[ -d "${DIR}/bin" ]]; then
                export PATH="${DIR}/bin:${PATH}"
            fi
        done <<< "$(find "$(brew --prefix)/opt" -maxdepth 1 -name "mysql-client*")"
    fi
}
__bashrc_mysql


##### Node.js #####

__bashrc_nodejs() {
    # Set path environment variables
    export NVM_DIR="$HOME/.nvm"
    # [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
    # [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
__bashrc_nodejs


##### Python #####

__bashrc_python() {
    while read -r DIR; do
        export PATH="${DIR}:${PATH}"
    done <<< "$(find ~/Library/Python -type d -name bin 2> /dev/null)"

    if [[ -d ~/grpc_tools ]]; then
        export PATH=~/grpc_tools:$PATH
    fi
    if [[ -d ~/grpc_tools/grpc/bins/opt ]]; then
        export PATH=~/grpc_tools/grpc/bins/opt:$PATH
    fi
}
__bashrc_python


##### Everything Else #####

while read -r FILE; do
    # shellcheck disable=SC1090
    source "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".*.bash" | sort --version-sort)"

##### Fig (Post) #####

. "$HOME/.fig/shell/bashrc.post.bash"
