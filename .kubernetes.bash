# Use an editor you can exit from
if [[ -x "$(command -v nano)" ]]; then
    export KUBE_EDITOR="nano"
fi


# Load bash-completions
if [[ -x "$(command -v helm)" ]]; then
    source <(helm completion bash)
fi
if [[ -x "$(command -v kops)" ]]; then
    source <(kops completion bash)
fi
if [[ -x "$(command -v kubectl)" ]]; then
    source <(kubectl completion bash)
fi
if [[ -x "$(command -v minikube)" ]]; then
    source <(minikube completion bash)
fi
if [[ -x "$(command -v stern)" ]]; then
    source <(stern --completion=bash)
fi


# Execute `bash` interactively in the Kubernetes pod
# @param {string} $1 App label
kbash() {
    kubectl exec --stdin --tty $(kpod "$1" | head -1) -- bash
}

# List all Kubernetes config maps, optionally filtering to an application
# @param {string=} $1 App label
kconfigmaps() {
    kubectl get configmaps ${1:+--selector="app=$1"}
}

# List all Kubernetes container names, optionally filtering to an application
# @param {string=} $1 App label
kcontainers() {
    kubectl get pods --output=jsonpath="{.items[*].spec.containers[*].name}" ${1:+--selector="app=$1"} | tr -s '[[:space:]]' '\n' | sort -u
}

# List all Kubernetes cron jobs, optionally filtering to an application
# @param {string=} $1 App label
kcrons() {
    kubectl get cronjob ${1:+--selector="app=$1"}
}

# List all Kubernetes container names given a deployment name
# @param {string} $1 Deployment name
kdcontainers() {
    kubectl get deployment --output=jsonpath="{.spec.template.spec.containers[*].name}" "$1" | tr -s '[[:space:]]' '\n' | sort -u
}

# Delete a Kubernetes pod
# @param {string} $1 Pod name
kdel() {
    kubectl delete pod "$1"
}

# List all Kubernetes deployment names, optionally filtering to an application
# @param {string=} $1 App label
kdeployments() {
    kubectl get deployments --output=jsonpath="{.items[*].metadata.name}" ${1:+--selector="app=$1"} | tr -s '[[:space:]]' '\n' | sort -u
}

# Open a port forward socket to a remote Kubernetes deployment
# @param {string} $1 Deployment name
# @param {number} $2 Local port number
# @param {number=} $3 Remote port number
kforward() {
    kubectl port-forward "deployment/$1" "$2${3:+:$3}"
}

# Show the Kubernetes rollout history for a deployment
# @param {string} $1 Deployment name
# @param {number=} $2 Revision number
khistory() {
    kubectl rollout history "deployment/$1" ${2:+--revision "$2"}
}

# List all Kubernetes container image names, optionally filtering to an application
# @param {string=} $1 App label
kimages() {
    kubectl get pods --output=jsonpath="{.items[*].spec.containers[*].image}" ${1:+--selector="app=$1"} | tr -s '[[:space:]]' '\n' | sort -u
}

# List all Kubernetes ingresses, optionally filtering to an application
# @param {string=} $1 App label
kingress() {
    kubectl get ingress ${1:+--selector="app=$1"}
}

# List all Kubernetes jobs, optionally filtering to an application
# @param {string=} $1 App label
kjobs() {
    kubectl get jobs ${1:+--selector="app=$1"} --label-columns="app" ${1:+--selector="app=$1"}
}

# Follow the logs from all Kubernetes containers with a given app label
# @param {string} $1 App label
klogs() {
    kubectl logs --all-containers --follow --max-log-requests=1000 --selector="app=$1"
}

# List all Kubernetes nodes
knodes() {
    kubectl get nodes --label-columns="nodegroup-name"
}

# Get the pod name of the newest running Kubernetes containers given an app label
# @param {string=} $1 App label
kpod() {
    kubectl get pods --selector="app=$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" --show-labels | tail -n +2 | sed 's/[ ][ ]*/ /g' | sort -u -k6,6 | awk '{print $1}'
}

# List all Kubernetes pods, optionally filtering to an application
# @param {string=} $1 App label
kpods() {
    kubectl get pods --label-columns="app" ${1:+--selector="app=$1"}
}

# Reboot all Kubernetes pods with a given app label
# @param {string} $1 App label
kreboot() {
    if [[ -z "$1" ]]; then
        return 1
    fi
    for DEPLOYMENT in $(kdeployments "$1"); do
        CONTAINER=$(kdcontainers "${DEPLOYMENT}" | head -1)
        kubectl patch deployment "${DEPLOYMENT}" --patch="{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"${CONTAINER}\",\"env\":[{\"name\":\"LAST_MANUAL_RESTART\",\"value\":\"$(date +%s)\"}]}]}}}}"
    done
}

# List all Kubernetes replica sets, optionally filtering to an application
# @param {string=} $1 App label
krs() {
    kubectl get rs ${1:+--selector="app=$1"}
}

# Describe a Kubernetes service to get info such as labels, IP, and load balancer ingress
# @param {string=} $1 App label
kservice() {
    kubectl get service ${1:+--selector="app=$1"}
}

# Execute `sh` interactively in the Kubernetes pod
# @param {string} $1 App label
ksh() {
    kubectl exec --stdin --tty $(kpod "$1" | head -1) -- sh
}

# Emulate a `top` command for Kubernetes pods, optionally filtering to an application
# @param {string} $1 App label
ktop() {
    watch "kubectl top pods --containers ${1:+--selector="app=$1"} | awk 'NR == 1; NR > 1 {print \$0 | \"sort -n -k3 -r\"}'"
}
