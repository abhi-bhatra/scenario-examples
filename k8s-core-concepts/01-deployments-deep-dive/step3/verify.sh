#!/bin/bash
# Verify: Deployment has been rolled back — not running the broken image, 3 pods ready
IMAGE=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

READY=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.status.readyReplicas}' 2>/dev/null)

# Must NOT be the broken image
if [ "$IMAGE" = "nginx:this-tag-does-not-exist" ]; then
  exit 1
fi

# Must have all 3 replicas ready
if [ "$READY" = "3" ]; then
  exit 0
fi

exit 1
