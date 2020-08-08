# pip3 install --user powerline-status powerline-gitstatus powerline-svnstatus powerline-kubernetes powerline-docker

# Only use powerline with bash
if [[ "$(basename "${SHELL}")" != "bash" ]]; then
    return 0
fi

# Install fonts
if [[ -d ~/Library/Fonts && "$(find ~/Library/Fonts -maxdepth 1 -follow -type f -name "*Powerline*")" == "" ]]; then
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
fi

# If installed run it
if [[ -x "$(command -v powerline-daemon)" ]]; then
    powerline-daemon --quiet
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . "$(pip3 show powerline-status | grep "Location:" | awk '{print $2}')/powerline/bindings/bash/powerline.sh"
fi
