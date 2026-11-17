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

    # Install Mac App Store CLI (mas)
    if ! command -v mas &> /dev/null; then
        brew install --yes mas
        # WARN: installed applications aren't enumerated immediately, `mas list` may return nothing
    else
        # If there are no installed applications, it could be because a newer OS version needs a newer version of 'mas'
        mas list | grep -Eq '^[0-9]+  ' || brew upgrade --yes mas
    fi

    # Update Xcode & Command Line Tools (some Homebrew packages require it)
    if mas outdated | grep -q 497799835; then
        if ! sudo -n true &> /dev/null; then
            echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'mas upgrade'"
        fi
        mas upgrade 497799835
    fi
    if softwareupdate --list | grep -q "Label: Command Line Tools"; then
        if ! sudo -n true &> /dev/null; then
            echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'xcode-select --install' or 'softwareupdate --install'"
        fi
        CLT_LABEL=$(softwareupdate --list | grep "Label: Command Line Tools" | head -n 1 | sed 's/^.*Label: //')
        if [[ -n "${CLT_LABEL}" ]]; then
            sudo xcode-select --install || sudo softwareupdate --install "${CLT_LABEL}"
        fi
    fi
    if command -v xcodebuild &> /dev/null; then
        if ! sudo -n true &> /dev/null; then
            echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'xcodebuild -license'"
        fi
        sudo xcodebuild -license status || sudo xcodebuild -license accept || true
    fi

    brew update
    brew upgrade --yes

    # Install Homebrew formulas
    command -v agent-deck > /dev/null || (brew trust asheshgoplani/tap && brew install --yes asheshgoplani/tap/agent-deck)
    if bash -c '(( BASH_VERSINFO[0] < 4 ))'; then
        # Overwrite the very old bash that ships with macOS
        brew install --yes bash
        HOMEBREW_BASH_PATH="$(brew --prefix bash)/bin/bash"
        if ! sudo -n true &> /dev/null; then
            echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'tee -a /etc/shells'"
        fi
        grep -qxF "${HOMEBREW_BASH_PATH}" /etc/shells || echo "${HOMEBREW_BASH_PATH}" | sudo tee -a /etc/shells
    fi
    command -v gawk   > /dev/null || brew install --yes gawk
    command -v gdate  > /dev/null || brew install --yes coreutils
    command -v gh     > /dev/null || brew install --yes gh
    if [[ ! -f "$(brew --prefix)/bin/git" ]]; then
        # Overwrite the very old git that ships with macOS
        brew install --yes git
        brew link --overwrite git
    fi
    command -v gsed   > /dev/null || brew install --yes gnu-sed
    if ! command -v hstr &> /dev/null; then
        brew install --yes hstr
        hstr --show-configuration >> ~/.bashrc
    fi
    command -v jq     > /dev/null || brew install --yes jq
    command -v rename > /dev/null || brew install --yes rename
    command -v rtk    > /dev/null || brew install --yes rtk
    command -v terminal-notifier > /dev/null || brew install --yes terminal-notifier
    command -v tree   > /dev/null || brew install --yes tree
    command -v watch  > /dev/null || brew install --yes watch
    command -v wget   > /dev/null || brew install --yes wget

    # Install Homebrew casks (only install if shell is interactive, in case of admin password prompt)
    if ! sudo -n true &> /dev/null; then
        echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'brew install --cask'"
    fi
    for cask in $(
        echo "1password"
        echo "claude"
        #echo "discord"
        echo "disk-expert"
        echo "docker-desktop"
        echo "firefox"
        #echo "font-meslo-for-powerlevel10k" # powerlevel10k
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
        echo "resilio-sync"
        #echo "sdformatter"
        echo "signal"
        #echo "slack"
        echo "spotify"
        echo "nahive/spotify-notify/spotify-notify"
        #echo "steam"
        #echo "telegram"
        echo "visual-studio-code"
        #echo "whatsapp"
        echo "wine-stable"
    ); do
        printf "Checking for cask '${cask}' ... "
        missing_apps=$(brew info --json=v2 --cask "${cask}" \
            | jq --raw-output ".casks[] | select(.token==\"${cask}\") | .artifacts[] | .app // empty | .[]" \
            | xargs -I {} sh -c 'test ! -d "/Applications/$1" && echo "$1"' _ {} || true)
        if [[ -n "${missing_apps}" ]]; then
            echo -e "\033[33mmissing, installing ...\033[0m"
            brew trust "${cask%/*}"
            brew install --yes --cask "${cask}"
        else
            echo -e "\033[92mfound\033[0m"
        fi
    done

    # Uninstall old Homebrew casks
    if ! sudo -n true &> /dev/null; then
        echo -e "\033[33mWARN:\033[0m you may be asked for your password to run 'brew uninstall --cask'"
    fi
    for cask in $(
        echo "charmstone"
        echo "feedflow"
        echo "messenger"
    ); do
        printf "Checking for cask '${cask}' ... "
        existing_apps=$(brew info --json=v2 --cask "${cask}" \
            | jq --raw-output ".casks[] | select(.token==\"${cask}\") | .artifacts[] | .app // empty | .[]" \
            | xargs -I {} sh -c 'test -d "/Applications/$1" && echo "$1"' _ {} || true)
        if [[ -n "${existing_apps}" ]]; then
            echo -e "\033[33mfound, uninstalling ...\033[0m"
            brew uninstall --cask "${cask}"
        else
            echo -e "\033[92mnot found\033[0m"
        fi
    done

    # Install App store applications
    mas upgrade
    mas_list=$(mas list)
    for app_id in $(
        # ----- Applications -----
        # Amphetamine
        echo "937984704"
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
