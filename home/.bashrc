# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc -> .everythingrc

# Load .everythingrc
if [[ -s ~/.everythingrc ]]; then
    # shellcheck source=.everythingrc
    . ~/.everythingrc
fi
