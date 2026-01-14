# dotfiles

A collection of personal dotfiles.

## Installing dotfiles to `$HOME`

`git clone` this repository and then run [`./install.sh`](./install.sh).

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Other setup

These files are not installed into `$HOME` and should be run as necessary:

- [`./packages.sh`](./packages.sh) installs commonly used tools and applications from package managers
- [`./settings.sh`](./settings.sh) updates OS settings to preferred defaults

## Shells

The following shells are supported by these dotfiles:

**Bash (Bourne Again SHell):**

Files are sourced in the following order:

1. [`~/.bash_profile`](./.bash_profile): macOS default entry point, mostly empty
2. [`~/.profile`](./.profile): Ubuntu default entry point, mostly empty
3. [`~/.bashrc`](./.bashrc): mostly empty
4. [`~/.everythingrc`](./.everythingrc): general functions and aliases
5. `~/.dotpack/.*.sh` and `~/.dotpack/.*.bash`: functions and aliases, including:
   1. [`~/.dotpack/.90_powerline.bash`](./dotpack/.90_powerline.bash): [Powerline](https://github.com/powerline/powerline) shell theme

**Zsh (Z shell):**

Files are sourced in the following order:

1. [`~/.zshrc`](./.zshrc): default entry point, mostly empty
2. [`~/.everythingrc`](./.everythingrc): general functions and aliases
3. `~/.dotpack/.*.sh` and `~/.dotpack/.*.zsh`: functions and aliases, including:
   1. [`~/.dotpack/.80_plugins.zsh`](./dotpack/.80_plugins.zsh): [Antidote](https://github.com/mattmc3/antidote) Zsh plugin management
   2. [`~/.dotpack/.90_powerlevel10k.zsh`](./dotpack/.90_powerlevel10k.zsh): [Powerlevel10k](https://github.com/romkatv/powerlevel10k) shell theme configuration
