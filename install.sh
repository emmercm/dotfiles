#!/usr/bin/env bash
set -euo pipefail
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

# Git settings
if [[ -x "$(command -v git)" && -s ~/.gitignore_global ]]; then
    git config --global core.excludesfile ~/.gitignore_global
fi

# macOS settings
if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    # HID settings
    defaults write .GlobalPreferences com.apple.mouse.scaling -1

    # Finder settings
    defaults write com.apple.Finder AppleShowAllFiles true
    killall Finder
fi

# Reload powerline if installed
if [[ -x "$(command -v powerline-daemon)" ]]; then
    powerline-daemon --quiet --replace
fi
