# Bash helpers
if [[ -x "$(command -v brew)" && -f "$(brew --prefix)/etc/bash_completion" ]]; then
    source "$(brew --prefix)/etc/bash_completion"
fi
alias reload="source ~/.bash_profile"

# Git helpers
alias gitversion="git tag --sort=-version:refname | head -1"

# Docker helpers
function docksh()   { docker exec -it "$1" -- sh; }
function dockbash() { docker exec -it "$1" -- bash; }
function dockkillall() { docker kill $(docker ps -q) 2> /dev/null || true; }
function dockprune()   { dockkillall && docker system prune --all --force && docker images purge; }

# Kubernetes helpers
function kubename() { kubectl get pods -l app="$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" | tail -n +2 | tail -1 | awk '{print $1}'; }
function kubesh()   { kubectl exec -it $(kubename "$1") -- sh; }
function kubebash() { kubectl exec -it $(kubename "$1") -- bash; }
