# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc

# Load .profile
if [[ -s ~/.profile ]]; then
    . ~/.profile
fi
