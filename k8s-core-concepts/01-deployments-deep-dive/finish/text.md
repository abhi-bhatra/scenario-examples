# Well Done! 🎉

You've completed the Deployments Deep Dive. Here's what you practiced:

## What You Learned

✅ **Deployment anatomy** — The three-tier hierarchy: Deployment → ReplicaSet → Pod, and why it exists  
✅ **Rolling updates** — How Kubernetes shifts traffic by scaling new ReplicaSets up and old ones down  
✅ **Rollout history** — Using `kubernetes.io/change-cause` annotations to track *why* deploys happened  
✅ **Rollback** — How `kubectl rollout undo` works (it creates a new revision, not a rewind)  
✅ **maxSurge & maxUnavailable** — The knobs that control speed, capacity, and resource usage during rollouts

## Key Commands to Remember

```bash
# Update an image
kubectl set image deployment/<name> <container>=<image> -n <namespace>

# Watch rollout in real time
kubectl rollout status deployment/<name> -n <namespace>

# View deployment history
kubectl rollout history deployment/<name> -n <namespace>

# Roll back to previous version
kubectl rollout undo deployment/<name> -n <namespace>

# Roll back to a specific revision
kubectl rollout undo deployment/<name> -n <namespace> --to-revision=<n>

# Patch strategy inline
kubectl patch deployment <name> -n <namespace> \
  -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
```

## Production Checklist for Deployments

- [ ] Always set `kubernetes.io/change-cause` annotations for rollout history
- [ ] Use `kubectl rollout status` in your CI/CD pipeline to gate on success
- [ ] Know your service's tolerance for capacity dip → choose strategy accordingly
- [ ] Set `revisionHistoryLimit` (default 10) to control how many old ReplicaSets are kept
- [ ] Use `minReadySeconds` to slow down rollouts and catch flapping pods

## What's Next

- **Lab 02: ConfigMaps & Secrets** — How apps consume configuration in Kubernetes, and what happens when you update it
- **Lab 03: Persistent Storage** — PVs, PVCs, and StorageClasses: data that survives pod restarts
- **Lab 04: RBAC from Scratch** — Service accounts, Roles, and the principle of least privilege
