__nodejs_nvm() {
    # Lazy load nvm because it is notoriously slow
    export NVM_DIR="$HOME/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        nvm() {
            # Unset this function so it's never called again in this session
            unset -f "$0"

            # Load nvm
            . "$NVM_DIR/nvm.sh"

            # Load nvm's bash completions
            if [[ -s "$NVM_DIR/bash_completion" ]]; then
                . "$NVM_DIR/bash_completion"
            fi

            # Execute the intended command
            $0 "$@"
        }
    fi
}
__nodejs_nvm


__nodejs_volta() {
    if [[ -d "$HOME/.volta" ]]; then
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
    fi
}
__nodejs_volta


__nodejs_bun() {
    if [[ -d "$HOME/.bun/bin" ]]; then
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
    fi

    # Lazy-load shell completions
    if [[ -d "$HOME/.bun/_bun" ]]; then
        bun() {
            unset -f "$0"
            source "$HOME/.bun/_bun"
            $0 "$@"
        }
    fi
}
__nodejs_bun


__nodejs_funcs() {
    # @link https://github.com/npm/npm/issues/15536#issuecomment-392657820
    ndeprecated() {
        jq -r '.dependencies,.devDependencies|keys[] as $k|"\($k)@\(.[$k])"' package.json | while read -r line; do \
            printf "%s: " "${line}"
            [ "$(npm show "${line}" | grep --count --extended-regexp '^DEPRECATED')" != "0" ] && \
            printf "\e[1;31m""DEPRECATED\n""\e[0m" || \
            printf "\e[1;32m""not deprecated\n""\e[0m"
        done
    }

    # Find the minimum Node version supported by all package.json's engines
    # @param {string=} $1 Package name
    nengine() {
        if [[ $# -eq 0 ]]; then
            DIRS=$(npm ls --parseable 2> /dev/null | tail -n +2)
            RANGES=$(echo "${DIRS}" | while read -r DIR; do jq -r '.engines.node' "${DIR}/package.json" 2> /dev/null; done | grep -v null | sort --unique)
        else
            DEPS=$(npm-remote-ls "$1" | tail -n +2 | sed 's/^[^a-z0-9]*//' | sed 's/[ ].*//' | sort --unique)
            RANGES=$(echo "${DEPS}" | while read -r DEP; do npm view "${DEP}" engines.node; done;)
        fi

        # Simplify ^ and >= ranges
        RANGES=$(echo "${RANGES}" | sed 's/>=\?\s\?//g' | sed 's/\^//g' | sort --unique)

        # Parse || ranges
        RANGES=$(echo "${RANGES}" | while read -r RANGE; do echo "${RANGE}" | sed -e $'s/\|\|/\\\n/g' | sed 's/^ *//;s/ *$//' | sort --version-sort | head -1; done | sort --unique)

        # Simplify wildcards
        # shellcheck disable=SC2063
        RANGES=$(echo "${RANGES}" | sed 's/\(\.[\*x]\)*$//' | grep -v "*" | sort --unique)

        echo "${RANGES}" | sort --version-sort | tail -1
    }

    # Install a package from GitHub
    # @param {string} $1 GitHub "<user>/<repo>", e.g. emmercm/metalsmith-plugins
    # @param {string} $2 Branch name or commit hash
    # @param {string=} $3 Package subdirectory
    # @example ngit isaacs/rimraf v3
    # @example ngit emmercm/metalsmith-plugins 8e21383 packages/metalsmith-mermaid
    ngit() {
        local user_repo
        user_repo=$(echo "$1" | sed 's#^[a-z]*://[a-z.]*/\([^/]*/[^/]*\).*#\1#i')
        if [[ "${3:-}" == "" ]]; then
            npm install "git+https://github.com/${user_repo}#$2"
        else
            npm install "https://gitpkg.now.sh/${user_repo}/$3?$2"
        fi
    }
}
__nodejs_funcs
