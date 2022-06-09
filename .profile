# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi
