#!/usr/bin/env bash
# Cyberdream tmux - Kubernetes Context Widget
# Shows: context:namespace

get_kube_info() {
    # Check if kubectl exists
    if ! command -v kubectl &>/dev/null; then
        return
    fi

    # Get current context
    local context
    context=$(kubectl config current-context 2>/dev/null)
    [ -z "$context" ] && return

    # Shorten common context names
    case "$context" in
        *"talos"*) context="talos" ;;
        *"k3s"*) context="k3s" ;;
        *"minikube"*) context="mini" ;;
        *"docker-desktop"*) context="docker" ;;
        *"kind"*) context="kind" ;;
        *"admin@"*) context=$(echo "$context" | sed 's/admin@//') ;;
        arn:aws:eks:*)
            # Extract cluster name from EKS ARN
            context=$(echo "$context" | rev | cut -d'/' -f1 | rev)
            ;;
    esac

    # Truncate if too long (keep more chars for readability)
    [ ${#context} -gt 14 ] && context="${context:0:12}.."

    # Get namespace
    local namespace
    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    [ -z "$namespace" ] && namespace="default"

    # Truncate namespace if needed
    [ ${#namespace} -gt 10 ] && namespace="${namespace:0:8}.."

    echo "☸ $context:$namespace"
}

get_kube_info
