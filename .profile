# .bash_profile (OS X Default) -> .profile (Ubuntu Default) -> .bashrc

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

# Short alias
alias g="git"
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g
fi

# Git config aliases
for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
    alias g${al}="git ${al}"
    complete_func=_git_$(__git_aliased_command ${al})
    function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
done

# Get the most recent versions from Git tags
# @param {number=10} $1 Number of versions to show
# @returns {string} Git tag
alias gvs="git tag --sort=-version:refname | head -${1:-10}"

# Get the most recent version from Git tags
# @returns {string} Git tag
alias gv="gvs | head -1"


##### Docker #####

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
dsh() {
    docker exec --interactive --tty "$1" -- sh
}

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
dbash() {
    docker exec --interactive --tty "$1" -- bash
}

# Kill all running Docker containers
dkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# Kill all running Docker containers and delete all container data
alias dprune="dkillall && docker system prune --all --force && docker images purge"


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
kls() {
    kubectl get pods --output=wide ${1:+--selector="app=$1"}
}

# Get the name of the newest running Kubernetes pod given an app label
# @param {string=} $1 App label
# @returns {string} Pod name
kname() {
    kubectl get pods --selector="app=$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" | tail -n +2 | tail -1 | awk '{print $1}'
}

# Describe a Kubernetes service to get info such as labels, IP, and load balancer ingress
# @param {string} $1 Service name
kservice() {
    kubectl get service -l "app=$1"
}

# Show the Kubernetes rollout history for a deployment
# @param {string} $1 Deployment name
# @param {number=} $2 Revision number
khistory() {
    kubectl rollout history "deployment/$1" ${2:+--revision "$2"}
}

# List all Kubernetes ingresses, optionally filtering to an application
# @param {string=} $1 App label
kingress() {
    kubectl get ingress ${1:+-l "app=$1"}
}

# Execute `sh` interactively in the Kubernetes pod
# @param {string} $1 Container name
ksh() {
    kubectl exec --interactive --tty $(kname "$1") -- sh
}

# Execute `bash` interactively in the Kubernetes pod
# @param {string} $1 Container name
kbash() {
    kubectl exec --interactive --tty $(kname "$1") -- bash
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
if [[ -d "$(brew --prefix)/opt/mysql-client/bin" ]]; then
    export PATH="$(brew --prefix)/opt/mysql-client/bin:${PATH}"
fi


##### Node.js #####

# Set path environment variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


##### Python #####

while read -r DIR; do
    export PATH="${DIR}:${PATH}"
done <<< "$(find ~/Library/Python -type d -name bin)"


##### Everything Else #####

while read -r FILE; do
    . "${FILE}"
done <<< "$(find ~ -maxdepth 1 -follow -type f -name ".*.bash")"
