# Fig pre block. Keep at the top of this file.
# . "$HOME/.fig/shell/bashrc.pre.bash"

##### Fig (Pre) #####


# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc
# zsh:  .zshrc (always executed) -> .bashrc

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
    if [[ "${JAVA_HOME:-}" == "" && -x /usr/libexec/java_home ]]; then
        export JAVA_HOME=$(/usr/libexec/java_home -v 11)
    fi
    if [[ "${JAVA_HOME:-}" == "" ]]; then
        while read -r DIR; do
            export JAVA_HOME="${DIR}"
        done <<< "$(find /Library/Java/JavaVirtualMachines/*/Contents -type d -name Home 2> /dev/null | sort --version-sort)"
    fi
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

# Fig post block. Keep at the bottom of this file.
# . "$HOME/.fig/shell/bashrc.post.bash"
