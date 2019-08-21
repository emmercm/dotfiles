# dotfiles

A collection of personal dotfiles.

## Installing

`git clone` this repository and then run `./install.sh`.

All dotfiles are symlinked to the user's home directory to keep them up to date with this repo. Files that would be overwritten are backed-up first.

## Contents

### [bash-completion](https://github.com/scop/bash-completion)

Some additional completions are loaded:

- Git
- Docker
- Kubernetes (`kubectl`, `kops`, `minikube`, and `helm`)

### Aliases & Functions

A number of helpers are written in [`.bash_profile`](./bash_profile).
