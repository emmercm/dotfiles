# zsh: .zshrc (always executed) -> .bashrc

# romkatv/powerlevel10k
# shellcheck disable=SC2296
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "${P10K_INSTANT_PROMPT}" ]]; then
    # shellcheck disable=SC1090
    . "${P10K_INSTANT_PROMPT}"
fi
if [[ -s ~/.p10k.zsh ]]; then
    # shellcheck source=.p10k.zsh
    . ~/.p10k.zsh
fi

# Load zsh-completions
if [[ -x "$(command -v brew)" ]]; then
    if [[ ! -d "$(brew --prefix)/share/zsh-completions" ]]; then
        brew install zsh-completions
    fi

    # Git
    if [[ ! -f "$(brew --prefix)/share/zsh-completions/_git" ]]; then
        curl --output "$(brew --prefix)/share/zsh-completions/_git" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
    fi
    if [[ ! -f "$(brew --prefix)/share/zsh-completions/git-completion.bash" ]]; then
        curl --output "$(brew --prefix)/share/zsh-completions/git-completion.bash" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    fi
    zstyle ':completion:*:*:git:*' script "$(brew --prefix)/share/zsh-completions/git-completion.bash"

    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit && compinit
fi

# Load .bashrc
if [[ -s ~/.bashrc ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi
