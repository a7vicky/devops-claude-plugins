# Kustomize Patching Patterns

## Strategic Merge Patch

Best for: Simple field overrides (replicas, image, env vars).

The patch is a partial Kubernetes resource. Fields specified in the patch override the base.

**Patch file** (`replica-patch.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
```

**Reference in `kustomization.yaml`**:

```yaml
patches:
  - path: replica-patch.yaml
```

## JSON Patch (RFC 6902)

Best for: Array manipulation, field removal, precise operations.

Operations: `add`, `remove`, `replace`, `move`, `copy`, `test`.

**Inline in `kustomization.yaml`**:

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
      - op: remove
        path: /spec/template/spec/containers/0/resources/limits
```

## Inline Strategic Merge Patch

Same as strategic merge but defined inline instead of in a separate file.

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

## Targeting Multiple Resources

Use label selectors or wildcards:

```yaml
patches:
  - target:
      kind: Deployment
      labelSelector: "app=myapp"
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 2
```

## When to Use Which

| Scenario | Patch Type |
|----------|-----------|
| Change replicas, image, simple fields | Strategic merge |
| Add/remove items from an array | JSON patch |
| Remove a field entirely | JSON patch (`op: remove`) |
| Override multiple simple fields at once | Strategic merge |
| Conditional or targeted changes | JSON patch with `target` |
| Quick one-liner changes | Inline strategic merge |

## Common Mistakes

- Strategic merge patch cannot remove fields — use JSON patch `op: remove`
- JSON patch paths are 0-indexed: `/spec/template/spec/containers/0/...`
- Append to array with `/-`: `path: /spec/template/spec/containers/0/env/-`
- `target` selectors must match exactly one or more resources
- Patch file must have correct `apiVersion`, `kind`, and `metadata.name` for strategic merge
