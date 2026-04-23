# dwf-jira-admin-plugin

Jira administration plugin for the DW project on Jira Cloud. Uses `curl` with the Jira REST API v3 directly — no MCP, no CLI tools to install.

## Requirements

- `curl` (pre-installed on virtually all systems)
- Two environment variables:

```bash
export JIRA_USER="your-email@redhat.com"
export JIRA_API_TOKEN="your-api-token"
```

Get your API token: https://id.atlassian.com/manage-profile/security/api-tokens

## Verify Setup

```bash
bash plugins/dwf-jira-admin-plugin/scripts/check-setup.sh
```

## Defaults

| Setting | Value |
|---------|-------|
| Jira Instance | https://redhat.atlassian.net |
| Project | DW |
| API | REST API v3 |

## Skills

### jira-query

Search and retrieve Jira issues using JQL.

**Example prompts:**
- "Show my open Jira tickets"
- "Find all DW bugs"
- "Get DW-123"
- "What's in the current sprint?"

### jira-create

Create new Jira issues with smart defaults.

**Example prompts:**
- "Create a task to fix the login page"
- "Create a bug for the broken search feature"
- "Make a story for the new dashboard"

### jira-update

Update existing issues — fields, status, assignee, comments.

**Example prompts:**
- "Update DW-123 summary to ..."
- "Move DW-456 to In Progress"
- "Assign DW-789 to john@redhat.com"
- "Add a comment to DW-100"

## Install

```bash
claude plugin add https://github.com/a7vicky/devops-claude-plugins
```
