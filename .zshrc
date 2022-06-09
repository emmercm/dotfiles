# zsh: .zshrc (always executed) -> .bashrc

# romkatv/powerlevel10k
# shellcheck disable=SC2296
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "${P10K_INSTANT_PROMPT}" ]]; then
    . "${P10K_INSTANT_PROMPT}"
fi
if [[ -s ~/.p10k.zsh ]]; then
    . ~/.p10k.zsh
fi

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    . ~/.bashrc
fi
