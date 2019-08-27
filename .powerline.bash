# pip3 install --user powerline-status powerline-gitstatus

if [[ -x "$(command -v powerline-daemon)" ]]; then
    powerline-daemon --quiet
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . "$(pip3 show powerline-status | grep "Location:" | awk '{print $2}')/powerline/bindings/bash/powerline.sh"
fi
