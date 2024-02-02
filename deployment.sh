#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create redis  namespace if not present
REDIS_NAMESPACE="redis"
kubectl get ns "$REDIS_NAMESPACE" || kubectl create ns "$REDIS_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy redis operator from operatorhub manifests
echo "deploy redis operator..."
kubectl create -f https://operatorhub.io/install/redis-operator.yaml

# deploy mongodb crds
kubectl apply -f configs/redis-cluster.yaml -n "$REDIS_NAMESPACE"

echo "Redis and CRDs deployed successfully in namespace '$REDIS_NAMESPACE' of context '$KUBE_CONTEXT'."