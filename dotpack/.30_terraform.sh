##### https://www.terraform.io/

__terraform_install() {
    if command -v terraform &> /dev/null; then
        return 0
    fi
    # Lazy install
    terraform() {
        if command -v brew &> /dev/null; then
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform
        fi
        unset -f "$0"
        $0 "$@"
    }
}
__terraform_install


__tflint_install() {
    if command -v tflint &> /dev/null; then
        return 0
    fi
    # Lazy install
    tflint() {
        if command -v brew &> /dev/null; then
            brew install tflint
        elif command -v docker &> /dev/null; then
            docker run --rm --volume "$(pwd):/data" --tty "ghcr.io/terraform-linters/tflint" "$@"
            return $?
        fi
        unset -f "$0"
        $0 "$@"
    }
}
__tflint_install
