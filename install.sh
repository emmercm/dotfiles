#!/usr/bin/env bash
set -euo pipefail

here="${PWD}"
# shellcheck disable=SC2064
trap "cd \"${here}\"" EXIT
cd "$(dirname "$0")"


# Given a filename, echo the first rotated name that does not exist
function backup() {
    NUM=1
    while [[ -e "$1.${NUM}" ]]; do
        NUM=$(expr ${NUM} + 1)
    done
    echo "$1.${NUM}"
}

# Given a path and expression, safely link all files to the home directory
function link() {
    # Create symlinks
    while read -r FILE; do
        LINK="${HOME}/$(basename "${FILE}")"

        # Ensure symlink is actually a dotfile
        if [[ "$(basename "${LINK}")" != .* ]]; then
            LINK="$(dirname "${LINK}")/.$(basename "${LINK}")"
        fi

        # Assume symlinks are ok
        if [[ -h "${LINK}" ]]; then
            continue
        fi

        # Back up the existing file
        if [[ -e "${LINK}" ]]; then
            mv "${LINK}" "$(backup "${LINK}")"
        fi

        # Symlink the file
        ln -s "${FILE}" "${LINK}"
    done <<< "$(find "$1" -maxdepth 1 -name "$2" ! -name ".git" ! -name ".github" ! -name ".gitignore")"

    # Delete broken symlinks
    while read -r FILE; do
        rm -f "${FILE}"
    done <<< "$(find "${HOME}" -type l -maxdepth 1 ! -exec test -e {} \; -print)"
}


# Add Git hook symlinks
if [[ -d "$(pwd)/.git/hooks" ]]; then
    rm -rf "$(pwd)/.git/hooks"
fi
ln -s "$(pwd)/.githooks" "$(pwd)/.git/hooks"
chmod +x "$(pwd)/.git/hooks"/*

# Remove old, broken symlinks
find "${HOME}" -maxdepth 1 -name ".*.bash" -type l ! -exec test -e {} \; -delete

# Link dotfiles to home directory
link "$(pwd)" ".*"

# Reload powerline if installed
if command -v powerline-daemon &> /dev/null; then
    powerline-daemon --quiet --replace
fi
