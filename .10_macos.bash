if [[ "${OSTYPE:-}" != "darwin"* ]]; then
    return 0
fi


if [[ ! -x "$(command -v brew)" && -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


##### App installs #####

# Homebrew packages
if [[ -x "$(command -v brew)" ]]; then
    command -v gawk   > /dev/null || brew install gawk
    command -v gdate  > /dev/null || brew install coreutils
    command -v gsed   > /dev/null || brew install gnu-sed
    command -v jq     > /dev/null || brew install jq
    command -v rename > /dev/null || brew install rename
    command -v tree   > /dev/null || brew install tree
    command -v watch  > /dev/null || brew install watch
    command -v wget   > /dev/null || brew install wget

    if [[ ! -x "$(command -v hstr)" ]]; then
        brew install hstr
        hstr --show-configuration >> ~/.bashrc
    fi
fi

# App store applications
if [[ -x "$(command -v brew)" && ! -x "$(command -v mas)" ]]; then
    brew install mas
    # Installed applications aren't enumerated immediately, `mas list` may return nothing
fi
# if [[ -x "$(command -v mas)" ]]; then
#     mas_list=$(mas list)
#     # 1Password for Safari
#     # echo "${mas_list}" | grep '^1569813296 ' &> /dev/null || mas install 1569813296
#     # Menu World Time
#     # echo "${mas_list}" | grep '^1446377255 ' &> /dev/null || mas install 1446377255
# fi

# macOS DNS flush
flush() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}


##### Aliases #####

# Prefer GNU's coreutils binaries
command -v gdate > /dev/null && alias date="gdate"
command -v gsed > /dev/null && alias sed="gsed"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"
command -v sha256sum > /dev/null || alias sha256sum="shasum --algorithm 256"

alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

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
