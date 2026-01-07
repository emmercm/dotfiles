__nodejs_version_managers() {
    # nvm
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Volta
    if [[ -d "$HOME/.volta" ]]; then
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
    fi

    # nodenv
    if command -v nodenv &> /dev/null; then
        eval "$(nodenv init - "$(basename "${SHELL}")")"
    fi
}
__nodejs_version_managers


if command -v npm &> /dev/null; then
    PATH="$(npm get prefix --global)/bin:$PATH"
    export PATH
fi


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
    # @param {string=} $1 npm list depth
    # @see https://github.com/npm/npm/issues/15536#issuecomment-392657820
    ndeprecated() {
        npm list "--depth=${1:-0}" | awk '{ print $NF }' | tail -n +2 | grep -v 'deduped' | while read -r line; do \
            printf "%s: " "${line}"
            [ "$(npm view "${line}" | grep -Ec '^DEPRECATED')" != "0" ] && \
            printf "\e[1;31m""DEPRECATED\n""\e[0m" || \
            printf "\e[1;32m""not deprecated\n""\e[0m"
        done
    }

    # @param {string=} $1 npm list depth
    # @see https://stackoverflow.com/a/70591428
    nmodified() {
        npm list "--depth=${1:-0}" | awk '{ print $NF }' | tail -n +2 | grep -v 'deduped' | \
            xargs -I {} bash -c "npm view {} time.modified _id | awk '{print \$3}' | sed -e \"s/'//g\" | tr '\n' ' ' && echo" | \
            sort
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
