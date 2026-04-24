---
name: k8s-kustomize
description: Build, validate, scaffold, diff, and apply Kustomize overlays for Kubernetes. Use when user says "kustomize build", "render overlay", "scaffold kustomize", "create kustomization", "diff overlays", "apply kustomize", "set image tag", "add patch", or works with kustomization.yaml files.
metadata:
  author: DW Team
  version: 1.0.0
---

# Kubernetes Kustomize

Build, scaffold, validate, diff, and apply Kustomize configurations.

## Important

- Do not ask which CLI to use — auto-detect `kustomize` or `kubectl kustomize`.
- Do not ask for confirmation before `kustomize build` — it is read-only.
- Do ask for confirmation before `kubectl apply` — it modifies the cluster.
- Do not ask about namespace, context, or cluster unless the user mentions them.
- Pick the right patch type automatically: strategic merge for field overrides, JSON patch for array ops or removal.

## Step 1: Check Prerequisites

Run silently before first use:

```bash
if command -v kustomize &>/dev/null; then
  echo "CLI: kustomize $(kustomize version --short 2>/dev/null || kustomize version)"
elif kubectl kustomize --help &>/dev/null 2>&1; then
  echo "CLI: kubectl kustomize (built-in)"
else
  echo "MISSING: install kustomize (https://kubectl.docs.kubernetes.io/installation/kustomize/) or use kubectl v1.14+"
fi
```

If neither available, tell user how to install and stop.

## Step 2: Execute the Requested Operation

### Build / render

```bash
kustomize build overlays/dev
```

Or with kubectl: `kubectl kustomize overlays/dev`

### Diff between overlays

```bash
diff <(kustomize build overlays/dev) <(kustomize build overlays/prod)
```

### Diff against live cluster

```bash
kustomize build overlays/dev | kubectl diff -f -
```

### Apply to cluster (ask user first)

```bash
kustomize build overlays/dev | kubectl apply --dry-run=client -f -
kustomize build overlays/dev | kubectl apply -f -
```

### Validate

```bash
kustomize build overlays/dev > /dev/null && echo "VALID" || echo "ERRORS found"
```

### Common edit commands

```bash
kustomize edit set image myapp=registry/myapp:v2.0
kustomize edit set namespace my-namespace
kustomize edit add resource configmap.yaml
kustomize edit add patch --path patch.yaml --kind Deployment --name app
```

## Step 3: Scaffold (when creating new structures)

Generate the standard layout:

```
base/
├── kustomization.yaml
├── deployment.yaml
└── service.yaml
overlays/
├── dev/
│   ├── kustomization.yaml
│   └── replica-patch.yaml
├── staging/
│   └── kustomization.yaml
└── prod/
    └── kustomization.yaml
```

Base `kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

Overlay `kustomization.yaml` (example for dev):

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
namePrefix: dev-
commonLabels:
  env: dev
patches:
  - path: replica-patch.yaml
```

## Examples

**User says:** "Build the dev overlay"

```bash
kustomize build overlays/dev
```

**User says:** "Set the image to v3.0 in staging"

```bash
cd overlays/staging && kustomize edit set image myapp=registry/myapp:v3.0
```

**User says:** "Scaffold a new kustomize setup for my-service"

Action: Create `base/` with kustomization.yaml + deployment.yaml + service.yaml, and `overlays/{dev,staging,prod}` directories with per-environment kustomization.yaml and patches.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `no such file or directory` | Wrong resource path | Check `resources:` paths are relative and correct |
| `must build at directory` | Pointed at a file | Point to directory containing `kustomization.yaml` |
| `conflict` in patches | Duplicate field modifications | Merge or reorder conflicting patches |
| `accumulating resources` | Circular reference | Check for duplicate resource entries across overlays |

For patching patterns (strategic merge, JSON patch, inline) and advanced examples, consult `references/patching-patterns.md`.

## Find Existing Kustomizations

```bash
find . -name "kustomization.yaml" -o -name "kustomization.yml" | head -20
```
