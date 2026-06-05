##### https://go.dev/

__golang_setup() {
    # Set path environment variables
    if command -v go &> /dev/null; then
        if [[ ! -d "${GOROOT}" ]]; then
            GOROOT=$(realpath "$(which go)" | sed 's/\/bin\/go$//')
            export GOROOT
        fi

        GOPATH=$(go env GOPATH)
        export GOPATH
        if [[ ! -d "${GOPATH}" ]]; then
            mkdir -p "${GOPATH}"
            mkdir "${GOPATH}/bin"
            mkdir "${GOPATH}/src"
        fi
        PATH="${PATH}:${GOPATH}/bin"
        export PATH
    fi
}
__golang_setup
