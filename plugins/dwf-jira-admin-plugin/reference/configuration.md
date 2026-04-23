# DWF Jira Configuration Reference

## Project Information

| Property | Value |
|----------|-------|
| Space | Digital Workforce |
| Board | Digital Workforce Scrum Teams |
| Project Key | DW |
| Jira Instance | https://redhat.atlassian.net |
| Installation | Cloud |
| API | REST API v3 (`/rest/api/3/`) |

## Required Environment Variables

```bash
export JIRA_USER="your-email@redhat.com"
export JIRA_API_TOKEN="your-api-token"
```

Get token: https://id.atlassian.com/manage-profile/security/api-tokens

## Supported Issue Types

| Type | Description |
|------|-------------|
| Epic | Large initiatives spanning multiple stories |
| Feature | Significant capability or functionality |
| Story | User-facing work item |
| Task | General work item (default) |
| Bug | Defect in existing functionality |
| Sub-task | Breakdown of a parent issue |

## API Endpoints

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Get issue | GET | `/rest/api/3/issue/{key}` |
| Search (JQL) | POST | `/rest/api/3/search` |
| Create issue | POST | `/rest/api/3/issue` |
| Update issue | PUT | `/rest/api/3/issue/{key}` |
| Get transitions | GET | `/rest/api/3/issue/{key}/transitions` |
| Transition issue | POST | `/rest/api/3/issue/{key}/transitions` |
| Add comment | POST | `/rest/api/3/issue/{key}/comment` |
| Search users | GET | `/rest/api/3/user/search?query={email}` |

## Useful Links

- **Jira Instance**: https://redhat.atlassian.net/
- **DW Project Board**: https://redhat.atlassian.net/browse/DW
- **API Tokens**: https://id.atlassian.com/manage-profile/security/api-tokens
- **REST API v3 Docs**: https://developer.atlassian.com/cloud/jira/platform/rest/v3/
- **JQL Reference**: https://support.atlassian.com/jira-cloud-platform/docs/advanced-searching-using-jql/

## Troubleshooting

| Issue | Fix |
|-------|-----|
| 401 Unauthorized | Check `JIRA_USER` and `JIRA_API_TOKEN` |
| 403 Forbidden | Your account lacks permissions for this operation |
| 404 Not Found | Wrong issue key or project key |
| 400 Bad Request | Check JSON payload format (especially ADF for descriptions) |
| `JIRA_USER` not set | `export JIRA_USER="you@redhat.com"` |
| `JIRA_API_TOKEN` not set | Get one from https://id.atlassian.com/manage-profile/security/api-tokens |
