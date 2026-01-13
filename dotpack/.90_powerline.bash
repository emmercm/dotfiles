# pip3 install --user powerline-status powerline-gitstatus powerline-svnstatus powerline-kubernetes powerline-docker

# Install fonts
if [[ -d ~/Library/Fonts && "$(find ~/Library/Fonts -maxdepth 1 -follow -type f -name "*Powerline*")" == "" ]]; then
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts || return 1
    ./install.sh
    cd ..
    rm -rf fonts
fi

# If installed run it
if command -v powerline-daemon &> /dev/null; then
    powerline-daemon --quiet
    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1
    . "$(pip3 show powerline-status | grep "Location:" | awk '{print $2}')/powerline/bindings/bash/powerline.sh"
fi
