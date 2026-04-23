---
name: DWF Jira Update Issue
description: Update existing Jira issues in the DW project on Jira Cloud using curl and the REST API. Modify summary, description, status, assignee, priority, and other fields.
allowed-tools: Shell, Read, Grep, Glob
---

# DWF Jira Update Issue

Update existing Jira issues in the DW project using `curl` against the Jira REST API.

## Guardrails

- **DO NOT** ask the user for cloudId, base URL, or auth details — use the defaults below.
- **DO NOT** ask for confirmation before updating — just do it and show the result.
- **DO NOT** ask which fields to update if the user's intent is clear — infer from context.
- **DO NOT** fetch the issue first unless you need current values to merge with updates.
- If the user gives a ticket number without a prefix, prepend `DW-`.
- For status transitions, fetch available transitions first, then apply.

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

## Update Fields

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d '{
    "fields": {
      "summary": "Updated summary text"
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123"
```

A successful update returns HTTP 204 (no content). To confirm, fetch the issue after:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123?fields=summary,status,assignee,priority" | python3 -m json.tool
```

## Update Description

Descriptions use Atlassian Document Format (ADF):

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d '{
    "fields": {
      "description": {
        "type": "doc",
        "version": 1,
        "content": [
          {
            "type": "paragraph",
            "content": [
              {"type": "text", "text": "New description text"}
            ]
          }
        ]
      }
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123"
```

## Change Assignee

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d '{"fields": {"assignee": {"id": "ACCOUNT_ID"}}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123"
```

Look up account ID:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/user/search?query=user@redhat.com" | python3 -m json.tool
```

## Transition Status

Status changes require a transition, not a field update.

Step 1 — Get available transitions:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/transitions" | python3 -m json.tool
```

Step 2 — Apply transition (use the `id` from step 1):

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"transition": {"id": "31"}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/transitions"
```

## Add a Comment

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "body": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [
            {"type": "text", "text": "Comment text here"}
          ]
        }
      ]
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/comment" | python3 -m json.tool
```

## After Update

Report: **Updated [DW-123](https://redhat.atlassian.net/browse/DW-123)** with a brief summary of what changed.

## Updatable Fields

| Field | JSON Key | Value Format |
|-------|----------|-------------|
| Summary | `summary` | String |
| Description | `description` | ADF document (see above) |
| Priority | `priority` | `{"name": "High"}` |
| Assignee | `assignee` | `{"id": "account-id"}` |
| Labels | `labels` | `["label1", "label2"]` |
| Components | `components` | `[{"id": "component-id"}]` |
