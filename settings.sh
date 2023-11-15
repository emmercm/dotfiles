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
    # Alert volume
    defaults write .GlobalPreferences com.apple.sound.beep.volume -float 0.5
    # Play feedback when volume is changed
    defaults write .GlobalPreferences com.apple.sound.beep.feedback -bool true

    # ***** Settings > Focus *****

    # ***** Settings > Screen Time *****

    # ***** Settings > General > Software Update *****
    # sudo softwareupdate --schedule ON
    # sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES

    # ***** Settings > Appearance *****
    # NOTE: appearance change requires restart
    # Appearance
    defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
    defaults write .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically -bool false
    # Accent color: orange
    defaults write .GlobalPreferences AppleAccentColor 1
    # Show scroll bars: always
    defaults write .GlobalPreferences AppleShowScrollBars -string "Always"

    # ***** Settings > Accessibility *****

    # ***** Settings > Control Center *****
    # Bluetooth: always show in menu bar
    defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
    # Sound: always show in menu bar
    defaults -currentHost write com.apple.controlcenter Sound -int 18
    # Battery - show percentage
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
    # Clock options... show AM/PM: false
    defaults write com.apple.menuextra.clock Show24Hour -int 1
    killall SystemUIServer

    # ***** Settings > Siri & Spotlight *****

    # ***** Settings > Privacy & Security *****

    # ***** Settings > Desktop & Dock *****
    # Size: smaller
    defaults write com.apple.dock tilesize -int 45
    # Magnification: off
    defaults write com.apple.dock magnification -bool false
    # Position on screen: bottom
    defaults write com.apple.dock orientation -string bottom
    # Automatically hide and show the dock: false
    defaults write com.apple.dock autohide -bool false
    # Show indicators for open applications: true
    defaults write com.apple.dock show-process-indicators -bool true
    killall Dock

    # ***** Settings > Displays *****
    # TODO: Automatically adjust brightness off
    # TODO: True Tone off
    # TODO: Night Shift... schedule: sunset to sunrise

    # ***** Settings > Wallpaper *****

    # ***** Settings > Screen Saver *****
    # defaults -currentHost write com.apple.screensaver idleTime -int 1800
    # defaults write com.apple.screensaver askForPasswordDelay -int 0

    # ***** Settings > Battery *****
    # Options... prevent automatic sleeping on power adapter when the display is off
    sudo pmset -c sleep 0

    # ***** Settings > Lock Screen *****
    # Start screen saver when inactive for X seconds
    defaults -currentHost write com.apple.screensaver -int 300
    # Turn display off on battery when inctive for X minutes
    sudo pmset -b displaysleep 10
    # Turn display off on power adapter when inctive for X minutes
    sudo pmset -c displaysleep 10
    # TODO: Require password after screen saver begins or display is turned off: 1min
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
    # More gestures... app exposé: swipe down with three fingers
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    # ***** Finder *****
    # Settings > general > show these items on the desktop: hard drives, external disks, CDs/DVDs/iPods, connected servers
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    # Settings > sidebar > recent tags
    defaults write com.apple.finder ShowRecentTags -bool false
    # Settings > advanced > show all filename extensions
    defaults write .GlobalPreferences AppleShowAllExtensions -bool true
    # Settings > advanced > when performing a search: search this mac
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Settings > advanced > show warning before changing an extension: false
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # View > as list
    defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"
    # View > show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # View > show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Show all hidden files (cmd+shift+.)
    defaults write com.apple.finder AppleShowAllFiles true
    # Use stacks on the desktop
    defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind
    # Don't create some .DS_Store files
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    killall Finder
fi
