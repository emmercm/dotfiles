##### https://vitess.io/
##### https://planetscale.com/

__vitess_completions() {
    if command -v pscale &> /dev/null; then
        pscale() {
            unset -f pscale
            # https://planetscale.com/docs/cli/completion
            # shellcheck disable=SC1090
            source <(pscale completion "$(basename "${SHELL}")")
            pscale "$@"
        }
    fi
}
__vitess_completions


__vitess_lazy_install() {
    # https://planetscale.com/docs/cli/planetscale-environment-setup#macos-instructions
    if ! command -v pscale &> /dev/null && command -v brew &> /dev/null; then
        pscale() {
            brew install planetscale/tap/pscale
            unset -f pscale
            pscale "$@"
        }
    fi
}
__vitess_lazy_install
