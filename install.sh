#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"


# Given a filename, echo the first rotated name that does not exist
function backup() {
    NUM=1
    while [ -f "$1.${NUM}" ]; do
        NUM=$(expr ${NUM} + 1)
    done
    echo "$1.${NUM}"
}


# For each dotfile in the current directory
find "$(pwd)" -type f -name ".*" | while read -r FILE; do
    LINK="${HOME}/$(basename "${FILE}")"
    echo ${FILE}
    echo ${LINK}

    # Assume symlinked files are ok
    if [ -h "${LINK}" ]; then
        continue
    fi

    # Back up the existing file
    if [ -f "${LINK}" ]; then
        mv "${LINK}" "$(backup "${LINK}")"
    fi

    # Symlink the file
    ln -s "${FILE}" "${LINK}"
done

# Add global .gitignore if git is installed
if [ -x "$(command -v git)" ]; then
    git config --global core.excludesfile ~/.gitignore_global
fi
