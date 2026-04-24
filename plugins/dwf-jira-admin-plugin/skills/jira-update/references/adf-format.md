# Atlassian Document Format (ADF) Reference

Jira Cloud REST API v3 uses ADF for description and comment fields. Plain text strings are not accepted — content must be wrapped in ADF structure.

## Basic Text Paragraph

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [
        {"type": "text", "text": "Your text here"}
      ]
    }
  ]
}
```

## Multiple Paragraphs

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [{"type": "text", "text": "First paragraph"}]
    },
    {
      "type": "paragraph",
      "content": [{"type": "text", "text": "Second paragraph"}]
    }
  ]
}
```

## Bold and Italic Text

```json
{
  "type": "text",
  "text": "bold text",
  "marks": [{"type": "strong"}]
}
```

```json
{
  "type": "text",
  "text": "italic text",
  "marks": [{"type": "em"}]
}
```

## Bullet List

```json
{
  "type": "bulletList",
  "content": [
    {
      "type": "listItem",
      "content": [
        {"type": "paragraph", "content": [{"type": "text", "text": "Item 1"}]}
      ]
    }
  ]
}
```

## Updatable Field Reference

| Field | JSON Key | Value Format |
|-------|----------|-------------|
| Summary | `summary` | Plain string |
| Description | `description` | ADF document |
| Priority | `priority` | `{"name": "High"}` |
| Assignee | `assignee` | `{"id": "account-id"}` |
| Labels | `labels` | `["label1", "label2"]` |
| Components | `components` | `[{"id": "component-id"}]` |

## Common Mistakes

- Using a plain string instead of ADF object → 400 Bad Request
- Missing `"version": 1` in the doc root → invalid document
- Using `\n` for line breaks → wrap each line in its own paragraph instead
