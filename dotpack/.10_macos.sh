if [[ "${OSTYPE:-}" != "darwin"* ]]; then
    return 0
fi


##### Homebrew #####

if [[ ! -x "$(command -v brew)" && -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
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

__homebrew_funcs() {
    # Install a specific version of a Homebrew formula
    # @param {string} $1 Formula name
    # @param {string} $2 Formula version (exact)
    vintage() {
        # Figure out the relevant tap
        local brew_tap
        local is_cask=false
        if brew search --cask "/^${1:?}$/" &> /dev/null; then
            brew_tap="homebrew/cask"
            is_cask=true
        else
            brew_tap="homebrew/core"
        fi

        # Ensure the appropriate tap is tapped and up to date
        if brew tap | grep -xq "${brew_tap}"; then
            brew update
        else
            brew tap --force "${brew_tap}"
        fi

        # Ensure homebrew/local is created
        brew tap | grep -xq homebrew/local \
            || brew tap homebrew/local

        if [ "${is_cask}" = false ]; then
            # If the formula is already installed, re-link it
            if brew list -1 | grep -xq "${1:?}@${2:?}"; then
                brew unlink "${1:?}@${2:?}"
                brew link --overwrite "${1:?}@${2:?}"
                return 0
            fi

            # Install the formula and ensure it's linked
            brew install "homebrew/local/${1:?}@${2:?}" \
                || brew link --overwrite "${1:?}@${2:?}"
        else (
            # Sub shell to make `cd` safe
            cd "$(brew --repository "${brew_tap}")" || return 1

            # Emulate `brew extract` for casks
            local cask_path
            cask_path=$(git ls-files 'Casks/*' | grep -E "/${1:?}\.rb$")
            local version_match
            version_match=$(git rev-list --all "${cask_path}" \
                | xargs -n1 -I% git --no-pager grep --fixed-strings "version \"${2:?}\"" % -- "${cask_path}" \
                2> /dev/null | head -1)
            local commit_hash="${version_match%%:*}"
            local local_cask_dir
            local_cask_dir="$(brew --repository homebrew/local)/Casks"
            if [ ! -d "${local_cask_dir}" ]; then
                mkdir -p "${local_cask_dir}"
            fi
            local local_cask_file="${local_cask_dir}/${1:?}@${2:?}.rb"
            git show "${commit_hash}:${cask_path}" \
                | sed "s/cask \"${1:?}\"/cask \"${1:?}@${2:?}\"/" \
                > "${local_cask_file}"

            # Install the formula
            brew install --cask "homebrew/local/${1:?}@${2:?}"
        ) fi
    }
}
__homebrew_funcs


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

intellij() {
    if [[ "$(mdfind -name 'kMDItemFSName == "IntelliJ IDEA.app"')" != "" ]]; then
        open -na "IntelliJ IDEA.app" --args "$@"
    else
        command intellij "$@"
    fi
}
alias ij=intellij
alias idea=intellij
