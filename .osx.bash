if [[ "${OSTYPE}" != "darwin"* ]]; then
    return 0
fi

alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `realpath` by default, so emulate it
# @link https://stackoverflow.com/a/18443300
command -v realpath > /dev/null || realpath() {
    OURPWD=$PWD
    cd "$(dirname "$1")"
    LINK=$(readlink "$(basename "$1")")
    while [ "$LINK" ]; do
        cd "$(dirname "$LINK")"
        LINK=$(readlink "$(basename "$1")")
    done
    REALPATH="$PWD/$(basename "$1")"
    cd "$OURPWD"
    echo "$REALPATH"
}

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

if [[ -x "$(command -v brew)" ]]; then
    command -v rename > /dev/null || brew install rename
    command -v tree   > /dev/null || brew install tree
    command -v watch  > /dev/null || brew install watch

    if [[ ! -x "$(command -v hstr)" ]]; then
        brew install hstr
        hstr --show-configuration >> ~/.bashrc
    fi
fi
