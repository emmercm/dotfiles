#!/usr/bin/env bash
set -euo pipefail

# https://emmer.dev/blog/automate-your-macos-defaults/


# Git settings
if command -v git &> /dev/null && [[ -s ~/.gitignore_global ]]; then
    git config --global core.excludesfile ~/.gitignore_global
fi

# macOS settings
if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    # https://rectangleapp.com/
    # https://linearmouse.app/
    # https://brew.sh/

    if ! sudo -n true &> /dev/null; then
        echo -e "\033[1;33mWARN:\033[0m you will be asked for your password to run 'pmset', 'chflags', and other utilities\n"
    fi

    # ***** Settings > Wi-Fi *****

    # ***** Settings > Bluetooth *****

    # ***** Settings > Network *****

    # ***** Settings > Notifications *****

    # ***** Settings > Sound *****
    # Alert sound: Boop
    defaults write .GlobalPreferences com.apple.sound.beep.sound -string "/System/Library/Sounds/Tink.aiff"
    # Alert volume
    defaults write .GlobalPreferences com.apple.sound.beep.volume -float 0.5
    # Play feedback when volume is changed
    defaults write .GlobalPreferences com.apple.sound.beep.feedback -bool true

    # ***** Settings > Focus *****
    # TODO: remove DND schedules / disable DND

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
    # Siri: don't show in menu bar
    defaults write com.apple.Siri StatusMenuVisible -int 0
    killall SystemUIServer

    # ***** Settings > Siri & Spotlight *****
    # Ask Siri: false
    defaults write com.apple.assistant.support "Assistant Enabled" -int 0

    # ***** Settings > Privacy & Security *****

    # ***** Settings > Desktop & Dock *****
    # Size: smaller
    defaults write com.apple.dock tilesize -int 45
    # Magnification: off
    defaults write com.apple.dock magnification -bool false
    # Position on screen: bottom
    defaults write com.apple.dock orientation -string "bottom"
    # Automatically hide and show the dock: false
    defaults write com.apple.dock autohide -bool false
    # Show indicators for open applications: true
    defaults write com.apple.dock show-process-indicators -bool true
    # Click wallpaper to reveal desktop: always
    defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -int 1
    killall Dock

    # ***** Settings > Displays *****
    # Enable subpixel font rendering on non-Apple LCDs
    defaults write NSGlobalDomain AppleFontSmoothing -int 1
    # TODO: Automatically adjust brightness off
    # TODO: True Tone off
    # TODO: Night Shift... schedule: sunset to sunrise

    # ***** Settings > Wallpaper *****

    # ***** Settings > Screen Saver *****
    # defaults -currentHost write com.apple.screensaver idleTime -int 1800
    # defaults write com.apple.screensaver askForPasswordDelay -int 0

    # ***** Settings > Battery *****
    # Low Power Mode: Only on Battery
    sudo pmset -b lowpowermode 1
    sudo pmset -c lowpowermode 0
    # Options... prevent automatic sleeping on power adapter when the display is off: on
    sudo pmset -c sleep 0
    # Options... wake for network access: only on power adapter
    sudo pmset -b womp 0
    sudo pmset -c womp 1

    # ***** Settings > Lock Screen *****
    # Start screen saver when inactive for X seconds
    defaults -currentHost write com.apple.screensaver -int 300
    # Turn display off on battery when inctive for X minutes
    sudo pmset -b displaysleep 10
    # Turn display off on power adapter when inctive for X minutes
    sudo pmset -c displaysleep 10
    # TODO: Require password after screen saver begins or display is turned off: 1min
    killall "System Settings" || true

    # ***** Settings > Touch ID & Password *****

    # ***** Settings > Users & Groups *****

    # ***** Settings > Passwords *****

    # ***** Settings > Internet Accounts *****

    # ***** Settings > Game Center *****

    # ***** Settings > Wallet & Apple Pay *****

    # ***** Settings > Keyboard *****
    # Key repeat rate: fast (requires restart?)
    defaults write .GlobalPreferences KeyRepeat -int 2
    # Input Sources > Correct spelling automatically: off
    defaults write .GlobalPreferences NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write .GlobalPreferences WebAutomaticSpellingCorrectionEnabled -bool false
    # Input Sources > Add period with double-space: off
    defaults write .GlobalPreferences NSAutomaticPeriodSubstitutionEnabled -bool false
    # Turn off text replacements (requires restart?)
    defaults write .GlobalPreferences WebAutomaticTextReplacementEnabled -bool false
    # TODO: keyboard brightness
    # macOS Sonoma v14 "redesigned insertion point"
    sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool YES

    # ***** Settings > Mouse *****
    # Tracking speed
    defaults write .GlobalPreferences com.apple.mouse.scaling 0.6875

    # ***** Settings > Trackpad *****
    # More gestures... app exposé: swipe down with three fingers
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    # ***** Activity Monitor *****
    # Columns & sorting preferences
    defaults write com.apple.ActivityMonitor UserColumnSortPerTab "{0={direction=1;sort=Command;};1={direction=0;sort=anonymousMemory;};2={direction=0;sort=12HRPower;};3={direction=0;sort=CPUUsage;};4={direction=0;sort=txBytes;};5={direction=0;sort=Name;};6={direction=0;sort=GPUUsage;};}"
    # View > Dock Icon > Show CPU History
    defaults write com.apple.ActivityMonitor IconType "6"
    # View > Update Frequency > Often (2 sec)
    defaults write com.apple.ActivityMonitor UpdatePeriod "2"
    # View > All Processes, Hierarchically
    defaults write com.apple.ActivityMonitor ShowCategory "101"

    # ***** Finder *****
    # Settings > General > show these items on the desktop: hard drives, external disks, CDs/DVDs/iPods, connected servers
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    # Settings > Sidebar > recent tags
    defaults write com.apple.finder ShowRecentTags -bool false
    # Settings > Advanced > Show all filename extensions
    defaults write .GlobalPreferences AppleShowAllExtensions -bool true
    # Settings > Avanced > Show warning before changing an extension: false
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Settings > Advanced > Keep folders on top: In windows when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst "1"
    # Settings > Advanced > When performing a search: Search the Current Folder
    defaults write com.apple.finder FXDefaultSearchScope "SCcf"
    # View > as List
    defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"
    # View > Show Path Bar
    defaults write com.apple.finder ShowPathbar -bool true
    # View > Show Status Bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Show all hidden files (cmd+shift+.)
    defaults write com.apple.finder AppleShowAllFiles true
    # Use stacks on the desktop
    defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind
    # Don't create some .DS_Store files
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    # Show some normally hidden folders
    chflags nohidden ~/Library
    sudo chflags nohidden /Volumes
    killall Finder
fi
