#!/usr/bin/env bash
set -euo pipefail

JIRA_BASE_URL="https://redhat.atlassian.net"
OK=true

echo "=== DWF Jira Plugin Setup Check ==="
echo

if [ -z "${JIRA_USER:-}" ]; then
  echo "FAIL: JIRA_USER is not set"
  echo "  export JIRA_USER=\"your-email@redhat.com\""
  OK=false
else
  echo "OK:   JIRA_USER = $JIRA_USER"
fi

if [ -z "${JIRA_API_TOKEN:-}" ]; then
  echo "FAIL: JIRA_API_TOKEN is not set"
  echo "  Get one at: https://id.atlassian.com/manage-profile/security/api-tokens"
  echo "  export JIRA_API_TOKEN=\"your-token\""
  OK=false
else
  echo "OK:   JIRA_API_TOKEN is set (hidden)"
fi

if ! command -v curl &>/dev/null; then
  echo "FAIL: curl is not installed"
  OK=false
else
  echo "OK:   curl is available"
fi

if ! command -v python3 &>/dev/null; then
  echo "WARN: python3 not found (used for JSON formatting, not required)"
fi

echo

if [ "$OK" = true ]; then
  echo "Testing connection to $JIRA_BASE_URL ..."
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -u "$JIRA_USER:$JIRA_API_TOKEN" \
    "$JIRA_BASE_URL/rest/api/3/myself")
  if [ "$HTTP_CODE" = "200" ]; then
    echo "OK:   Authenticated successfully"
    DISPLAY_NAME=$(curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" \
      "$JIRA_BASE_URL/rest/api/3/myself" | python3 -c "import sys,json; print(json.load(sys.stdin).get('displayName','unknown'))" 2>/dev/null || echo "unknown")
    echo "  Logged in as: $DISPLAY_NAME"
  else
    echo "FAIL: Authentication failed (HTTP $HTTP_CODE)"
    echo "  Check JIRA_USER and JIRA_API_TOKEN values"
    OK=false
  fi
fi

echo
if [ "$OK" = true ]; then
  echo "All checks passed. Ready to use."
else
  echo "Some checks failed. Fix the issues above and re-run."
  exit 1
fi
