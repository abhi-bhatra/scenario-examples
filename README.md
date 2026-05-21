# Kubernetes in Practice — Lab Series

Interactive hands-on labs for mid-level engineers who know Kubernetes basics and want to build production-grade intuition.

Built for [Killercoda](https://killercoda.com) by an SRE/DevOps engineer.

---

## 📚 K8s Core Concepts

| # | Lab | Topics | Status |
|---|-----|--------|--------|
| 01 | [Deployments Deep Dive](k8s-core-concepts/01-deployments-deep-dive/) | Rolling updates, rollback, maxSurge/maxUnavailable, rollout history | ✅ Ready |
| 02 | ConfigMaps & Secrets | Env vars, volume mounts, hot-reload vs restart | 🔜 Coming |
| 03 | Persistent Storage | PV/PVC lifecycle, StorageClasses, data persistence | 🔜 Coming |
| 04 | RBAC from Scratch | ServiceAccounts, Roles, RoleBindings, least privilege | 🔜 Coming |
| 05 | Pod Scheduling | NodeSelector, Affinity/Anti-affinity, Taints & Tolerations | 🔜 Coming |
| 06 | Resource Management | Requests, limits, LimitRanges, QoS classes, ResourceQuotas | 🔜 Coming |
| 07 | Health Probes | Liveness, readiness, startup probes — real failure scenarios | 🔜 Coming |
| 08 | Services & Networking | ClusterIP/NodePort, DNS resolution, kube-proxy | 🔜 Coming |
| 09 | StatefulSets | Ordered deployment, stable identity, vs Deployments | 🔜 Coming |
| 10 | NetworkPolicies | Default-deny, ingress/egress rules, pod isolation | 🔜 Coming |

---

## Structure

Each lab follows this pattern:

```
<lab-name>/
├── index.json          # Title, description, backend image, step definitions
├── intro/
│   ├── text.md         # What the user reads — context and objectives
│   ├── background.sh   # Silent setup (installs tools, deploys resources)
│   └── foreground.sh   # Visible progress indicator, waits for background
├── step1/ ... stepN/
│   ├── text.md         # Instructions with executable {{exec}} commands
│   └── verify.sh       # Automated check: exit 0 = pass, non-zero = fail
└── finish/
    └── text.md         # Summary, key commands, what's next
```

## Resources

- [Killercoda Creator Docs](https://killercoda.com/creators)
- [Live Examples](https://killercoda.com/examples)
- [Course grouping examples](https://github.com/killercoda/scenario-examples-groups)
