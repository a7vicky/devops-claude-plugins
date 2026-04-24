---
name: dwf-jira-update
description: Update existing Jira issues in the DW project on Jira Cloud. Use when user says "update ticket", "change status", "move to In Progress", "assign to", "edit DW-123", "add a comment", "transition issue", or wants to modify any field on an existing issue.
metadata:
  author: DW Team
  version: 2.0.0
---

# DWF Jira Update Issue

Update existing Jira issues in the DW project via `curl` and the Jira REST API v3.

## Important

- Do not ask for cloudId, base URL, or auth details — use defaults below.
- Do not ask for confirmation before updating — just do it and report.
- Do not ask which fields to update if intent is clear — infer from context.
- Do not fetch the issue first unless you need current values to merge.
- If user gives a bare ticket number, prepend `DW-`.
- For status changes, always fetch transitions first, then apply.

## Step 1: Verify Auth

Run silently before the first Jira call in a session:

```bash
test -n "$JIRA_USER" && test -n "$JIRA_API_TOKEN" && echo "OK" || echo "MISSING: set JIRA_USER (email) and JIRA_API_TOKEN (https://id.atlassian.com/manage-profile/security/api-tokens)"
```

If missing, tell the user what to set and stop.

## Step 2: Perform the Update

### Update fields (summary, priority, labels, etc.)

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d '{"fields": {"summary": "Updated summary text"}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123"
```

Successful update returns HTTP 204. Verify by fetching the issue:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123?fields=summary,status,assignee,priority" | python3 -m json.tool
```

### Transition status (e.g., move to "In Progress")

Step A — Get available transitions:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/transitions" | python3 -m json.tool
```

Step B — Apply transition using the `id` from Step A:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"transition": {"id": "TRANSITION_ID"}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/transitions"
```

### Add a comment

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"body": {"type": "doc", "version": 1, "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Comment text"}]}]}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123/comment" | python3 -m json.tool
```

### Reassign

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/user/search?query=user@redhat.com" | python3 -m json.tool
```

Then update with the account `id`:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" -X PUT \
  -d '{"fields": {"assignee": {"id": "ACCOUNT_ID"}}}' \
  "https://redhat.atlassian.net/rest/api/3/issue/DW-123"
```

## Step 3: Report Result

Report: **Updated [DW-123](https://redhat.atlassian.net/browse/DW-123)** — brief summary of what changed.

## Examples

**User says:** "Move DW-456 to In Progress"

Action: Fetch transitions for DW-456, find "In Progress" transition id, apply it.

**User says:** "Assign DW-789 to john@redhat.com"

Action: Look up account ID for john@redhat.com, update assignee field.

**User says:** "Add a comment to DW-100 saying the fix is deployed"

Action: Post comment with ADF body to DW-100.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| 404 Not Found | Wrong issue key | Verify the DW-NNN key exists |
| 400 Bad Request | Invalid field format | Check JSON structure, use ADF for description/comments |
| No matching transition | Status change not allowed | Check available transitions — workflow may restrict this path |

For field reference and ADF format details, consult `references/adf-format.md`.
