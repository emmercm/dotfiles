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
3. [`~/.bashrc`](./.bashrc): mostly empty
4. [`~/.everythingrc`](./.everythingrc): general functions and aliases
5. `~/.*.bash`: specific functions and aliases
   1. Files described below
   2. [`~/.90_powerline.bash`](./.powerline.bash): [Powerline](https://github.com/powerline/powerline) shell theme

**Zsh (Z shell):**

Files are sourced in the following order:

1. [`~/.zshrc`](./.zshrc): default entry point, mostly empty
2. [`~/.everythingrc`](./.everythingrc): general functions and aliases
3. `~/.*.bash`: specific functions and aliases
   1. Files described below
4. `~/.*.zsh`:
   1. [`.80_plugins.zsh`](./.80_plugins.zsh): [Antidote](https://github.com/mattmc3/antidote) Zsh plugin management
   2. [`.90_powerlevel10k.zsh`](./.90_powerlevel10k.zsh): [Powerlevel10k](https://github.com/romkatv/powerlevel10k) shell theme configuration

## `.*.bash` files

- [`.10_macos.bash`](./.10_macos.bash): macOS shortcuts and polyfills
- [`.20_docker.bash`](./.20_docker.bash): [Docker](https://www.docker.com) shortcuts and aliases
- [`.20_git.bash`](./.20_git.bash): [Git](https://git-scm.com/) completions, shortcuts, and aliases
- [`.20_kubernetes.bash`](./.20_kubernetes.bash): [Kubernetes](https://kubernetes.io/) completions, shortcuts, and aliases
- [`.20_nodejs.bash`](./.20_nodejs.bash): [Node.js](https://nodejs.org/en/) shortcuts and aliases
- [`.20_pulsar.bash`](./.20_pulsar.bash): [Apache Pulsar](https://pulsar.apache.org/) shortcuts and aliases
- [`.20_temporal.bash`](./.20_temporal.bash): [Temporal](https://docs.temporal.io/tctl-v1/) shortcuts and aliases
