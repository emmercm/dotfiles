# Don't use the git from macOS, use the Homebrew version instead
if command -v brew &> /dev/null && [[ ! -f "$(brew --prefix)/bin/git" ]]; then
    brew install git
    brew link --overwrite git
fi

if ! command -v git &> /dev/null; then
    return 0
fi


__git_completions() {
    # Bash completions
    if command -v brew &> /dev/null && [[ -f "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" && ! -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
        ln -sf "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" "$(brew --prefix)/etc/bash_completion.d/"
    fi
}
__git_completions


__git_funcs() {
    # Short alias
    alias g="git"
    if [[ "$(basename "${SHELL}")" == "bash" ]] && type _git &> /dev/null; then
        complete -o default -o nospace -F _git g
    fi

    # Shell alias Git aliases from the .gitconfig
    for al in $(git --list-cmds=alias; git --list-cmds=main); do
        # shellcheck disable=SC2139
        alias g${al}="git ${al}"
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
        stash_name="$(cat /dev/urandom | base32 | tr -dc 'A-Z0-9' | head -c 16)"
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
        origin_new="$(echo "${origin_old}" | sed 's#https://github.com/#git@github.com:#')"
        if [[ "${origin_new}" != "${origin_old}" && "${origin_new}" != "" ]]; then
            echo "Changing $(pwd) remote origin to: ${origin_new}"
            git remote set-url origin "${origin_new}"
        else
            echo "Not changing $(pwd) remote origin: ${origin_old}"
        fi
    }

    gupdate() {
        git pull

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
