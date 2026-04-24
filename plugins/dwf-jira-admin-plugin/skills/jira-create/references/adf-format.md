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

## Heading

```json
{
  "type": "heading",
  "attrs": {"level": 2},
  "content": [{"type": "text", "text": "Heading text"}]
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
    },
    {
      "type": "listItem",
      "content": [
        {"type": "paragraph", "content": [{"type": "text", "text": "Item 2"}]}
      ]
    }
  ]
}
```

## Code Block

```json
{
  "type": "codeBlock",
  "attrs": {"language": "bash"},
  "content": [{"type": "text", "text": "echo hello"}]
}
```

## Link

```json
{
  "type": "text",
  "text": "Click here",
  "marks": [{"type": "link", "attrs": {"href": "https://example.com"}}]
}
```

## Common Mistakes

- Using a plain string instead of ADF object → 400 Bad Request
- Missing `"version": 1` in the doc root → invalid document
- Using `\n` for line breaks → wrap each line in its own paragraph instead
