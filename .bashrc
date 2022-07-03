# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && . "$HOME/.fig/shell/bashrc.pre.bash"

##### Fig (Pre) #####


# Bash: .bash_profile (macOS default) -> .profile (Ubuntu default) -> .bashrc -> .everythingrc

# Load .everythingrc
if [[ -s ~/.everythingrc ]]; then
    # shellcheck source=.everythingrc
    . ~/.everythingrc
fi


##### Fig (Post) #####

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && . "$HOME/.fig/shell/bashrc.post.bash"
