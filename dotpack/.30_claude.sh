##### https://code.claude.com/docs/en/overview

export PATH="$HOME/.local/bin:$PATH"

export RTK_TELEMETRY_DISABLED=1

__claude_update() {
    # Auto-update Claude once a day
    if [[ "${1:-}" != "update" ]] && throttle "CLAUDE_AUTO_UPDATE_SECS" 86400; then
        command claude update
    fi

    # Auto-update Claude marketplaces once a week
    if throttle "CLAUDE_AUTO_UPDATE_PLUGINS_SECS" 604800; then
        command claude plugin marketplace list --json | jq -r '.[].name' | xargs -I {} command claude plugin marketplace update {}
    fi
}

__claude_auto_update() {
    if command -v claude &> /dev/null; then
        claude() {
            # Uninstall non-native copies
            if npm list --global @anthropic-ai/claude-code > /dev/null; then
                npm uninstall --global @anthropic-ai/claude-code > /dev/null
            fi
            if command -v volta &> /dev/null && volta list --format plain | grep -q "@anthropic-ai/claude-code"; then
                volta uninstall @anthropic-ai/claude-code > /dev/null
            fi
            if command -v brew &> /dev/null && brew list claude-code &> /dev/null; then
                brew uninstall claude-code > /dev/null
            fi

            # Commands to skip updating before
            if [[ " $* " = *" -h "* || " $* " == *" --help "* || " $* " == *" -p "* || " $* " == *" --print "* ]]; then
                command claude "$@"
                return $?
            fi
            __claude_update

            command claude "$@"
            return $?
        }
    fi
}
__claude_auto_update


__claude_lazy_install() {
    if ! command -v claude &> /dev/null; then
        claude() {
            curl -fsSL https://claude.ai/install.sh | bash
            unset -f claude
            claude "$@"
        }
    fi
}
__claude_lazy_install


__agent_deck_auto_update() {
    if command -v agent-deck &> /dev/null; then
        agent-deck() {
            __claude_update

            # Auto-update Claude once a day
            if [[ "${1:-}" != "update" ]] && throttle "AGENT_DECK_AUTO_UPDATE_SECS" 86400; then
                yes | command agent-deck update
            fi

            command agent-deck "$@"
            return $?
        }
    fi
}
__agent_deck_auto_update
