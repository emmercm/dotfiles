# bash: .bash_profile (macOS Default) -> .profile (Ubuntu Default) -> .bashrc

# Load .profile
if [[ -s ~/.profile ]]; then
    . ~/.profile
fi
