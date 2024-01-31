__kube_completions() {
    # This lazy-loads completions for common Kube commands. This is because a number of them are
    # minorly slow. Completions won't be available until the first time the command is invoked.

    # NOTE: `autoload -Uz compinit && compinit` will need to happen before sourcing any of these!

    if [[ -x "$(command -v helm)" ]]; then
        helm() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(helm completion "$(basename "${SHELL}")")
            $0 "$@"
        }
    fi

    if [[ -x "$(command -v kops)" ]]; then
        kops() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(kops completion "$(basename "${SHELL}")")
            $0 "$@"
        }
    fi

    if [[ -x "$(command -v kubectl)" ]]; then
        kubectl() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(kubectl completion "$(basename "${SHELL}")")
            $0 "$@"
        }
    fi

    if [[ -x "$(command -v minikube)" ]]; then
        minikube() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(minikube completion "$(basename "${SHELL}")")
            $0 "$@"
        }
    fi

    if [[ -x "$(command -v stern)" ]]; then
        stern() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(stern --completion "$(basename "${SHELL}")")
            $0 "$@"
        }
    fi
}
__kube_completions


__kube_funcs() {
    # Execute `bash` interactively in the Kubernetes pod
    # @param {string} $1 App label
    kbash() {
        kubectl exec --stdin --tty "$(kpod "$1" | head -1)" -- bash
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

    # Change to a kubectl context
    # @param {string} $1 Context name
    alias kcontext="kubectl config use-context"

    # List all Kubernetes cron jobs, optionally filtering to an application
    # @param {string=} $1 App label
    kcrons() {
        kubectl get cronjob ${1:+--selector="app=$1"}
    }

    # List all Kubernetes daemon sets
    kdaemonsets() {
        kubectl get daemonsets
    }
    alias kds=kdaemonsets

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

    # Open a port forward session to a remote Kubernetes deployment
    # @param {string} $1 Deployment name
    # @param {number} $2 Local+remote OR local port number
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
        kubectl get jobs --label-columns="app" ${1:+--selector="app=$1"}
    }

    # Follow the logs from all Kubernetes containers with a given app label
    # @param {string} $1 App label
    # @param {number=} $2 Tail length
    klogs() {
        if [[ -x "$(command -v stern)" ]]; then
            stern --timestamps --tail ${2:-0} --selector "app=$1"
        else
            kubectl logs --all-containers --timestamps --follow --max-log-requests=9999 --tail=${2:-0} --selector="app=$1"
        fi
    }

    # List all Kubernetes namespaces
    knamespaces() {
        kubectl get namespaces
    }
    alias kns=knamespaces

    # List all Kubernetes nodes
    knodes() {
        kubectl get nodes --label-columns="nodegroup-name"
    }

    # Get the pod name of the newest running Kubernetes containers given an app label
    # @param {string} $1 App label
    kpod() {
        kubectl get pods --selector="app=$1" --field-selector=status.phase=Running --sort-by=".metadata.creationTimestamp" --show-labels | tail -n +2 | sed 's/[ ][ ]*/ /g' | sort -u -k6,6 | awk '{print $1}'
    }

    # List all Kubernetes pods, optionally filtering to an application
    # @param {string=} $1 App label
    kpods() {
        kubectl get pods --label-columns="app" ${1:+--selector="app=$1"}
    }

    # Reboot all Kubernetes deployments with a given app label
    # @param {string} $1 App label
    kreboot() {
        if [[ -z "$1" ]]; then
            return 1
        fi
        for DEPLOYMENT in $(kdeployments "$1"); do
            kubectl rollout restart "deployment/${DEPLOYMENT}"
        done
    }

    # Get the most recent revision number for a Kubernetes deployment
    # @param {string} $1 Deployment name
    krevision() {
        khistory "$1" | grep -E '^[0-9]\+' | sort --sort=numeric --reverse | head -1 | awk '{print $1}'
    }

    # Roll back a Kubernetes deployment
    # @param {string} $1 Deployment name
    # @param {number=} $1 Revision number
    krollback() {
        kubectl rollout undo "deployment/$1" ${2:+--to-revision=$2}
    }

    # List all Kubernetes replica sets, optionally filtering to an application
    # @param {string=} $1 App label
    kreplicasets() {
        kubectl get rs ${1:+--selector="app=$1"}
    }
    alias krs=kreplicasets

    # List all Kubernetes secrets, optionally filtering to an application
    # @param {string=} $1 App label
    ksecrets() {
        kubectl get secrets ${1:+--selector="app=$1"}
    }

    # Describe a Kubernetes service to get info such as labels, IP, and load balancer ingress
    # @param {string=} $1 App label
    kservices() {
        kubectl get services ${1:+--selector="app=$1"}
    }

    # Execute `sh` interactively in the Kubernetes pod
    # @param {string} $1 App label
    ksh() {
        kubectl exec --stdin --tty "$(kpod "$1" | head -1)" -- sh
    }

    # List all Kubernetes stateful sets
    kstatefulsets() {
        kubectl get statefulsets
    }
    alias kss=kstatefulsets

    # Emulate a `top` command for Kubernetes pods, optionally filtering to an application
    # @param {string=} $1 App label
    ktop() {
        watch "kubectl top pods --containers ${1:+--selector="app=$1"} | awk 'NR == 1; NR > 1 {print \$0 | \"sort -n -k3 -r\"}'"
    }
}
__kube_funcs
