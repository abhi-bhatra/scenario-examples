# Step 1: Explore the Deployment

Before you change anything in production, you **always** inspect first. Let's understand what's running.

## 1.1 — Get an overview

See everything in the `webshop` namespace:

```
kubectl get all -n webshop
```{{exec}}

Notice there are three resource types:
- A **Deployment** (`deployment.apps/frontend`) — the desired state declaration
- A **ReplicaSet** (`replicaset.apps/frontend-<hash>`) — owns and manages the pods
- Three **Pods** — the actual running containers

This three-tier hierarchy is important. The Deployment never directly owns Pods — it manages ReplicaSets, and ReplicaSets manage Pods. You'll see why this matters during a rolling update.

## 1.2 — Describe the Deployment

```
kubectl describe deployment frontend -n webshop
```{{exec}}

Key things to look at:

- **Replicas**: `3 desired | 3 updated | 3 total | 3 available`
- **StrategyType**: `RollingUpdate`
- **RollingUpdateStrategy**: `Max Unavailable: 0 | Max Surge: 1`
  - `maxUnavailable: 0` — never allow pods below the desired count during update
  - `maxSurge: 1` — allow one extra pod above desired count during update

This means during an update, you'll temporarily have **4 pods** (3 desired + 1 surge), ensuring zero downtime.

## 1.3 — Check rollout history

```
kubectl rollout history deployment/frontend -n webshop
```{{exec}}

You should see **Revision 1** with the change-cause annotation `"Initial release: nginx 1.24"`. This annotation is how you track *why* each deployment happened.

> **Production tip**: Always set `kubernetes.io/change-cause` on your deployments. When you're paged at 2am and need to roll back, you'll thank yourself for having a clear history.

## 1.4 — Check the current image

```
kubectl get deployment frontend -n webshop -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{exec}}

Confirm you see `nginx:1.24`. This is our "current production version".

---

✅ **To complete this step**: Confirm the deployment is healthy with 3 ready replicas and you've reviewed the rollout history.

```
kubectl get deployment frontend -n webshop
```{{exec}}

All 3 replicas should be `READY`.
