# DWF Jira Administrator CLI Usage Reference

## Overview

The DWF Jira Administrator plugin uses either `acli` (Atlassian CLI) or `jira-cli` to manage Jira issues in the DW project on Jira Cloud (redhat.atlassian.net).

## Installation

### acli (Atlassian CLI)

```bash
# macOS
brew install atlassian-cli

# Linux
wget https://bobswift.atlassian.net/wiki/download/attachments/16285695/atlassian-cli-9.7.0-distribution.zip
unzip atlassian-cli-9.7.0-distribution.zip
export PATH=$PATH:~/acli-9.7.0/home/bin
```

### jira-cli

```bash
# npm
npm install -g jira-cli

# Homebrew
brew install jira-cli
```

## Authentication

Both tools require Jira Cloud credentials:

```bash
export JIRA_USER="your-email@redhat.com"
export JIRA_API_TOKEN="your-api-token"
```

Get your API token: https://id.atlassian.com/manage-profile/security/api-tokens

## Core Operations

### Create Issue with acli

```bash
acli \
  --action addIssue \
  --server https://redhat.atlassian.net \
  --project DW \
  --type Task \
  --summary "Issue summary" \
  --description "Issue description" \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### Create Issue with jira-cli

```bash
jira create \
  --server https://redhat.atlassian.net \
  --project DW \
  --type Task \
  --summary "Issue summary" \
  --description "Issue description" \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### Get Issue with acli

```bash
acli \
  --action getIssue \
  --issue DW-123 \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### Get Issue with jira-cli

```bash
jira issue view DW-123 \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### Update Issue with acli

```bash
acli \
  --action updateIssue \
  --issue DW-123 \
  --summary "Updated summary" \
  --description "Updated description" \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### Update Issue with jira-cli

```bash
jira issue edit DW-123 \
  --summary "Updated summary" \
  --description "Updated description" \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### List Issues with acli

```bash
acli \
  --action getIssueList \
  --jql "project = DW AND status = 'To Do'" \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

### List Issues with jira-cli

```bash
jira issue list \
  --jql "project = DW AND status = 'To Do'" \
  --server https://redhat.atlassian.net \
  --user "$JIRA_USER" \
  --password "$JIRA_API_TOKEN"
```

## Common Flags

| Flag | Description |
|------|-------------|
| `--server` | Jira server URL |
| `--project` | Project key |
| `--issue` | Issue key (e.g., DW-123) |
| `--type` | Issue type (Bug, Task, Story, Epic) |
| `--summary` | Issue summary |
| `--description` | Issue description |
| `--assignee` | Assignee username or email |
| `--priority` | Priority (Highest, High, Medium, Low, Lowest) |
| `--user` | Username or email |
| `--password` | API token |
| `--jql` | JQL query string |
| `--raw` | Raw JSON output (jira-cli) |

## DW Project Defaults

- **Space**: Digital Workforce
- **Board**: Digital Workforce Scrum Teams
- **Server**: https://redhat.atlassian.net
- **Project**: DW
- **Default Issue Type**: Task
- **Installation Type**: Cloud

## Tips

1. Always use API tokens, not passwords
2. Export credentials as environment variables
3. Use `--raw` flag for JSON output
4. Test queries locally before bulk operations
5. Use descriptive summaries for searchability
