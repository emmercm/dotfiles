# dotfiles

A collection of personal dotfiles.

## Installing

`git clone` this repository and then run [`./install.sh`](./install.sh).

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Contents

### [bash-completion](https://github.com/scop/bash-completion)

Some additional completions are loaded:

- Git
- Docker
- Kubernetes (`kubectl`, `kops`, `minikube`, and `helm`)

### Aliases & Functions

A number of helpers are written in:

- [`.profile`](./profile).
- [`.docker.bash`](./docker.bash).
- [`.kubernetes.bash`](./kubernetes.bash).
- [`.osx.bash`](./osx.bash).

## Extending

[`.profile`](./profile) sources all `.*.bash` files in the same directory so aliases and functions can be nicely grouped.

## Inspiration

- Mathias Bynens' [aliases](https://github.com/mathiasbynens/dotfiles/blob/master/.aliases)
