##### https://code.claude.com/docs/en/overview

__claude_lazy_install() {
    if ! command -v claude &> /dev/null; then
        claude() {
            curl -fsSL https://claude.ai/install.sh | bash
            unset -f "$0"
            $0 "$@"
        }
    fi
}
__claude_lazy_install
