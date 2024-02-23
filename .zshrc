# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh" || true
##### Fig (Pre) #####


# zsh: .zshrc (always executed) -> .everythingrc

# Profile shell functions, output viewed with `zprof`
# zmodload zsh/zprof

# romkatv/powerlevel10k
# shellcheck disable=SC2296
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "${P10K_INSTANT_PROMPT}" ]]; then
    # shellcheck disable=SC1090
    . "${P10K_INSTANT_PROMPT}"
fi

# Load .everythingrc
if [[ -s ~/.everythingrc ]]; then
    # shellcheck source=.everythingrc
    . ~/.everythingrc
fi


##### Fig (Post) #####

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh" || true
