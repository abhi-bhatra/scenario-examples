#!/bin/bash
# Verify: Strategy changed to maxSurge:0 and maxUnavailable:1
MAX_SURGE=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)

MAX_UNAVAIL=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)

READY=$(kubectl get deployment frontend -n webshop \
  -o jsonpath='{.status.readyReplicas}' 2>/dev/null)

if [ "$MAX_SURGE" = "0" ] && [ "$MAX_UNAVAIL" = "1" ] && [ "$READY" = "3" ]; then
  exit 0
fi

exit 1
