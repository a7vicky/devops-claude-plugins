# k8s-kustomize-plugin

Kubernetes Kustomize plugin for Claude. Build, validate, scaffold, diff, and apply Kustomize overlays using `kustomize` or `kubectl kustomize` directly — no MCP or external services required.

## Features

- **Build & Render**: Render final manifests from any overlay
- **Scaffold**: Generate base + overlay directory structures from scratch
- **Patch Management**: Strategic merge patches, JSON patches, inline patches
- **Diff**: Compare overlays or diff against live cluster
- **Validate**: Check kustomization builds and validate against K8s schemas
- **Troubleshoot**: Common error patterns and fixes

## Requirements

One of:
- `kustomize` CLI ([install](https://kubectl.docs.kubernetes.io/installation/kustomize/))
- `kubectl` v1.14+ (has `kubectl kustomize` built in)

## Skills

### kustomize

Single comprehensive skill covering all Kustomize operations:

- `kustomize build` / `kubectl kustomize` to render overlays
- Scaffold new base + overlay structures
- Manage patches (strategic merge, JSON, inline)
- Diff between overlays or against live cluster
- Validate configurations
- Troubleshoot common errors

**Example prompts:**
- "Build the dev overlay"
- "Scaffold a new kustomize structure for my app"
- "Add a replica patch to the staging overlay"
- "Diff dev vs prod overlays"
- "Set the image tag to v2.0 in the prod overlay"

## Install

```bash
claude plugin add https://github.com/a7vicky/devops-claude-plugins
```
