##### https://git-scm.com/

if ! command -v git &> /dev/null; then
    return 0
fi


__git_addons() {
    # https://developer.1password.com/docs/ssh/get-started/#step-4-configure-your-ssh-or-git-client
    if [[ -e "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]; then
        export SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    fi
}
__git_addons


__git_funcs() {
    # Short alias
    alias g="git"
    if [[ "$(basename "${SHELL}")" == "bash" ]] && type _git &> /dev/null; then
        complete -o default -o nospace -F _git g
    fi

    # Shell alias Git aliases from the .gitconfig
    for al in $(git --list-cmds=alias; git --list-cmds=main); do
        # shellcheck disable=SC2139
        alias "g${al}"="git ${al}"
        if type __git_aliased_command &> /dev/null; then
            complete_func=_git_$(__git_aliased_command "${al}")
            type "${complete_func}" &> /dev/null && __git_complete "g${al}" "${complete_func}"
        fi
    done

    gempty() {
        git reset
        git commit --allow-empty --message='Empty commit'
    }

    grebase() {
        git pull

        local stash_name
        stash_name="$(base32 < /dev/urandom | tr -dc 'A-Z0-9' | head -c 16)"
        git stash push --message "${stash_name}" || return 1
        if [[ $(git branch --list main) ]]; then
            git fetch origin main:main
            git rebase origin/main
        else
            git fetch origin master:master
            git rebase origin/master
        fi
        git stash apply "stash^{/${stash_name}}"
    }

    gssh() {
        local origin_old
        origin_old="$(git remote get-url origin)"
        local origin_new
        origin_new="${origin_old/https:\/\/github.co\//git@github.com:}"
        if [[ "${origin_new}" != "${origin_old}" && "${origin_new}" != "" ]]; then
            echo "Changing $(pwd) remote origin to: ${origin_new}"
            git remote set-url origin "${origin_new}"
        else
            echo "Not changing $(pwd) remote origin: ${origin_old}"
        fi
    }

    # Copy changes from one clone to another
    # @param {string} $1 The original/old git root
    # @param {string} $2 The new git root
    gcopy() {
        git -C "$1" status --porcelain=v1 | while read -r state file; do
            if [[ "${state}" == *D* ]]; then
                # Copy deletions
                echo -e "\033[91mX\033[0m ${file}"
                rm -rf "${2:?}/${file}"
            elif [[ "${state}" == *R* ]]; then
                # Copy renames
                before="${file% -> *}"
                after="${file#* -> }"
                echo -e "\033[95m>\033[0m ${before} -> ${after}"
                git -C "$2" mv --force "${before}" "${after}"
                cp "$1/${after}" "$2/${after}"
            else
                # Copy modifications
                echo -e "\033[92m*\033[0m ${file}"
                mkdir -p "$2/$(dirname "${file}")"
                cp "$1/${file}" "$2/${file}"
            fi
        done
    }

    gupdate() {
        git pull > /dev/null

        if [[ $(git branch --list main) ]]; then
            git fetch origin main:main
            git merge --no-edit origin/main
        else
            git fetch origin master:master
            git merge --no-edit origin/master
        fi
    }

    # Get the most recent versions from Git tags
    # @param {number=} $1 Number of versions to show
    gvs() {
        git tag --sort=-version:refname | grep -E '^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' | head "-${1:-10}"
    }

    # Get the most recent version from Git tags
    alias gv="gvs 1"
}
__git_funcs


__git_hooks() {
    git() {
        # Delete Resilio Sync placeholders before doing any git action
        if [[ -d "/Applications/Resilio Sync.app" ]]; then
            local dir
            dir=$(pwd)
            while [[ "${dir}" != "/" && ! -d "${dir}/.git" ]]; do
                dir="$(dirname "${dir}")"
            done
            if [[ "${dir}" != "/" ]]; then
                find "${dir}/.git/refs" -name "*.rsl*" -exec rm {} \;
            fi
        fi

        command git "$@"
    }
}
__git_hooks
