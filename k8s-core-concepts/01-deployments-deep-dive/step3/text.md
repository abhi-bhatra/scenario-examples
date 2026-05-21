# Step 3: Bad Deploy — Rollback to the Rescue

It happens to everyone. An engineer deployed the wrong tag. The pods are stuck in `ImagePullBackOff`. Your service is degraded. Let's walk through diagnosing and recovering.

## 3.1 — Simulate a bad deployment

Someone pushed a deploy with a non-existent image tag:

```
kubectl set image deployment/frontend nginx=nginx:this-tag-does-not-exist -n webshop
```{{exec}}

## 3.2 — Watch it fail

Check rollout status. Because `maxUnavailable: 0`, Kubernetes won't kill old pods until new ones are ready — so your service stays up. But the rollout is stuck:

```
kubectl rollout status deployment/frontend -n webshop --timeout=20s
```{{exec}}

It will time out with: `error: timed out waiting for the condition`

## 3.3 — Diagnose the problem

Check what's happening with the pods:

```
kubectl get pods -n webshop
```{{exec}}

You'll see old pods still `Running` (your service is still up!) and one or more new pods in `ImagePullBackOff` or `ErrImagePull`.

Describe a failing pod for more detail (replace `<pod-name>` with an actual stuck pod name):

```
kubectl get pods -n webshop --field-selector=status.phase!=Running
```{{exec}}

```
kubectl describe pod -n webshop -l app=frontend | grep -A5 "Warning"
```{{exec}}

The events will show: `Failed to pull image "nginx:this-tag-does-not-exist": ... not found`

## 3.4 — Check rollout history before rolling back

```
kubectl rollout history deployment/frontend -n webshop
```{{exec}}

You should now see **Revision 3** (the bad deploy). The previous good revision is Revision 2 (nginx:1.25).

## 3.5 — Roll back

Undo to the last known-good revision:

```
kubectl rollout undo deployment/frontend -n webshop
```{{exec}}

Or roll back to a specific revision:

```
kubectl rollout undo deployment/frontend -n webshop --to-revision=2
```{{exec}}

## 3.6 — Confirm recovery

```
kubectl rollout status deployment/frontend -n webshop
```{{exec}}

```
kubectl get pods -n webshop
```{{exec}}

All 3 pods should be back to `Running`. The service never fully went down because of `maxUnavailable: 0`.

## 3.7 — Annotate the rollback for posterity

```
kubectl annotate deployment/frontend kubernetes.io/change-cause="ROLLBACK: reverted bad image tag" -n webshop --overwrite
```{{exec}}

```
kubectl rollout history deployment/frontend -n webshop
```{{exec}}

> Notice Kubernetes created a **new revision** for the rollback (it doesn't go "backwards" — it creates a new revision pointing at the old config). This means your history always moves forward, which is important for audit trails.

---

✅ **To complete this step**: The deployment must be back to a working state with 3 ready replicas (not running the broken image).
