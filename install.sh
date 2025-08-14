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
    while read -r file; do
        local link
        link="${HOME}/$(basename "${file}")"

        # Ensure symlink is actually a dotfile
        if [[ "$(basename "${link}")" != .* ]]; then
            link="$(dirname "${link}")/.$(basename "${link}")"
        fi

        # Assume symlinks are ok
        if [[ -h "${link}" ]]; then
            echo "Ignoring: ${link}"
            continue
        fi

        # Back up the existing file
        if [[ -e "${link}" ]]; then
            local backup
            backup="$(backup "${link}")"
            echo "Moving: ${link} -> ${backup}"
            mv "${link}" "${backup}"
        fi

        # Symlink the file
        echo "Linking: ${link} -> ${file}"
        ln -s "${file}" "${link}"
    done <<< "$(find "$1" -maxdepth 1 -name "$2" ! -name ".git" ! -name ".github" ! -name ".gitignore")"

    # Delete broken symlinks
    while read -r file; do
        rm -f "${file}"
    done <<< "$(find "${HOME}" -maxdepth 1 -type l ! -exec test -e {} \; -print)"
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
