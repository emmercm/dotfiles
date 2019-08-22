# .bash_profile (Ubuntu) -> .profile (OS X) -> .bashrc

##### Bash #####

# Load .bashrc
if [[ -n "${BASH_VERSION}" && -s ~/.bashrc ]]; then
    . ~/.bashrc
fi

# Load bash-completion
if [[ -x "$(command -v brew)" && -s "$(brew --prefix)/etc/bash_completion" ]]; then
    . "$(brew --prefix)/etc/bash_completion"
fi

# Reload this file after change
alias reload=". ~/.bash_profile"


##### Git #####

# Get the most recent version from Git tags
# @returns {string} Git tag
alias gitversion="git tag --sort=-version:refname | head -1"


##### Docker #####

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
docksh() {
    docker exec -it "$1" -- sh
}

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
dockbash() {
    docker exec -it "$1" -- bash
}

# Kill all running Docker containers
dockkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# Kill all running Docker containers and delete all container data
alias dockprune="dockkillall && docker system prune --all --force && docker images purge"


##### Kubernetes #####

# Load bash-completions
if [[ -x "$(command -v kubectl)" ]]; then
    . <(kubectl completion bash)
fi
if [[ -x "$(command -v kops)" ]]; then
    . <(kops completion bash)
fi
if [[ -x "$(command -v minikube)" ]]; then
    . <(minikube completion bash)
fi
if [[ -x "$(command -v helm)" ]]; then
    . <(helm completion bash)
fi

# List all Kubernetes pods, optionally filtering to an application
# @param {string=} $1 App label
kubels() {
    kubectl get pods --output=wide ${1:+--selector="app=$1"}
}

# Get the name of the newest running Kubernetes pod given an app label
# @param {string=} $1 App label
# @returns {string} Pod name
kubename() {
    kubectl get pods --selector="app=$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" | tail -n +2 | tail -1 | awk '{print $1}'
}

# Describe a Kubernetes service to get info such as labels, IP, and load balancer ingress
# @param {string} $1 Service name
kubedescribe() {
    kubectl describe service "$1"
}

# Show the Kubernetes rollout history for a deployment
# @param {string} $1 Deployment name
# @param {number=} $2 Revision number
kubehist() {
    kubectl rollout history "deployment/$1" ${2:+--revision "$2"}
}

# Execute `sh` interactively in the Kubernetes pod
# @param {string} $1 Container name
kubesh() {
    kubectl exec -it $(kubename "$1") -- sh
}

# Execute `bash` interactively in the Kubernetes pod
# @param {string} $1 Container name
kubebash() {
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


##### MySQL #####

# Set path environment variables
if [[ -x "$(command -v brew)" && -d "$(brew --prefix)/opt/mysql-client/bin" ]]; then
    export PATH="$(brew --prefix)/opt/mysql-client/bin:$PATH"
fi


##### Node.js #####

# Set path environment variables
if [[ -x "$(command -v nvm)" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


##### Everything Else #####

while read -r FILE; do
    source "${FILE}"
done <<< "$(find "$(pwd)" -maxdepth 1 -follow -type f -name ".*.bash")"
