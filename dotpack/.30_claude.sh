##### https://code.claude.com/docs/en/overview

export RTK_TELEMETRY_DISABLED=1

__claude_auto_update() {
    if command -v claude &> /dev/null; then
        claude() {
            if [[ "${1:-}" != "update" ]]; then
                command claude update
            fi

            #if [[ " $@ " != *" --resume "* && " $@ " != *" --session-id "* ]]; then
            #    command claude "$@" --continue
            #else
            #    command claude "$@"
            #fi

            command claude "$@"
        }
    fi
}
__claude_auto_update


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
