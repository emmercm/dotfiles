# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc -> .everythingrc

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi
