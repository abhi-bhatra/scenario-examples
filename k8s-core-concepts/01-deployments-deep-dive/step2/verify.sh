#!/bin/bash
# Verify: Deployment updated to nginx:1.25 with all 3 replicas ready
IMAGE=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

READY=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.status.readyReplicas}' 2>/dev/null)

if [ "$IMAGE" = "nginx:1.25" ] && [ "$READY" = "3" ]; then
  exit 0
fi

exit 1
