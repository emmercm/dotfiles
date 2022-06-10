# dotfiles

A collection of personal dotfiles.

## Installing

`git clone` this repository and then run [`./install.sh`](./install.sh).

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Shells

The following shells are supported by these dotfiles:

**Bash (Bourne Again SHell):**

Files are sourced in the following order:

1. [`~/.bash_profile`](./.bash_profile): macOS default entry point, mostly empty
2. [`~/.profile`](./.profile): Ubuntu default entry point, mostly empty
3. [`~/.bashrc`](./.bashrc): general functions and aliases
4. `~/.*.bash`: specific functions and aliases
   1. [`~/.powerline.bash`](./.powerline.bash) for shell decoration with [Powerline](https://github.com/powerline/powerline)
   2. Other files described below

**Zsh (Z shell):**

Files are sourced in the following order:

1. [`~/.zshrc`](./.zshrc): mostly empty
2. [`~/.bashrc`](./.bashrc): general functions and aliases
3. `~/.*.bash`: specific functions and aliases
   1. [`~/.oh-my-zsh.bash`](./.oh-my-zsh.bash) for [Oh My Zsh](https://ohmyz.sh/) shell configuration, using [Antigen](https://antigen.sharats.me/) for plugin management.

      The contents of this file are typically put in `~/.zshrc` but are broken out here for organization.

      1. [`~/.p10k.zsh`](./.p10k.zsh): [Powerlevel10k](https://github.com/romkatv/powerlevel10k) shell theme configuration

   2. Other files described below

## `.*.bash` files

- [`.10_macos.bash`](./.10_macos.bash): macOS shortcuts and polyfills
- [`.20_docker.bash`](./.20_docker.bash): [Docker](https://www.docker.com) shortcuts and aliases
- [`.20_kubernetes.bash`](./.20_kubernetes.bash): [Kubernetes](https://kubernetes.io/) completions, shortcuts, and aliases

## Inspiration

- Mathias Bynens' [aliases](https://github.com/mathiasbynens/dotfiles/blob/master/.aliases)
