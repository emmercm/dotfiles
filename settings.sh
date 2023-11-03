#!/usr/bin/env bash
set -euo pipefail


# Git settings
if [[ -x "$(command -v git)" && -s ~/.gitignore_global ]]; then
    git config --global core.excludesfile ~/.gitignore_global
fi

# macOS settings
if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    # https://rectangleapp.com/
    # https://linearmouse.app/
    # https://brew.sh/

    # ***** Settings > Wi-Fi *****

    # ***** Settings > Bluetooth *****

    # ***** Settings > Network *****

    # ***** Settings > Notifications *****

    # ***** Settings > Sound *****
    defaults write .GlobalPreferences com.apple.sound.beep.volume -float 0.5
    defaults write .GlobalPreferences com.apple.sound.beep.feedback -bool true

    # ***** Settings > Focus *****

    # ***** Settings > Screen Time *****

    # ***** Settings > General > Software Update *****
    # sudo softwareupdate --schedule ON
    # sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES

    # ***** Settings > Appearance *****
    # NOTE: appearance change requires restart
    defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
    defaults write .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically -bool false
    defaults write .GlobalPreferences AppleAccentColor 1
    defaults write .GlobalPreferences AppleShowScrollBars -string "Always"

    # ***** Settings > Accessibility *****

    # ***** Settings > Control Center *****
    # https://apple.stackexchange.com/a/337179
    defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
    defaults -currentHost write com.apple.controlcenter Sound -int 18
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
    defaults write com.apple.menuextra.clock Show24Hour -int 1
    killall SystemUIServer

    # ***** Settings > Siri & Spotlight *****

    # ***** Settings > Privacy & Security *****

    # ***** Settings > Desktop & Dock *****
    defaults write com.apple.dock autohide -bool false
    defaults write com.apple.dock magnification -bool false
    defaults write com.apple.dock orientation -string bottom
    defaults write com.apple.dock show-process-indicators -bool true
    defaults write com.apple.dock tilesize -int 45
    killall Dock

    # ***** Settings > Displays *****
    # TODO: Automatically adjust brightness off
    # TODO: True Tone off

    # ***** Settings > Wallpaper *****

    # ***** Settings > Screen Saver *****
    # defaults -currentHost write com.apple.screensaver idleTime -int 1800
    # defaults write com.apple.screensaver askForPasswordDelay -int 0

    # ***** Settings > Battery *****

    # ***** Settings > Lock Screen *****
    # Start screen saver when active for X seconds
    defaults -currentHost write com.apple.screensaver -int 300
    # Turn display off on battery/charger when active for X minutes
    sudo pmset -b displaysleep 10
    sudo pmset -c displaysleep 10
    # TODO: require password: 1min
    # Prevent automatic sleeping on power adapter when the display is off
    sudo pmset -c sleep 0
    # TODO: Night Shift from sunset to sunrise
    killall "System Settings"

    # ***** Settings > Touch ID & Password *****

    # ***** Settings > Users & Groups *****

    # ***** Settings > Passwords *****

    # ***** Settings > Internet Accounts *****

    # ***** Settings > Game Center *****

    # ***** Settings > Wallet & Apple Pay *****

    # ***** Settings > Keyboard *****
    # Turn off auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
    # TODO: keyboard brightness

    # ***** Settings > Mouse *****
    defaults write .GlobalPreferences com.apple.mouse.scaling -1

    # ***** Settings > Trackpad *****
    # Enable App Exposé of swipe down with three fingers
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    # ***** Finder *****
    # Always show file extensions
    defaults write .GlobalPreferences AppleShowAllExtensions -bool true
    defaults write com.apple.finder AppleShowAllFiles true
    # Use stacks on the desktop
    defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind
    # Search in the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Don't warn when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # View files in list most by default
    defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop 1
    defaults write com.apple.finder ShowHardDrivesOnDesktop 1
    defaults write com.apple.finder ShowMountedServersOnDesktop 1
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowRecentTags -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop 1
    defaults write com.apple.finder ShowStatusBar -bool true
    # Don't create some .DS_Store files
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    killall Finder

    # Desktop
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    killall Finder
fi
