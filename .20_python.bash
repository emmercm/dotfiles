__python_pyenv() {
    PYENV_ROOT="${HOME}/.pyenv"
    if [[ ! -d "${PYENV_ROOT}" ]]; then
        return 0
    fi
    export PYENV_ROOT
    unset -f pyenv &> /dev/null

    # `pyenv init -` but with some portability tweaks
    PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
    for i in ${!paths[@]}; do 
    if [[ ${paths[i]} == "''${PYENV_ROOT}/shims''" ]]; then unset '\''paths[i]'\''; 
    fi; done; 
    echo "${paths[*]}"')"
    export PATH="${PYENV_ROOT}/shims:${PATH}"
    export PYENV_SHELL=$(basename "${SHELL}")
    source "$(dirname "$(readlink -f "$(which pyenv)")")/../completions/pyenv.zsh"
    command pyenv rehash 2>/dev/null
    pyenv() {
        local command
        command="${1:-}"
        if [ "$#" -gt 0 ]; then
            shift
        fi

        case "$command" in
        rehash|shell)
            eval "$(pyenv "sh-$command" "$@")"
            ;;
        *)
            command pyenv "$command" "$@"
            ;;
        esac
    }
}
__python_pyenv
