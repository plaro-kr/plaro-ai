#!/bin/sh
# PLARO change notice for Claude Code — CHANGE_BILLING_PLAN §14-3.
#
# Asks PLARO what changed in the project's requirements since this key last heard, and prints the short notice it
# returns (Claude Code adds it to the context), or nothing. Only the key is sent: what the developer typed comes in
# on stdin and is never read. The key goes to curl on stdin, not on its command line. Two seconds at most; any
# failure prints nothing and work goes on.

event="${1:-prompt}"
case "$event" in
    session_start | prompt) ;;
    *) event=prompt ;;
esac

key="${CLAUDE_PLUGIN_OPTION_PLARO_KEY:-$PLARO_KEY}"
[ -n "$key" ] || exit 0
url="${PLARO_CHANGES_URL:-https://plaro.kr/api/dev-ai/v1/changes}"

reply=$(printf 'Authorization: Bearer %s\n' "$key" \
    | curl -s -m 2 -H @- -H 'User-Agent: plaro-claude-plugin/1.0' -w '\n%{http_code}' "$url?event=$event" 2>/dev/null) || exit 0
status=$(printf '%s\n' "$reply" | tail -n 1)
text=$(printf '%s\n' "$reply" | sed '$d')

case "$status" in
    200) printf '%s\n' "$text" ;;
    # A revoked or stopped key says so once, when a session opens — not on every message.
    401 | 403) [ "$event" = session_start ] && [ -n "$text" ] && printf '%s\n' "$text" ;;
esac
exit 0
