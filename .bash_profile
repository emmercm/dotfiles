# .bash_profile (OS X Default) -> .profile (Ubuntu Default) -> .bashrc

# Load .profile
if [[ -s ~/.profile ]]; then
    . ~/.profile
fi
