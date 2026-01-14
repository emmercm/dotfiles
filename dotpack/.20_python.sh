##### https://www.python.org/

__python_setup() {
    while read -r DIR; do
        export PATH="${DIR}:${PATH}"
    done <<< "$(find ~/Library/Python/* -maxdepth 1 -type d -name bin 2> /dev/null)"
}
__python_setup


__python_pyenv() {
    PYENV_ROOT="${HOME}/.pyenv"
    if [[ ! -d "${PYENV_ROOT}" ]]; then
        return 0
    fi
    export PYENV_ROOT
    unset -f pyenv &> /dev/null

    # `pyenv init -` but with some portability tweaks
    # shellcheck disable=SC1078
    PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
    for i in ${!paths[@]}; do 
    if [[ ${paths[i]} == "''${PYENV_ROOT}/shims''" ]]; then unset '\''paths[i]'\''; 
    fi; done; 
    echo "${paths[*]}"' )"
    PATH="${PYENV_ROOT}/shims:${PATH}"
    export PATH
    PYENV_SHELL=$(basename "${SHELL}")
    export PYENV_SHELL
    # source "$(dirname "$(readlink -f "$(which pyenv)")")/../completions/pyenv.zsh"
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


__python_pip() {
    if ! command -v pip &> /dev/null && command -v pip3 &> /dev/null; then
        alias pip=pip3
    fi
}
__python_pip


__python_packages() {
    if [[ -d ~/grpc_tools ]]; then
        export PATH=~/grpc_tools:$PATH
    fi
    if [[ -d ~/grpc_tools/grpc/bins/opt ]]; then
        export PATH=~/grpc_tools/grpc/bins/opt:$PATH
    fi
}
__python_packages
