# zsh: .zshrc (always executed) -> .bashrc

# romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if [[ -s ~/.p10k.zsh ]]; then
    . ~/.p10k.zsh
fi

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    . ~/.bashrc
fi
