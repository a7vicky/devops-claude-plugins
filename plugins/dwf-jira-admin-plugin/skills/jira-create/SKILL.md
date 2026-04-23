---
name: DWF Jira Create Issue
description: Create new Jira issues in the DW project on Jira Cloud using curl and the REST API. Supports all issue types with summary, description, priority, and assignee.
allowed-tools: Shell, Read, Grep, Glob
---

# DWF Jira Create Issue

Create Jira issues in the DW project using `curl` against the Jira REST API.

## Guardrails

- **DO NOT** ask the user for cloudId, base URL, or auth details — use the defaults below.
- **DO NOT** ask for issue type unless it's ambiguous — default to `Task`.
- **DO NOT** ask for priority unless the user mentions it — default to `Medium`.
- **DO NOT** ask for description if the user gave a clear summary — create the issue with just the summary. Add a reasonable description yourself if the context is obvious.
- **DO NOT** ask about labels, components, or custom fields unless the user mentions them.
- **DO NOT** ask for confirmation before creating — just create it and show the result.
- If the user says "bug", use type `Bug`. If "story", use `Story`. If "epic", use `Epic`. Otherwise default to `Task`.

## Prerequisites

Required environment variables (check before first use):

```bash
test -n "$JIRA_USER" && test -n "$JIRA_API_TOKEN" && echo "OK" || echo "MISSING: set JIRA_USER (email) and JIRA_API_TOKEN (API token from https://id.atlassian.com/manage-profile/security/api-tokens)"
```

If variables are missing, tell the user exactly what to set and stop.

## Defaults

| Setting | Value |
|---------|-------|
| Base URL | `https://redhat.atlassian.net` |
| Project | `DW` |
| Issue Type | `Task` |
| Priority | `Medium` |

## Create an Issue

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "fields": {
      "project": {"key": "DW"},
      "summary": "Issue summary here",
      "issuetype": {"name": "Task"},
      "description": {
        "type": "doc",
        "version": 1,
        "content": [
          {
            "type": "paragraph",
            "content": [
              {"type": "text", "text": "Description text here"}
            ]
          }
        ]
      }
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue" | python3 -m json.tool
```

## With Priority and Assignee

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "fields": {
      "project": {"key": "DW"},
      "summary": "High priority task",
      "issuetype": {"name": "Bug"},
      "priority": {"name": "High"},
      "assignee": {"id": "ACCOUNT_ID"},
      "description": {
        "type": "doc",
        "version": 1,
        "content": [
          {
            "type": "paragraph",
            "content": [
              {"type": "text", "text": "Description here"}
            ]
          }
        ]
      }
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue" | python3 -m json.tool
```

To find a user's account ID for assignee, search:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/user/search?query=user@redhat.com" | python3 -m json.tool
```

## After Creation

On success the API returns `{"id": "...", "key": "DW-NNN", "self": "..."}`.

Report back: **Created [DW-NNN](https://redhat.atlassian.net/browse/DW-NNN)** with the summary.

## Issue Types

| Type | When to Use |
|------|------------|
| Task | General work items (default) |
| Bug | Defects and issues |
| Story | User-facing features |
| Epic | Large initiatives spanning multiple stories |
| Sub-task | Breakdown of a parent issue |

## Description Format

Jira Cloud REST API v3 uses Atlassian Document Format (ADF) for descriptions. For plain text, wrap in the paragraph structure shown above. For multi-paragraph descriptions, add multiple paragraph objects to the `content` array.
