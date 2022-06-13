# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc -> .everythingrc

# Load .profile
if [[ -s ~/.profile ]]; then
    # shellcheck source=.profile
    . ~/.profile
fi
