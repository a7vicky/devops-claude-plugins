---
name: DWF Jira Query
description: Search and query Jira issues in the DW project on Jira Cloud using curl and the REST API. Filter by status, assignee, type, and other fields with JQL.
allowed-tools: Shell, Read, Grep, Glob
---

# DWF Jira Query

Search and retrieve Jira issues in the DW project using `curl` against the Jira REST API.

## Guardrails

- **DO NOT** ask the user for cloudId, base URL, project key, or auth details — use the defaults below.
- **DO NOT** ask which fields to return — return all fields by default; only filter if the user explicitly asks.
- **DO NOT** ask for confirmation before running a query — just run it.
- **DO NOT** ask about pagination unless the user mentions needing more results.
- If the user says "my issues" or "my tickets", use `assignee = currentUser()`.
- If the user gives a ticket number without a prefix, prepend `DW-`.

## Prerequisites

Required environment variables (check before first use):

```bash
# Verify setup — run this silently before the first Jira operation
test -n "$JIRA_USER" && test -n "$JIRA_API_TOKEN" && echo "OK" || echo "MISSING: set JIRA_USER (email) and JIRA_API_TOKEN (API token from https://id.atlassian.com/manage-profile/security/api-tokens)"
```

If variables are missing, tell the user exactly what to set and stop. Do not proceed without auth.

## Defaults

| Setting | Value |
|---------|-------|
| Base URL | `https://redhat.atlassian.net` |
| Project | `DW` |
| API Version | REST API v3 (`/rest/api/3/`) |

## Get a Single Issue

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123" | python3 -m json.tool
```

Replace `DW-123` with the actual issue key.

## Search with JQL

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"jql": "project = DW AND status != Done ORDER BY updated DESC", "maxResults": 20}' \
  "https://redhat.atlassian.net/rest/api/3/search" | python3 -m json.tool
```

## Formatting Results

After getting results, present them as a clean table or list:

| Key | Summary | Status | Assignee | Priority |
|-----|---------|--------|----------|----------|

Extract from `issues[].key`, `issues[].fields.summary`, `issues[].fields.status.name`, `issues[].fields.assignee.displayName`, `issues[].fields.priority.name`.

For single issues, show: key, summary, status, assignee, priority, description (truncated), created, updated.

## Common JQL Patterns

| Intent | JQL |
|--------|-----|
| My open issues | `project = DW AND assignee = currentUser() AND status != Done` |
| All open bugs | `project = DW AND type = Bug AND status != Done` |
| High priority | `project = DW AND priority = High ORDER BY created DESC` |
| Recently updated | `project = DW AND updated >= -7d ORDER BY updated DESC` |
| By assignee | `project = DW AND assignee = "user@redhat.com"` |
| Text search | `project = DW AND summary ~ "search term"` |
| Sprint issues | `project = DW AND sprint in openSprints()` |

Always add `ORDER BY` for consistent results. Default to `ORDER BY updated DESC` if no order specified.
