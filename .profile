# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    . ~/.bashrc
fi
