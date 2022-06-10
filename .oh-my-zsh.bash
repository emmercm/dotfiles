# Only use oh-my-zsh with zsh
if [[ "$(basename "$(ps -o comm= $$)")" != "zsh" ]]; then
    return 0
fi


# Install oh-my-zsh
ZSH=${ZSH:-~/.oh-my-zsh}
if [[ ! -d "${ZSH}" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# Install Antigen
if [[ ! -s "${ZSH}/antigen.zsh" ]]; then
    curl -L git.io/antigen > "${ZSH}/antigen.zsh"
fi

# Load Antigen
. "${ZSH}/antigen.zsh"


##### Antigen Config #####

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Prompt plugins
antigen bundle virtualenv

# Helper plugins
antigen bundle command-not-found

# First-party autocompletions and aliases
antigen bundle aws
antigen bundle gem
antigen bundle golang
antigen bundle gradle
antigen bundle heroku
antigen bundle mvn
antigen bundle npm
antigen bundle nvm
antigen bundle pip
antigen bundle pipenv
antigen bundle redis-cli
antigen bundle vagrant
antigen bundle yarn

# Autocompletions
antigen bundle lukechilds/zsh-better-npm-completion
antigen bundle srijanshetty/zsh-pip-completion
antigen bundle zsh-users/zsh-completions

# Fish-like suggestions, history searching, and syntax highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme romkatv/powerlevel10k
if [[ -d ~/Library/Fonts && "$(find ~/Library/Fonts -maxdepth 1 -follow -type f -name "*MesloLGS NF*")" == "" ]]; then
    git clone https://github.com/romkatv/powerlevel10k-media.git --depth=1
    cd powerlevel10k-media || return 1
    cp *.ttf ~/Library/Fonts
    cd ..
    rm -rf powerlevel10k-media
	osascript <<- EOF
		tell application "Terminal"
			set ProfilesNames to name of every settings set
			repeat with ProfileName in ProfilesNames
				set font name of settings set ProfileName to "MesloLGS NF"
			end repeat
		end tell
	EOF
fi

# Tell Antigen that you're done
antigen apply

# Fix some insecure directories?
# https://github.com/zsh-users/zsh-completions/issues/433
if [[ -x "$(command -v compaudit)" ]]; then
    while read -r FILE; do
        sudo chown -R "$(whoami)" "${FILE}"
        sudo chmod -R 755 "${FILE}"
    done <<< "$(compaudit 2> /dev/null)"
fi
