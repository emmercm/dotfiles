#!/usr/bin/env bash
set -euo pipefail

if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    # Ensure https://brew.sh/ is installed and loaded
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if [[ ! -x "$(command -v brew)" && -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew update
    brew upgrade

    # Install Homebrew formulas
    command -v gawk   > /dev/null || brew install gawk
    command -v gdate  > /dev/null || brew install coreutils
    command -v gh     > /dev/null || brew install gh
    if [[ ! -f "$(brew --prefix)/bin/git" ]]; then
        # Overwrite the very old git that ships with macOS
        brew install git
        brew link --overwrite git
    fi
    command -v gsed   > /dev/null || brew install gnu-sed
    if ! command -v hstr &> /dev/null; then
        brew install hstr
        hstr --show-configuration >> ~/.bashrc
    fi
    command -v jq     > /dev/null || brew install jq
    command -v rename > /dev/null || brew install rename
    command -v tree   > /dev/null || brew install tree
    command -v watch  > /dev/null || brew install watch
    command -v wget   > /dev/null || brew install wget

    # Install Homebrew casks (only install if shell is interactive, in case of admin password prompt)
    if ! sudo -n true &> /dev/null; then
        echo -e "\033[1;33mWARN:\033[0m you may be asked for your password to run 'brew install --cask'\n"
    fi
    for cask in $(
        echo "1password"
        echo "charmstone"
        #echo "discord"
        echo "docker-desktop"
        echo "firefox"
        echo "github"
        echo "hiddenbar"
        #echo "inkscape"
        echo "keka"
        echo "libreoffice"
        echo "linearmouse"
        #echo "maccy"
        #echo "nordvpn"
        #echo "postman"
        echo "rectangle"
        #echo "sdformatter"
        #echo "signal"
        #echo "slack"
        echo "spotify"
        #echo "steam"
        #echo "telegram"
        echo "visual-studio-code"
        echo "wine-stable"
    ); do
        printf "Checking for cask '${cask}' ... "
        missing_apps=$(brew info --json=v2 --cask "${cask}" \
            | jq --raw-output ".casks[] | select(.token==\"${cask}\") | .artifacts[] | .app // empty | .[]" \
            | xargs -I {} sh -c 'test ! -d "/Applications/{}" && echo "{}"' || true)
        if [[ -n "${missing_apps}" ]]; then
            echo "missing, installing ..."
            brew install --cask "${cask}"
        else
            echo "found"
        fi
    done

    # Install App store applications
    if ! command -v mas &> /dev/null; then
        brew install mas
        # WARN: installed applications aren't enumerated immediately, `mas list` may return nothing
    else
        # If there are no installed applications, it could be because a newer OS version needs a newer version of 'mas'
        mas list | grep -Eq '^[0-9]+  ' || brew upgrade mas
    fi
    mas_list=$(mas list)
    for app_id in $(
        # ----- Applications -----
        # Kindle
        echo "302584613"
        # Menu World Time
        # echo "1446377255"
        # ----- Safari Extensions -----
        # 1Password for Safari
        echo "1569813296"
        # Grammarly for Safari
        echo "1462114288"
    ); do
        echo "${mas_list}" | grep -Eq "^${app_id} " || mas install "${app_id}"
    done
fi
