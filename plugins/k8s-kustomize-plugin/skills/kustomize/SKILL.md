---
name: Kubernetes Kustomize
description: Build, validate, scaffold, diff, and apply Kustomize overlays for Kubernetes. Handles kustomization.yaml creation, overlay management, patching, and troubleshooting.
allowed-tools: Shell, Read, Write, Grep, Glob
---

# Kubernetes Kustomize

Build, scaffold, validate, diff, and apply Kustomize configurations for Kubernetes resources.

## Guardrails

- **DO NOT** ask which CLI to use — detect what's available (`kustomize` or `kubectl kustomize`) and use it.
- **DO NOT** ask for confirmation before `kustomize build` (read-only) — just run it.
- **DO ASK** for confirmation before `kubectl apply` — applying changes to a cluster is destructive.
- **DO NOT** ask about namespace, context, or cluster unless the user mentions them.
- **DO NOT** ask the user to choose between strategic merge patch and JSON patch — pick the right one based on the use case (strategic merge for simple field overrides, JSON patch for array manipulation or removal).
- If the user says "build" or "render", run `kustomize build` and show the output.
- If the user says "apply", build first to preview, then apply after confirmation.
- If the user says "diff", compare rendered output between overlays or against the live cluster.

## Prerequisites

Check before first use (run silently):

```bash
if command -v kustomize &>/dev/null; then
  echo "CLI: kustomize $(kustomize version --short 2>/dev/null || kustomize version 2>/dev/null)"
elif kubectl kustomize --help &>/dev/null 2>&1; then
  echo "CLI: kubectl kustomize (built-in)"
else
  echo "MISSING: install kustomize (https://kubectl.docs.kubernetes.io/installation/kustomize/) or use kubectl v1.14+"
fi
```

If neither is available, tell the user how to install and stop.

## Build / Render

Render the final manifests from a kustomization directory:

```bash
# Using standalone kustomize
kustomize build overlays/dev

# Using kubectl built-in
kubectl kustomize overlays/dev
```

To save output:

```bash
kustomize build overlays/dev > rendered.yaml
```

## Apply to Cluster

Preview first, then apply:

```bash
# Dry-run to preview
kustomize build overlays/dev | kubectl apply --dry-run=client -f -

# Apply for real (ask user first)
kustomize build overlays/dev | kubectl apply -f -
```

## Diff Against Live Cluster

```bash
kustomize build overlays/dev | kubectl diff -f -
```

## Diff Between Overlays

```bash
diff <(kustomize build overlays/dev) <(kustomize build overlays/prod)
```

## Scaffold a New Kustomization

### Base

When the user wants to create a new kustomize structure, generate these files:

**`base/kustomization.yaml`**:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
```

### Overlay

**`overlays/dev/kustomization.yaml`**:
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

**`overlays/dev/replica-patch.yaml`**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
```

### Standard Directory Layout

```
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── overlays/
    ├── dev/
    │   ├── kustomization.yaml
    │   └── replica-patch.yaml
    ├── staging/
    │   ├── kustomization.yaml
    │   └── replica-patch.yaml
    └── prod/
        ├── kustomization.yaml
        └── replica-patch.yaml
```

## Common Operations

### Add a Resource

```bash
cd base && kustomize edit add resource configmap.yaml
```

### Set Namespace

```bash
cd overlays/dev && kustomize edit set namespace my-namespace
```

### Set Image Tag

```bash
cd overlays/dev && kustomize edit set image myapp=myregistry/myapp:v2.0
```

### Add a ConfigMap Generator

```bash
cd overlays/dev && kustomize edit add configmap my-config --from-literal=KEY=value
```

### Add a Secret Generator

```bash
cd overlays/dev && kustomize edit add secret my-secret --from-literal=password=changeme
```

### Add a Patch

```bash
cd overlays/dev && kustomize edit add patch --path replica-patch.yaml --kind Deployment --name app
```

## Patching Patterns

### Strategic Merge Patch (simple field overrides)

```yaml
# overlays/dev/replica-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
```

Reference in `kustomization.yaml`:
```yaml
patches:
  - path: replica-patch.yaml
```

### JSON Patch (array manipulation, field removal)

```yaml
patches:
  - target:
      kind: Deployment
      name: app
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 3
      - op: add
        path: /spec/template/spec/containers/0/env/-
        value:
          name: ENV
          value: dev
```

### Inline Patch

```yaml
patches:
  - target:
      kind: Deployment
      name: app
    patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: app
      spec:
        replicas: 2
```

## Validate

Check that the kustomization builds without errors:

```bash
kustomize build overlays/dev > /dev/null && echo "VALID" || echo "ERRORS found"
```

Validate the rendered output against Kubernetes schemas:

```bash
kustomize build overlays/dev | kubectl apply --dry-run=server -f -
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| `no such file or directory` | Check `resources:` paths are relative and correct |
| `resource not found` | Ensure referenced resources exist in base or overlay |
| `conflict` in patches | Two patches modify the same field — merge or reorder |
| `must build at directory` | Point to a directory containing `kustomization.yaml`, not a file |
| `accumulating resources` | Circular or duplicate resource reference — check all overlays |
| API version mismatch | Use `apiVersion: kustomize.config.k8s.io/v1beta1` |

## Find Existing Kustomizations in a Repo

```bash
find . -name "kustomization.yaml" -o -name "kustomization.yml" | head -20
```
