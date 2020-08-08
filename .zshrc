# zsh: .zshrc (always executed) -> .bashrc

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    . ~/.bashrc
fi
