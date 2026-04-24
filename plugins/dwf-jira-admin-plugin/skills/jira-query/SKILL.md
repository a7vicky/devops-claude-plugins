---
name: dwf-jira-query
description: Search and query Jira issues in the DW project on Jira Cloud using JQL. Use when user says "find issues", "show my tickets", "search Jira", "list bugs", "what's in the sprint", "get DW-123", or asks about issue status, assignee, or project health.
metadata:
  author: DW Team
  version: 2.0.0
---

# DWF Jira Query

Search and retrieve Jira issues in the DW project via `curl` and the Jira REST API v3.

## Important

- Do not ask for cloudId, base URL, project key, or auth credentials — use the defaults below.
- Do not ask which fields to return — return all by default.
- Do not ask for confirmation before querying — just run it.
- Do not ask about pagination unless the user requests more results.
- If user says "my issues" or "my tickets", use `assignee = currentUser()`.
- If user gives a bare ticket number, prepend `DW-`.
- Always add `ORDER BY updated DESC` if no ordering is specified.

## Step 1: Verify Auth

Run silently before the first Jira call in a session:

```bash
test -n "$JIRA_USER" && test -n "$JIRA_API_TOKEN" && echo "OK" || echo "MISSING: set JIRA_USER (email) and JIRA_API_TOKEN (https://id.atlassian.com/manage-profile/security/api-tokens)"
```

If missing, tell the user what to set and stop.

## Step 2: Run the Query

### Single issue

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123" | python3 -m json.tool
```

### JQL search

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"jql": "project = DW AND status != Done ORDER BY updated DESC", "maxResults": 20}' \
  "https://redhat.atlassian.net/rest/api/3/search" | python3 -m json.tool
```

## Step 3: Format Results

Present results as a clean table:

| Key | Summary | Status | Assignee | Priority |
|-----|---------|--------|----------|----------|

Extract from: `issues[].key`, `.fields.summary`, `.fields.status.name`, `.fields.assignee.displayName`, `.fields.priority.name`.

For single issues, show: key, summary, status, assignee, priority, description (truncated), created, updated.

## Examples

**User says:** "Show my open tickets"

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" -X POST \
  -d '{"jql": "project = DW AND assignee = currentUser() AND status != Done ORDER BY updated DESC", "maxResults": 20}' \
  "https://redhat.atlassian.net/rest/api/3/search" | python3 -m json.tool
```

**User says:** "Get DW-456"

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-456" | python3 -m json.tool
```

**User says:** "Find all open bugs"

JQL: `project = DW AND type = Bug AND status != Done ORDER BY priority DESC`

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| 401 Unauthorized | Bad credentials | Verify `JIRA_USER` and `JIRA_API_TOKEN` |
| 400 Bad Request | JQL syntax error | Quote multi-word values: `status = "In Progress"` |
| Empty results | Overly restrictive JQL | Broaden the query, check project key |

For JQL syntax reference and common query patterns, consult `references/jql-guide.md`.
