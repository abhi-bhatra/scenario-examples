#!/bin/bash
# Verify: Deployment exists, running nginx:1.24, with 3 ready replicas
IMAGE=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

READY=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.status.readyReplicas}' 2>/dev/null)

if [ "$IMAGE" = "nginx:1.24" ] && [ "$READY" = "3" ]; then
  exit 0
fi

exit 1
