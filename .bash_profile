# Git helpers
alias gitversion="git tag --sort=version:refname | tail -1"

# Kubernetes helpers
function kubename() { kubectl get pods -l app="$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" | tail -n +2 | tail -1 | awk '{print $1}'; }
function kubesh()   { kubectl exec -it $(kubename "$1") -- sh; }
function kubebash() { kubectl exec -it $(kubename "$1") -- bash; }
