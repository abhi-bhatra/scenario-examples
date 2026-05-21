#!/bin/bash
# Background setup script — runs silently while user reads the intro
# Logs go to /var/log/killercoda for debugging
set -x
exec 2>/var/log/killercoda

# Wait for Kubernetes to be fully available
echo "Waiting for Kubernetes control plane..."
while ! kubectl get nodes 2>/dev/null | grep -q " Ready"; do
  sleep 3
done

# Also wait for core system pods
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=120s 2>/dev/null || true

echo "Creating webshop namespace..."
kubectl create namespace webshop

# Deploy the frontend (nginx:1.24 — simulates an older running version)
echo "Deploying frontend application..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: webshop
  annotations:
    kubernetes.io/change-cause: "Initial release: nginx 1.24"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: frontend
        version: "1.24"
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
EOF

# Create a service to front the deployment
echo "Creating service..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: webshop
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF

# Wait for all pods to be running before signalling readiness
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/frontend -n webshop --timeout=120s

echo "Setup complete."
touch /tmp/background-done
