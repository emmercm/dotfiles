# dotfiles

A collection of personal dotfiles.

## Installing

`git clone` this repository and then run [`./install.sh`](./install.sh).

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Shells

The following shells are supported by these dotfiles:

**Bash (Bourne Again SHell):**

- Files are sourced in the following order:
  - [`~/.bash_profile`](./.bash_profile): macOS default entry point, mostly empty
  - [`~/.profile`](./.profile): Ubuntu default entry point, mostly empty
  - [`~/.bashrc`](./.bashrc): general functions and aliases
  - `~/.*.bash` (including [`~/.powerline.bash`](./.powerline.bash)): specific functions and aliases
- Uses [Powerline](https://github.com/powerline/powerline) for shell decoration

**Zsh (Z shell):**

- Files are sourced in the following order:
  - [`~/.zshrc`](./.zshrc): mostly empty
  - [`~/.p10k.zsh`](./.p10k.zsh): [Powerlevel10k](https://github.com/romkatv/powerlevel10k) configuration
  - [`~/.bashrc`](./.bashrc): general functions and aliases
  - `~/.*.bash` (including [`~/.oh-my-zsh.bash`](./.oh-my-zsh.bash)): specific functions and aliases
- Uses [Oh My Zsh](https://ohmyz.sh/) for shell decoration
- Uses [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for the theme

## `.*.bash` files

- [`.docker.bash`](./.docker.bash): [Docker](https://www.docker.com) shortcuts and aliases
- [`.kubernetes.bash`](./.kubernetes.bash): [Kubernetes](https://kubernetes.io/) competions, shortcuts, and alises
- [`.macos.bash`](./.macos.bash): macOS shortcuts and polyfills

## Inspiration

- Mathias Bynens' [aliases](https://github.com/mathiasbynens/dotfiles/blob/master/.aliases)
