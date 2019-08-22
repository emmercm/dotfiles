# .bash_profile (Ubuntu) -> .profile (OS X) -> .bashrc

# Load .profile
if [[ -s ~/.profile ]]; then
    . ~/.profile
fi
