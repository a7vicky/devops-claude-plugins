# dwf-jira-admin-plugin

A comprehensive Jira administration plugin for the DW project on Jira Cloud (https://redhat.atlassian.net/). Uses MCP (Model Context Protocol) server tools to provide streamlined skills for creating, updating, and querying Jira issues.

## Features

- **MCP-Based Architecture**: Uses Model Context Protocol for direct Jira Cloud integration
- **Complete CRUD Operations**: Create, read, update, and delete Jira issues
- **JQL Query Support**: Advanced issue searching with flexible filtering
- **Structured Responses**: JSON-based responses for programmatic integration
- **Cloud-Ready**: Fully compatible with Jira Cloud (redhat.atlassian.net)
- **No CLI Tools Required**: No need to install acli or jira-cli

## Default Configuration

- **Installation type**: Cloud
- **Jira server**: https://redhat.atlassian.net/
- **Default project**: DW
- **Cloud ID**: 2b9e35e3-6bd3-4cec-b838-f4249ee02432

## Requirements

- MCP server configured with Atlassian Cloud integration
- Jira Cloud access to redhat.atlassian.net
- Proper Jira permissions for the DW project

**No environment variables or CLI tools needed!**

## Skills

This plugin provides three specialized MCP-based skills:

### jira-create - Create Issues

Create new Jira issues with custom descriptions and metadata using MCP tools.

**Use when:**
- Creating new work items
- Adding bugs or feature requests
- Setting up epics or stories

**Example:**
```
createJiraIssue(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  projectKey: "DW",
  summary: "New issue title",
  issueType: "Task",
  description: "Issue description"
)
```

### jira-update - Update Issues

Update existing Jira issues with new information using MCP tools.

**Use when:**
- Fixing typos or clarifications
- Updating issue status or type
- Adding important details

**Example:**
```
editJiraIssue(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  issueId: "DW-123",
  fields: {
    summary: "Updated title"
  }
)
```

### jira-query - Search Issues

Search and query Jira issues using JQL syntax with flexible filtering.

**Use when:**
- Finding issues by various criteria
- Monitoring project status
- Generating reports

**Example:**
```
searchJiraIssuesUsingJql(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  jql: "project = DW AND status = 'To Do'",
  maxResults: 50
)
```

## Usage

### Create an Issue

```
createJiraIssue(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  projectKey: "DW",
  summary: "Example issue summary",
  issueType: "Task",
  description: "Detailed description"
)
```

Optional parameters:
- `assignee` - Account ID of assignee
- `priority` - Priority level (Highest, High, Medium, Low, Lowest)
- `labels` - Array of labels
- `customFields` - Object with custom field IDs and values

### Update an Issue

```
editJiraIssue(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  issueId: "DW-123",
  fields: {
    summary: "Updated summary",
    description: "Updated details",
    priority: "High"
  }
)
```

### Query Issues

```
searchJiraIssuesUsingJql(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  jql: "project = DW AND status != Done ORDER BY priority DESC",
  maxResults: 50
)
```

Or get a single issue:

```
getJiraIssue(
  cloudId: "2b9e35e3-6bd3-4cec-b838-f4249ee02432",
  issueId: "DW-123"
)
```

## MCP Tools Available

The plugin provides access to these MCP Atlassian tools:

- **createJiraIssue** - Create new Jira issues
- **editJiraIssue** - Update existing issues
- **getJiraIssue** - Retrieve issue details
- **searchJiraIssuesUsingJql** - Search using JQL
- **addCommentToJiraIssue** - Add comments to issues
- **transitionJiraIssue** - Change issue workflow state
- **getTransitionsForJiraIssue** - Get available workflow transitions
- **lookupJiraAccountId** - Find account IDs for users
- **getJiraProjectIssueTypesMetadata** - Get issue type information

## Cloud ID

The Jira Cloud ID for redhat.atlassian.net is:
```
2b9e35e3-6bd3-4cec-b838-f4249ee02432
```

Use this value for all MCP operations.

## Reference Materials

This plugin includes comprehensive reference documentation:

### CLI Usage Guide (`reference/cli-usage.md`)
- Command examples for acli and jira-cli (for legacy/fallback support)
- Installation instructions
- Common operations and flags

### Configuration Reference (`reference/configuration.md`)
- Project information and defaults
- Supported issue types
- Jira Cloud details
- Useful links and troubleshooting

## Benefits of MCP Approach

### Compared to CLI Scripts:
- ✅ No external CLI tool installation required
- ✅ Direct Jira Cloud API integration
- ✅ Structured JSON responses for programmatic use
- ✅ Better error handling and feedback
- ✅ Automatic authentication via MCP server
- ✅ Consistent tool interface across all operations

## Tips for Effective Usage

1. **Use descriptive summaries**: Make summaries clear and searchable
2. **Provide complete context**: Include enough detail in descriptions
3. **Set the right type**: Epic for initiatives, Story for features, Task for work
4. **Assign appropriately**: Assign to specific team members when known
5. **Use consistent labels**: Maintain consistent labeling for filtering
6. **Include priority**: Set priority to help with triage and planning
7. **Leverage JQL**: Use powerful JQL queries for complex searches

## Project Structure

```
dwf-jira-admin-plugin/
├── README.md                    # This file
├── plugin.json                  # Plugin manifest with MCP config
├── jira_issue_template.md       # Default issue template (reference)
├── skills/
│   ├── jira-create/SKILL.md     # Create issues skill
│   ├── jira-update/SKILL.md     # Update issues skill
│   └── jira-query/SKILL.md      # Query issues skill
└── reference/
    ├── cli-usage.md             # CLI command reference
    └── configuration.md         # Configuration reference
```

## Related Plugins

- **DWF Jira Administrator Agent**: Main agent for guidance and orchestration
- Other DevOps Claude Plugins: https://github.com/a7vicky/devops-claude-plugins

## Support

For issues or questions, contact the DevOps team.

## Changelog

### v1.0.0
- **NEW**: MCP server-based architecture (replaces CLI scripts)
- **REMOVED**: Shell scripts (create_issue.sh, update_issue.sh, query_issue.sh)
- **UPDATED**: All skills to use MCP Atlassian tools
- **IMPROVED**: No CLI tool dependencies required
- **ENHANCED**: Structured JSON responses for better integration
