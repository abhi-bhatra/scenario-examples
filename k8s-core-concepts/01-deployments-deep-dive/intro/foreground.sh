#!/bin/bash
# Foreground script — visible to the user, waits for background setup to finish
echo "Provisioning your lab environment..."
while [ ! -f /tmp/background-done ]; do
  sleep 2
done
echo ""
echo "✔ Kubernetes cluster ready"
echo "✔ Namespace 'webshop' created"
echo "✔ Frontend deployment running (3 replicas)"
echo "✔ Service configured"
echo ""
echo "Your environment is ready. Click START to begin!"
