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
# @param {string} $1 Directory where dotfiles live (the root of the Git repo)
# @param {string} $1 Wildcard to find dotfiles
function link() {
    # Create symlinks
    find "$1" -maxdepth 1 -name "$2" ! -name ".DS_Store" | while read -r file; do
        local link
        link="${HOME}/$(basename "${file}")"

        # Ensure symlink is actually a dotfile
        if [[ "$(basename "${link}")" != .* ]]; then
            link="$(dirname "${link}")/.$(basename "${link}")"
        fi

        # Delete broken symlinks, skip valid ones
        if [[ -h "${link}" ]]; then
            if [[ ! -e "${link}" ]]; then
                echo -e "\033[91mDeleting broken symlink:\033[0m ${link}"
                rm -f "${link}"
            elif [[ -d "${link}" && ! -z "$(find "${link}" -mindepth 1 -print -quit)" ]]; then
                echo -e "\033[91mDeleting symlink to empty directory:\033[0m ${link}"
                rm -f "${link}"
            else
                echo -e "\033[33mIgnoring:\033[0m ${link}"
                continue
            fi
        fi

        # Back up the existing directory/file
        local backup=""
        if [[ -e "${link}" ]]; then
            backup="$(backup "${link}")"
            echo -e "\033[34mMoving:\033[0m ${link} -> ${backup}"
            mv "${link}" "${backup}"
        fi

        # Symlink the file
        echo -e "\033[92mLinking:\033[0m ${link} -> ${file}"
        ln -s "${file}" "${link}"

        # Restore existing directory files
        if [[ -n "${backup}" && -d "${backup}" ]]; then
            echo -e "\033[34mRestoring:\033[0m ${backup}/* -> ${link}/"
            cp -r "${backup}/." "${link}/"
        fi
    done

    # Delete broken symlinks
    find "${HOME}" -maxdepth 1 -type l ! -exec test -e {} \; -print | while read -r file; do
        echo -e "\033[91mDeleting broken symlink:\033[0m ${file}"
        rm -f "${file}"
    done
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
link "$(pwd)/home" ".*"

# Reload powerline if installed
if command -v powerline-daemon &> /dev/null; then
    powerline-daemon --quiet --replace
fi
