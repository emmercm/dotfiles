if [[ "${OSTYPE:-}" != "darwin"* ]]; then
    return 0
fi


##### Homebrew #####

if [[ ! -x "$(command -v brew)" && -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -x "$(command -v brew)" ]]; then
    brew() {
        if [[ "${1:-}" == "purge" ]]; then
            brew list | xargs command brew uninstall --force
            brew list --cask | xargs command brew uninstall --force
            return
        fi
        command brew "$@"
    }
fi


##### App installs #####

# Homebrew packages
if command -v brew &> /dev/null; then
    command -v dive   > /dev/null || brew install dive
    command -v gawk   > /dev/null || brew install gawk
    command -v gdate  > /dev/null || brew install coreutils
    command -v gsed   > /dev/null || brew install gnu-sed
    command -v jq     > /dev/null || brew install jq
    command -v rename > /dev/null || brew install rename
    command -v tree   > /dev/null || brew install tree
    command -v watch  > /dev/null || brew install watch
    command -v wget   > /dev/null || brew install wget

    if ! command -v hstr &> /dev/null; then
        brew install hstr
        hstr --show-configuration >> ~/.bashrc
    fi
fi

# App store applications
if command -v brew &> /dev/null && ! command -v mas &> /dev/null; then
    brew install mas
    # Installed applications aren't enumerated immediately, `mas list` may return nothing
fi
if command -v mas &> /dev/null; then
    mas_list=$(mas list)
    for app_id in $(
        # 1Password for Safari
        # echo "1569813296"
        # Kindle
        echo "302584613"
        # Menu World Time
        # echo "1446377255"
    ); do
        echo "${mas_list}" | grep "^${app_id} " &> /dev/null || mas install "${app_id}"
    done
fi

# macOS DNS flush
flush() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

# macOS DHCP renew
# @link https://apple.stackexchange.com/a/17429
renew() {
    sudo ipconfig set en0 BOOTP
    sudo ipconfig set en0 DHCP
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
