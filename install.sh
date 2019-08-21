#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"


# Given a filename, echo the first rotated name that does not exist
function backup() {
    NUM=1
    while [[ -f "$1.${NUM}" ]]; do
        NUM=$(expr ${NUM} + 1)
    done
    echo "$1.${NUM}"
}

# Given a path and expression, safely link all files to the home directory
function link() {
    find "$1" -maxdepth 1 -type f -name "$2" ! -iname ".gitignore" | while read -r FILE; do
        LINK="${HOME}/$(basename "${FILE}")"

        # Ensure symlink is actually a dotfile
        if [[ "$(basename "${LINK}")" != .* ]]; then
            LINK="$(dirname "${LINK}")/.$(basename "${LINK}")"
        fi

        # Assume symlinked files are ok
        if [[ -h "${LINK}" ]]; then
            continue
        fi

        # Back up the existing file
        if [[ -f "${LINK}" ]]; then
            mv "${LINK}" "$(backup "${LINK}")"
        fi

        # Symlink the file
        ln -s "${FILE}" "${LINK}"
    done
}


# Set up bash-completion
if [[ -x "$(command -v brew)" ]]; then
    if [[ ! -f $(brew --prefix)/etc/bash_completion ]]; then
        brew install bash-completion
    fi

    # Git
    if [[ -f "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]]; then
        ln -sf "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" "$(brew --prefix)/etc/bash_completion.d/"
    fi

    # Docker
    if [[ -d "/Applications/Docker.app" ]]; then
        find "/Applications/Docker.app" -type f -name "*.bash-completion" -exec ln -sf "{}" "$(brew --prefix)/etc/bash_completion.d/" \;
    fi
fi

# Link dotfiles to home directory
link "$(pwd)" ".*"

# Add global .gitignore if git is installed
if [[ -x "$(command -v git)" ]]; then
    git config --global core.excludesfile ~/.gitignore_global
fi
