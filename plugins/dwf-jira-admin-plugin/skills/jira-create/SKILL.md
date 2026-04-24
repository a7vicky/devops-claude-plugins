---
name: dwf-jira-create
description: Create new Jira issues in the DW project on Jira Cloud. Use when user says "create a ticket", "file a bug", "make a story", "add a task", "create Jira issue", "log a bug", or wants to create any work item in the DW project.
metadata:
  author: DW Team
  version: 2.0.0
---

# DWF Jira Create Issue

Create Jira issues in the DW project via `curl` and the Jira REST API v3.

## Important

- Do not ask for cloudId, base URL, or auth details — use defaults below.
- Do not ask for issue type unless ambiguous — default to `Task`.
- Do not ask for priority unless user mentions it — default to `Medium`.
- Do not ask for description if the user gave a clear summary — create with just the summary, adding a reasonable description from context.
- Do not ask about labels, components, or custom fields unless the user mentions them.
- Do not ask for confirmation — create immediately and report the result.
- Infer type from keywords: "bug" -> Bug, "story" -> Story, "epic" -> Epic, otherwise Task.

## Step 1: Verify Auth

Run silently before the first Jira call in a session:

```bash
test -n "$JIRA_USER" && test -n "$JIRA_API_TOKEN" && echo "OK" || echo "MISSING: set JIRA_USER (email) and JIRA_API_TOKEN (https://id.atlassian.com/manage-profile/security/api-tokens)"
```

If missing, tell the user what to set and stop.

## Step 2: Create the Issue

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "fields": {
      "project": {"key": "DW"},
      "summary": "REPLACE_SUMMARY",
      "issuetype": {"name": "Task"},
      "description": {
        "type": "doc",
        "version": 1,
        "content": [{"type": "paragraph", "content": [{"type": "text", "text": "REPLACE_DESCRIPTION"}]}]
      }
    }
  }' \
  "https://redhat.atlassian.net/rest/api/3/issue" | python3 -m json.tool
```

To add priority or assignee, include in the `fields` object:

```json
"priority": {"name": "High"},
"assignee": {"id": "ACCOUNT_ID"}
```

Look up account ID when assigning:

```bash
curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
  "https://redhat.atlassian.net/rest/api/3/user/search?query=user@redhat.com" | python3 -m json.tool
```

## Step 3: Report Result

On success the API returns `{"id": "...", "key": "DW-NNN", "self": "..."}`.

Report: **Created [DW-NNN](https://redhat.atlassian.net/browse/DW-NNN)** — summary text.

## Examples

**User says:** "Create a bug for the broken login page"

Action: Create with `issuetype: Bug`, summary: "Broken login page", description inferred from context.

**User says:** "Add a task to update the deployment docs"

Action: Create with `issuetype: Task`, summary: "Update the deployment docs".

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| 400 Bad Request | Missing required field or bad ADF | Ensure summary is non-empty, description uses ADF format |
| 401 Unauthorized | Bad credentials | Verify `JIRA_USER` and `JIRA_API_TOKEN` |
| `issuetype` not found | Invalid type for project | Use: Task, Bug, Story, Epic, Sub-task |

For Atlassian Document Format (ADF) reference, consult `references/adf-format.md`.
