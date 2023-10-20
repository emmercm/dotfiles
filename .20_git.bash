if [[ ! -x "$(command -v git)" ]]; then
    return 0
fi


__git_completions() {
    # Bash completions
    if [[ -x "$(command -v brew)" && -f "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" && ! -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
        ln -sf "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" "$(brew --prefix)/etc/bash_completion.d/"
    fi
}
__git_completions


__git_funcs() {
    # Short alias
    alias g="git"
    if [[ "$(basename "$(ps -o comm= $$ | sed 's/^-*//')")" == "bash" ]] && type _git &> /dev/null; then
        complete -o default -o nospace -F _git g
    fi

    # Shell alias Git aliases from the .gitconfig
    for al in $(git --list-cmds=alias); do
        # shellcheck disable=SC2139
        alias g${al}="git ${al}"
        if type __git_aliased_command &> /dev/null; then
            complete_func=_git_$(__git_aliased_command ${al})
            type ${complete_func} &> /dev/null && __git_complete g${al} ${complete_func}
        fi
    done

    gempty() {
        git commit --allow-empty --message='Empty commit'
    }

    gupdate() {
        # git stash --include-untracked

        # git pull --rebase=merges

        # local git_branch
        # git_branch=$(git branch --show-current)
        # if [[ $(git branch --list main) ]]; then
        #     git checkout main
        # else
        #     git checkout master
        # fi
        # git pull
        # git checkout "${git_branch}"

        if [[ $(git branch --list main) ]]; then
            git fetch origin main
            git merge --no-edit origin/main
        else
            git fetch origin master
            git merge --no-edit origin/master
        fi

        # if [[ $(git branch --list main) ]]; then
        #     git checkout origin/main
        # else
        #     git checkout origin/master
        # fi

        # git stash pop
    }

    # Get the most recent versions from Git tags
    # @param {number=} $1 Number of versions to show
    gvs() {
        git tag --sort=-version:refname | grep -E '^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' | head -${1:-10}
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
