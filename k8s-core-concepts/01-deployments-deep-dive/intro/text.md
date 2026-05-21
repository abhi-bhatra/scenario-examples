# Deployments Deep Dive

You're an SRE at an e-commerce company. The platform team runs a **frontend web service** on Kubernetes, and today is release day.

Your job: deploy a new version safely, handle a deployment that goes wrong, and tune the rollout strategy so future deploys are more resource-efficient.

## What You'll Learn

- How to inspect a Deployment and understand its state
- How rolling updates work — and what `maxSurge` and `maxUnavailable` actually do
- How to track deployment history using rollout revisions
- How to roll back when a bad image gets deployed
- How to adjust rollout strategy to fit your cluster's constraints

## The Environment

Your lab has been set up with:

| Resource | Details |
|---|---|
| Namespace | `webshop` |
| Deployment | `frontend` — 3 replicas of `nginx:1.24` |
| Service | `ClusterIP` on port 80 |

The environment is being provisioned. Once it says **"Your environment is ready"**, click **START**.
