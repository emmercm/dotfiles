##### Bash #####

# Load bash-completion
if [[ -x "$(command -v brew)" && -f "$(brew --prefix)/etc/bash_completion" ]]; then
    source "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
alias reload="source ~/.bash_profile"


##### Git #####

# Get the most recent version from Git tags
# @returns {string} Git tag
alias gitversion="git tag --sort=-version:refname | head -1"


##### Docker #####

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
function docksh() {
    docker exec -it "$1" -- sh
}

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
function dockbash() {
    docker exec -it "$1" -- bash
}

# Kill all running Docker containers
function dockkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# Kill all running Docker containers and delete all container data
alias dockprune="dockkillall && docker system prune --all --force && docker images purge"


##### Kubernetes #####

# Load bash-completions
if [[ -x "$(command -v kubectl)" ]]; then
    source <(kubectl completion bash)
fi
if [[ -x "$(command -v kops)" ]]; then
    source <(kops completion bash)
fi
if [[ -x "$(command -v minikube)" ]]; then
    source <(minikube completion bash)
fi
if [[ -x "$(command -v helm)" ]]; then
    source <(helm completion bash)
fi

# List all Kubernetes pods, optionally filtering to an application
# @param {string=} $1 App label
function kubels() {
    kubectl get pods --output=wide ${1:+--selector="app=$1"}
}

# Get the name of the newest running Kubernetes pod given an app label
# @param {string=} $1 App label
# @returns {string} Pod name
function kubename() {
    kubectl get pods --selector="app=$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" | tail -n +2 | tail -1 | awk '{print $1}'
}

# Describe a Kubernetes service to get info such as labels, IP, and load balancer ingress
# @param {string} $1 Service name
function kubedescribe() {
    kubectl describe service "$1"
}

# Show the Kubernetes rollout history for a deployment
# @param {string} $1 Deployment name
# @param {number=} $2 Revision number
function kubehist() {
    kubectl rollout history "deployment/$1" ${2:+--revision "$2"}
}

# Execute `sh` interactively in the Kubernetes pod
# @param {string} $1 Container name
function kubesh() {
    kubectl exec -it $(kubename "$1") -- sh
}

# Execute `bash` interactively in the Kubernetes pod
# @param {string} $1 Container name
function kubebash() {
    kubectl exec -it $(kubename "$1") -- bash
}


##### Golang #####

# Set path environment variables
if [[ -x "$(command -v go)" ]]; then
    export GOPATH=$(go env GOPATH)
    if [[ ! -d "${GOPATH}" ]]; then
        mkdir "${GOPATH}"
        mkdir "${GOPATH}/bin"
        mkdir "${GOPATH}/src"
    fi
    export PATH=$PATH:$(go env GOPATH)/bin
fi
