if [[ "${OSTYPE:-}" != "darwin"* ]]; then
    return 0
fi


alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"
command -v sha256sum > /dev/null || alias sha256sum="shasum --algorithm 256"

if [[ ! -x "$(command -v brew)" && -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -x "$(command -v brew)" ]]; then
    command -v gawk   > /dev/null || brew install gawk
    command -v gsed   > /dev/null || brew install gnu-sed
    command -v jq     > /dev/null || brew install jq
    command -v rename > /dev/null || brew install rename
    command -v tree   > /dev/null || brew install tree
    command -v watch  > /dev/null || brew install watch

    if [[ ! -x "$(command -v hstr)" ]]; then
        brew install hstr
        hstr --show-configuration >> ~/.bashrc
    fi
fi

# macOS DNS flush
flush() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

# Prefer GNU's coreutils binaries
if [[ -x "$(command -v brew)" && -d "$(brew --prefix)/Cellar/coreutils" ]]; then
    alias date="gdate"
    alias sed="gsed"
fi

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

alias lsports="sudo lsof -iTCP -sTCP:LISTEN -n -P"
alias lsp=lsports

# macOS has no `realpath` by default, so emulate it
# @link https://stackoverflow.com/a/18443300
command -v realpath > /dev/null || realpath() {
    OURPWD=$PWD
    cd "$(dirname "$1")" || return 1
    LINK=$(readlink "$(basename "$1")")
    while [ "$LINK" ]; do
        cd "$(dirname "$LINK")" || return 1
        LINK=$(readlink "$(basename "$1")")
    done
    REALPATH="$PWD/$(basename "$1")"
    cd "$OURPWD" || return 1
    echo "$REALPATH"
}


##### JetBrains #####

if [[ "$(mdfind -name 'kMDItemFSName == "IntelliJ IDEA.app"')" != "" ]]; then
    intellij() {
        open -na "IntelliJ IDEA.app" --args "$@"
    }
    alias ij=intellij
    alias idea=intellij
fi
