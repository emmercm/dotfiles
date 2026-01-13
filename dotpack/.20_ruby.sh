##### https://www.ruby-lang.org/en/

__ruby_chruby() {
    # Lazy load chruby
    if [[ -d "${HOMEBREW_PREFIX}/opt/chruby/share/chruby" ]]; then
        chruby() {
            unset -f "$0"
            source "${HOMEBREW_PREFIX}/opt/chruby/share/chruby/chruby.sh"
            source "${HOMEBREW_PREFIX}/opt/chruby/share/chruby/auto.sh"
            $0 "$@"
        }
    fi

    # Auto-load the latest Ruby version
    if command -v chruby &> /dev/null && [[ -d ~/.rubies ]]; then
        chruby "$(ls -1 ~/.rubies/ | sort | tail -1)"
    fi
}
__ruby_chruby
