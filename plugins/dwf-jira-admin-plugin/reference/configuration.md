# DWF Jira Configuration Reference

## Project Information

| Property | Value |
|----------|-------|
| Space | Digital Workforce |
| Default Board | Digital Workforce Scrum Teams |
| Project Key | DW |
| Project Name | DevOps Workflows |
| Jira Instance | Jira Cloud (redhat.atlassian.net) |
| Installation Type | Cloud |

## Default Configuration

```json
{
  "installationType": "Cloud",
  "jiraBaseUrl": "https://redhat.atlassian.net",
  "defaultProject": "DW"
}
```

## Supported Issue Types

| Type | Description | Usage |
|------|-------------|-------|
| Epic | Large initiatives spanning multiple stories | Strategic planning |
| Feature | Significant capability or functionality | Feature development |
| Story | User-facing work item | Feature decomposition |
| Task | Work without user-facing value | Internal work |
| Bug | Defect in existing functionality | Issue tracking |
| Sub-task | Breakdown of larger item | Task decomposition |

## Required Environment Variables

```bash
# Jira credentials
export JIRA_USER="your-email@redhat.com"
export JIRA_API_TOKEN="your-api-token"

# Optional configuration
export JIRA_BASE_URL="https://redhat.atlassian.net"
export JIRA_PROJECT="DW"
export JIRA_ISSUE_TYPE="Task"
```

## Issue Template Structure

The default `jira_issue_template.md` includes sections for:

- **Summary**: Brief issue title
- **Environment**: Context and affected systems
- **Description**: Detailed problem or feature description
- **Steps to reproduce**: How to replicate the issue (for bugs)
- **Expected behavior**: What should happen
- **Notes**: Additional context, links, or attachments

## CLI Tools

### acli (Atlassian CLI)

- Enterprise-grade Jira CLI tool
- Comprehensive field support
- Better for automation and scripting
- Command format: `acli --action <action> --<flag> <value>`

### jira-cli

- Lightweight modern Jira CLI
- Better interactive experience
- Good for manual operations
- Command format: `jira <command> <args>`

The plugin automatically uses whichever tool is available, with preference for acli.

## Authentication Methods

### API Token (Recommended)

```bash
export JIRA_API_TOKEN="your-api-token"
```

Get token: https://id.atlassian.com/manage-profile/security/api-tokens

### Personal Access Token (PAT)

Available in Jira Cloud for authorized users.

## Output Formats

### Raw JSON (Recommended for Scripting)

```bash
# acli
acli --action getIssue --issue DW-123

# jira-cli
jira issue view DW-123 --raw
```

### CSV Export

```bash
# Use with jira-cli
jira issue list --jql "project = DW" --csv
```

## Useful Links

- **Jira Instance**: https://redhat.atlassian.net/
- **DW Project**: https://redhat.atlassian.net/browse/DW
- **API Tokens**: https://id.atlassian.com/manage-profile/security/api-tokens
- **JQL Help**: https://support.atlassian.com/jira-cloud-platform/docs/advanced-searching-using-jql/

## Common Issues and Solutions

### Issue: "Unauthorized" error
**Solution**: Verify JIRA_USER and JIRA_API_TOKEN environment variables

### Issue: "Project DW not found"
**Solution**: Confirm you have access to the DW project or override with --project flag

### Issue: "Invalid issue type"
**Solution**: Use one of the supported types: Bug, Task, Story, Epic, Feature, Sub-task

### Issue: "Description template not found"
**Solution**: Either provide --description directly or ensure jira_issue_template.md exists
