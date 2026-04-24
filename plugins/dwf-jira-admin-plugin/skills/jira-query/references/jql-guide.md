# JQL Quick Reference

## Common Query Patterns

| Intent | JQL |
|--------|-----|
| My open issues | `project = DW AND assignee = currentUser() AND status != Done` |
| All open bugs | `project = DW AND type = Bug AND status != Done` |
| High priority | `project = DW AND priority = High ORDER BY created DESC` |
| Recently updated | `project = DW AND updated >= -7d ORDER BY updated DESC` |
| By assignee | `project = DW AND assignee = "user@redhat.com"` |
| Text search | `project = DW AND summary ~ "search term"` |
| Sprint issues | `project = DW AND sprint in openSprints()` |
| Blocking issues | `project = DW AND status = Blocked ORDER BY created` |
| Unassigned | `project = DW AND assignee IS EMPTY AND status != Done` |
| Created this week | `project = DW AND created >= startOfWeek()` |

## Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equals | `status = "To Do"` |
| `!=` | Not equals | `status != Done` |
| `~` | Contains text | `summary ~ "login"` |
| `!~` | Does not contain | `summary !~ "test"` |
| `IN` | In list | `status IN ("To Do", "In Progress")` |
| `NOT IN` | Not in list | `type NOT IN (Epic, Sub-task)` |
| `IS EMPTY` | No value | `assignee IS EMPTY` |
| `IS NOT EMPTY` | Has value | `assignee IS NOT EMPTY` |
| `>=` | Greater/equal | `created >= -7d` |
| `<=` | Less/equal | `updated <= -30d` |

## Logical Operators

- `AND` — all conditions must match
- `OR` — at least one condition must match
- `NOT` — negate a condition
- Use parentheses for grouping: `(status = "To Do" OR status = "In Progress") AND type = Bug`

## Date Functions

| Function | Meaning |
|----------|---------|
| `currentUser()` | Logged-in user |
| `startOfDay()` | Midnight today |
| `startOfWeek()` | Monday of current week |
| `startOfMonth()` | First of current month |
| `-7d` | 7 days ago |
| `-1w` | 1 week ago |

## Common Fields

| Field | Values |
|-------|--------|
| `project` | `DW` |
| `status` | `To Do`, `In Progress`, `Done`, `Blocked` |
| `type` | `Bug`, `Task`, `Story`, `Epic`, `Sub-task` |
| `priority` | `Highest`, `High`, `Medium`, `Low`, `Lowest` |
| `assignee` | email address or `currentUser()` |
| `labels` | label strings |
| `created` | date or relative (`-7d`) |
| `updated` | date or relative (`-7d`) |

## Syntax Rules

- Quote multi-word values: `status = "In Progress"` (not `status = In Progress`)
- Functions are lowercase: `currentUser()` (not `CURRENT_USER()`)
- Use `!=` for not-equals (not `<>`)
- Always add `ORDER BY` for consistent results
