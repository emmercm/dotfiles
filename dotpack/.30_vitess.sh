##### https://vitess.io/
##### https://planetscale.com/

__vitess_lazy_install() {
    # https://planetscale.com/docs/cli/planetscale-environment-setup#macos-instructions
    if ! command -v pscale &> /dev/null && command -v brew &> /dev/null; then
        pscale() {
            brew install planetscale/tap/pscale
            unset -f "$0"
            $0 "$@"
        }
    fi
    if ! command -v mysql &> /dev/null && command -v brew &> /dev/null; then
        mysql() {
            brew install mysql-client
            unset -f "$0"
            $0 "$@"
        }
    fi
}
__vitess_lazy_install
