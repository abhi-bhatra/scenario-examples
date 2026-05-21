# Step 2: Perform a Rolling Update

The dev team just shipped version 1.25. It's been tested in staging. Time to roll it out to production.

## 2.1 — Watch the current ReplicaSet state

Before the update, note the existing ReplicaSet name:

```
kubectl get rs -n webshop
```{{exec}}

There's one ReplicaSet with 3 pods. After the rolling update, you'll see a **second ReplicaSet** appear — this is how Kubernetes tracks what's old vs new.

## 2.2 — Update the image

```
kubectl set image deployment/frontend nginx=nginx:1.25 -n webshop
```{{exec}}

## 2.3 — Watch the rollout in real time

```
kubectl rollout status deployment/frontend -n webshop
```{{exec}}

You'll see output like:
```
Waiting for deployment "frontend" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "frontend" rollout to finish: 2 out of 3 new replicas have been updated...
...
deployment "frontend" successfully rolled out
```

## 2.4 — Understand what happened under the hood

```
kubectl get rs -n webshop
```{{exec}}

Now there are **two ReplicaSets**:
- The old one (nginx:1.24) — scaled down to **0 replicas**
- The new one (nginx:1.25) — scaled up to **3 replicas**

Kubernetes keeps the old ReplicaSet around (by default, it keeps 10). This is what makes rollbacks fast — there's no rebuild, just a scale-up of an existing ReplicaSet.

## 2.5 — Record the change in history

The rollout happened, but let's annotate it so history is useful:

```
kubectl annotate deployment/frontend kubernetes.io/change-cause="Deploy nginx:1.25 - performance improvements" -n webshop --overwrite
```{{exec}}

Now check the history:

```
kubectl rollout history deployment/frontend -n webshop
```{{exec}}

Revision 2 should now show the change cause you just set.

> **Why does the annotation need `--overwrite`?** Kubernetes already stored revision 2 when the rollout completed. You're retroactively labelling it. In a real pipeline, you'd set this annotation *before* the rollout (or use a GitOps tool that does it automatically).

## 2.6 — Confirm the new version is live

```
kubectl get pods -n webshop -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```{{exec}}

All 3 pods should be on `nginx:1.25`.

---

✅ **To complete this step**: The deployment must be running `nginx:1.25` with all 3 replicas ready.
