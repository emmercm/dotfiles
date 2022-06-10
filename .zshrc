# zsh: .zshrc (always executed) -> .bashrc

# Profile shell functions, output viewed with `zprof`
# zmodload zsh/zprof

# romkatv/powerlevel10k
# shellcheck disable=SC2296
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "${P10K_INSTANT_PROMPT}" ]]; then
    # shellcheck disable=SC1090
    . "${P10K_INSTANT_PROMPT}"
fi

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi
