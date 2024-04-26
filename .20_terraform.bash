__terraform_install() {
    if [[ -x "$(command -v terraform)" ]]; then
        return 0
    fi
    # Lazy install
    terraform() {
        if [[ -x "$(command -v brew)" ]]; then
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
        fi
        unset -f "$0"
        $0 "$@"
    }
}
__terraform_install


__tflint_install() {
    if [[ -x "$(command -v tflint)" ]]; then
        return 0
    fi
    # Lazy install
    tflint() {
        if [[ -x "$(command -v brew)" ]]; then
            brew install tflint
        elif [[-x "$(command -v docker)" ]]; then
            docker run --rm --volume "$(pwd):/data" --tty "ghcr.io/terraform-linters/tflint" "$@"
            return $?
        fi
        unset -f "$0"
        $0 "$@"
    }
}
__tflint_install
