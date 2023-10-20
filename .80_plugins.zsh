##### Plugin Manager #####

# Install Antidote
if [[ ! -d ${ZDOTDIR:-~}/.antidote ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Load Antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt


##### Plugins Additional Code #####

# zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


##### Theme #####

# Load the theme
if [[ -d ~/Library/Fonts && "$(find ~/Library/Fonts -maxdepth 1 -follow -type f -name "*MesloLGS NF*")" == "" ]]; then
    git clone https://github.com/romkatv/powerlevel10k-media.git --depth=1
    cd powerlevel10k-media || return 1
    cp *.ttf ~/Library/Fonts
    cd ..
    rm -rf powerlevel10k-media
	osascript <<- EOF
		tell application "Terminal"
			set ProfileNames to name of every settings set
			repeat with ProfileName in ProfileNames
				set font name of settings set ProfileName to "MesloLGS NF"
			end repeat
		end tell
	EOF
fi
