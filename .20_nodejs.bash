__nodejs_nvm() {
    # Set path environment variables
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    # [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
__nodejs_nvm


__nodejs_funcs() {
    # Find the minimum Node version supported by all package.json's engines
    # @param {string=} $1 Package name
    nengine() {
        if [[ $# -eq 0 ]]; then
            DIRS=$(npm ls --parseable | tail -n +2)
            RANGES=$(echo "${DIRS}" | while read -r DIR; do jq -r '.engines.node' "${DIR}/package.json" 2> /dev/null; done | grep -v null | sort --unique)
        else
            DEPS=$(npm-remote-ls "$1" | tail -n +2 | sed 's/^[^a-z0-9]*//' | sed 's/[ ].*//' | sort --unique)
            RANGES=$(echo "${DEPS}" | while read -r DEP; do npm view "${DEP}" engines.node; done)
        fi

        # Simplify ^ and >= ranges
        RANGES=$(echo "${RANGES}" | sed 's/>=[ ]*//g' | sed 's/\^//g' | sort --unique)

        # Parse || ranges
        RANGES=$(echo "${RANGES}" | while read -r RANGE; do echo "${RANGE}" | sed -e $'s/\|\|/\\\n/g' | sed 's/^ *//;s/ *$//' | sort --version-sort | head -1; done | sort --unique)

        # Simplify wildcards
        RANGES=$(echo "${RANGES}" | sed 's/\(\.[\*x]\)*$//' | grep -v "*" | sort --unique)

        echo "${RANGES}" | sort --version-sort | tail -1
    }

    # @link https://github.com/npm/npm/issues/15536#issuecomment-392657820
    ndeprecated() {
        jq -r '.dependencies,.devDependencies|keys[] as $k|"\($k)@\(.[$k])"' package.json | while read line; do \
            printf "$line: "
            [ "$(npm show "$line" | grep -ic 'DEPRECATED')" != "0" ] && \
            printf "\e[1;31m""DEPRECATED\n""\e[0m" || \
            printf "\e[1;32m""not deprecated.\n""\e[0m"
        done
    }
}
__nodejs_funcs
