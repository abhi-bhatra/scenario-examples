# Step 4: Tune Your Rollout Strategy

The current deployment uses `maxSurge: 1, maxUnavailable: 0`. This is great for zero-downtime, but it uses extra resources during the rollout (temporarily 4 pods instead of 3).

In a resource-constrained cluster, you might prefer the opposite: kill one old pod first, then bring up a new one. This keeps resource usage constant but briefly reduces capacity.

## 4.1 — Understand the current strategy

```
kubectl get deployment frontend -n webshop -o jsonpath='{.spec.strategy}' | python3 -m json.tool 2>/dev/null || \
kubectl get deployment frontend -n webshop -o jsonpath='{.spec.strategy}'
echo ""
```{{exec}}

Right now:
- `maxSurge: 1` → can go **above** desired count by 1 during update
- `maxUnavailable: 0` → can **never** go below desired count during update

The implication: peak pod count during rollout = **desired + surge** = **4 pods**.

## 4.2 — Flip the strategy

Change to `maxSurge: 0, maxUnavailable: 1` — this is the "resource-conservative" approach:

```
kubectl patch deployment frontend -n webshop \
  -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":0,"maxUnavailable":1}}}}'
```{{exec}}

## 4.3 — Verify the patch was applied

```
kubectl describe deployment frontend -n webshop | grep -A3 "RollingUpdateStrategy"
```{{exec}}

You should see: `Max Unavailable: 1 | Max Surge: 0`

## 4.4 — Deploy a new version and observe the difference

Now trigger a new rollout to see the updated strategy in action:

```
kubectl set image deployment/frontend nginx=nginx:1.26 -n webshop
```{{exec}}

While it's rolling out, immediately check pod counts:

```
kubectl get pods -n webshop -w
```{{exec}}

Press `Ctrl+C` after a few seconds once you see the pattern.

With `maxUnavailable: 1, maxSurge: 0`:
- One **old pod is terminated first**
- Then one **new pod starts**
- This repeats until all pods are updated
- Pod count **never exceeds 3** (no surge), but briefly **dips to 2**

## 4.5 — Check rollout completed

```
kubectl rollout status deployment/frontend -n webshop
```{{exec}}

```
kubectl get deployment frontend -n webshop
```{{exec}}

## The Trade-off Explained

| Strategy | Peak pods | Min pods during update | Best for |
|---|---|---|---|
| `maxSurge:1, maxUnavailable:0` | desired + 1 | desired | Zero downtime — services that can't lose capacity |
| `maxSurge:0, maxUnavailable:1` | desired | desired - 1 | Resource efficiency — services that can absorb brief capacity dip |
| `maxSurge:1, maxUnavailable:1` | desired + 1 | desired - 1 | Fastest update — max parallelism |

> **Recreate strategy** is a fourth option: kills ALL old pods first, then starts all new ones. Zero-downtime is impossible, but it's useful for apps that can't run multiple versions simultaneously (e.g., schema migrations, singleton processes).

---

✅ **To complete this step**: The deployment must have `maxSurge: 0` and `maxUnavailable: 1` in its rolling update strategy.
