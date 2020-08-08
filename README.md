# dotfiles

A collection of personal dotfiles.

## Installing

`git clone` this repository and then run [`./install.sh`](./install.sh).

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Shells

The following shells are supported by these dotfiles:

**Bash (Bourne Again SHell):**

- Files are sourced in the following order:
  - `~/.bash_profile`: macOS default, mostly empty
  - `~/.profile`: Ubuntu default, mostly empty
  - `~/.bashrc`: functions and aliases
  - `~/.*.bash` (including `~/.powerline.bash`): functions and aliases
- Uses [Powerline](https://github.com/powerline/powerline) for shell decoration

**Zsh (Z shell):**

- Files are sourced in the following order:
  - `~/.zshrc`: mostly empty
  - `~/.p10k.zsh`: [Powerlevel10k](https://github.com/romkatv/powerlevel10k) configuration
  - `~/.bashrc`: functions and aliases
  - `~/.*.bash` (including `~/oh-my-zsh.bash`): functions and aliases
- Uses [Oh My Zsh](https://ohmyz.sh/) for shell decoration
- Uses [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for the theme

## `.*.bash` files

- `.docker.bash`: [Docker](https://www.docker.com) shortcuts and aliases
- `.kubernetes.bash`: [Kubernetes](https://kubernetes.io/) competions, shortcuts, and alises
- `.macos.bash`: macOS shortcuts and polyfills

## Inspiration

- Mathias Bynens' [aliases](https://github.com/mathiasbynens/dotfiles/blob/master/.aliases)
